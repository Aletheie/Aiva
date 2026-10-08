#!/usr/bin/env python3
"""Compose AIVA's original ambient bed using only Python's standard library.

No samples, third-party compositions, accounts, credentials, or downloads are
used. FFmpeg performs resampling and two-pass loudness mastering. Edit CONFIG,
CHORDS, BASS, or PLUCKS below, then run this file from any working directory.
"""

from array import array
import json
import math
from pathlib import Path
import random
import re
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "public" / "audio" / "aiva-bed.wav"
PROVENANCE = OUTPUT.with_suffix(".provenance.json")
CONFIG = {
    "title": "Quiet Workspace",
    "duration_seconds": 20,
    "sample_rate": 48000,
    "synthesis_sample_rate": 24000,
    "channels": 2,
    "tempo_bpm": 96,
    "tonality": "D minor, extended suspended voicings",
    "seed": 24096,
    "target_integrated_lufs": -24,
    "true_peak_ceiling_dbtp": -5,
    "fade_in_seconds": 0.7,
    "fade_out_start_seconds": 18.55,
    "lift_start_seconds": 7,
    "lift_end_seconds": 8.3,
}
# MIDI pitches, deliberately voiced above the soft bass so speech has space.
CHORDS = [
    (0.0, 5.0, [57, 60, 64, 65], "Dm(add9)"),
    (5.0, 5.0, [53, 57, 60, 62], "Bbmaj9"),
    (10.0, 5.0, [53, 57, 58, 62], "Gm9"),
    (15.0, 2.5, [55, 59, 62, 64], "A9sus4"),
    (17.5, 2.5, [53, 57, 62, 64], "Dm(add9) resolution"),
]
BASS = [(0, 38), (2.5, 38), (5, 34), (7.5, 34),
        (10, 31), (12.5, 31), (15, 33), (17.5, 38)]
PLUCKS = [(1.875, 69, -0.25), (3.125, 76, 0.30),
          (5.625, 74, -0.20), (7.5, 69, 0.24),
          (10.625, 74, -0.27), (12.5, 69, 0.28),
          (15.625, 71, -0.18), (17.5, 69, 0.15),
          (18.125, 74, -0.10)]


def smooth(t):
    t = max(0.0, min(1.0, t))
    return t * t * t * (t * (t * 6 - 15) + 10)


def frequency(midi):
    return 440.0 * 2 ** ((midi - 69) / 12)


def compose():
    sr = CONFIG["synthesis_sample_rate"]
    length = round(CONFIG["duration_seconds"] * sr)
    left, right = array("f", [0]) * length, array("f", [0]) * length
    rng = random.Random(CONFIG["seed"])
    tau = math.tau

    def add(start, duration, make_sample, pan, level):
        begin = round(start * sr)
        end = min(length, begin + round(duration * sr))
        gain_l = level * math.sqrt((1 - pan) / 2)
        gain_r = level * math.sqrt((1 + pan) / 2)
        for index in range(max(0, begin), end):
            value = make_sample((index - begin) / sr)
            left[index] += value * gain_l
            right[index] += value * gain_r

    for start, duration, notes, _name in CHORDS:
        for voice, midi in enumerate(notes):
            hz = frequency(midi)
            phase = rng.uniform(0, tau)
            detune = 2 ** (rng.uniform(2.5, 4.0) / 1200)
            pan = [-0.60, 0.35, -0.20, 0.65][voice]

            def pad(t, hz=hz, phase=phase, detune=detune, duration=duration):
                envelope = smooth(t / 1.15) * (1 - smooth((t - duration) / 1.1))
                breathing = 0.94 + 0.06 * math.sin(tau * 0.13 * t + phase)
                fundamental = (math.sin(tau * hz * detune * t + phase)
                               + math.sin(tau * hz / detune * t + phase + 0.3)) * 0.44
                warmth = 0.08 * math.sin(tau * 2 * hz * t + phase)
                air = 0.018 * math.sin(tau * 3 * hz * t + phase)
                return (fundamental + warmth + air) * envelope * breathing

            add(start, duration + 1.1, pad, pan, 0.050)

    for start, midi in BASS:
        hz = frequency(midi)

        def bass(t, hz=hz):
            envelope = smooth(t / 0.065) * math.exp(-t / 0.68) * (1 - smooth((t - 1.45) / 0.5))
            return envelope * (0.8 * math.sin(tau * hz * t)
                               + 0.17 * math.sin(tau * 2 * hz * t)
                               + 0.03 * math.sin(tau * 3 * hz * t))

        add(start, 1.95, bass, 0, 0.115 * rng.uniform(0.94, 1.02))

    for start, midi, pan in PLUCKS:
        hz = frequency(midi)
        velocity = rng.uniform(0.89, 1.04)

        def pluck(t, hz=hz):
            envelope = smooth(t / 0.012) * math.exp(-t / 0.62) * (1 - smooth((t - 2) / 0.6))
            # Near-harmonic partials create a soft struck-glass character.
            tone = (math.sin(tau * hz * t)
                    + 0.19 * math.sin(tau * hz * 2.003 * t) * math.exp(-t / 0.22)
                    + 0.04 * math.sin(tau * hz * 3.997 * t) * math.exp(-t / 0.12))
            return tone * envelope

        add(start + rng.uniform(-0.010, 0.010), 2.6, pluck, pan, 0.036 * velocity)

    # A small, diffuse synthetic room. Four damped feedback lines per channel
    # produce an organic tail rather than recognizable rhythmic delay repeats.
    def room(signal, offsets):
        wet = array("f", [0]) * length
        for delay, feedback in offsets:
            count = round(delay * sr)
            buffer = array("f", [0]) * count
            lowpass = 0.0
            pointer = 0
            for index in range(length):
                delayed = buffer[pointer]
                lowpass += 0.24 * (delayed - lowpass)
                buffer[pointer] = signal[index] + lowpass * feedback
                wet[index] += delayed * 0.25
                pointer += 1
                if pointer == count:
                    pointer = 0
        return wet

    room_l = room(left, [(0.0431, 0.77), (0.0593, 0.75), (0.0719, 0.72), (0.0897, 0.69)])
    room_r = room(right, [(0.0473, 0.77), (0.0617, 0.75), (0.0737, 0.72), (0.0971, 0.69)])
    interleaved = array("f", [0]) * (length * 2)
    for index in range(length):
        t = index / sr
        fade = smooth(t / CONFIG["fade_in_seconds"])
        fade *= 1 - smooth((t - CONFIG["fade_out_start_seconds"]) /
                            (CONFIG["duration_seconds"] - CONFIG["fade_out_start_seconds"]))
        lift = 0.86 + 0.14 * smooth((t - CONFIG["lift_start_seconds"]) /
                                    (CONFIG["lift_end_seconds"] - CONFIG["lift_start_seconds"]))
        lift -= 0.08 * smooth((t - 16.9) / 1.1)
        gain = fade * lift
        interleaved[index * 2] = (0.88 * left[index] + 0.16 * room_l[index] + 0.06 * room_r[index]) * gain
        interleaved[index * 2 + 1] = (0.88 * right[index] + 0.16 * room_r[index] + 0.06 * room_l[index]) * gain
    if sys.byteorder != "little":
        interleaved.byteswap()
    return interleaved.tobytes()


def loudness(path, raw=False):
    args = ["ffmpeg", "-hide_banner", "-nostats"]
    if raw:
        args += ["-f", "f32le", "-ar", str(CONFIG["synthesis_sample_rate"]), "-ac", "2"]
    filter_spec = (f"loudnorm=I={CONFIG['target_integrated_lufs']}:"
                   f"TP={CONFIG['true_peak_ceiling_dbtp']}:LRA=9:print_format=json")
    args += ["-i", str(path), "-af", filter_spec, "-f", "null", "-"]
    result = subprocess.run(args, check=True, capture_output=True, text=True)
    return json.loads(re.findall(r"\{[^{}]+\}", result.stderr)[-1])


def main():
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="aiva-original-music-") as temporary:
        raw = Path(temporary) / "composition.f32"
        raw.write_bytes(compose())
        measured = loudness(raw, raw=True)
        normalization = (
            f"loudnorm=I={CONFIG['target_integrated_lufs']}:"
            f"TP={CONFIG['true_peak_ceiling_dbtp']}:LRA=9:linear=true:"
            f"measured_I={measured['input_i']}:measured_TP={measured['input_tp']}:"
            f"measured_LRA={measured['input_lra']}:measured_thresh={measured['input_thresh']}:"
            f"offset={measured['target_offset']}"
        )
        subprocess.run([
            "ffmpeg", "-hide_banner", "-loglevel", "error", "-y",
            "-f", "f32le", "-ar", str(CONFIG["synthesis_sample_rate"]), "-ac", "2", "-i", str(raw),
            "-af", normalization, "-ar", str(CONFIG["sample_rate"]), "-ac", "2",
            "-t", str(CONFIG["duration_seconds"]), "-c:a", "pcm_s24le", str(OUTPUT),
        ], check=True)
    final = loudness(OUTPUT)
    provenance = {
        "origin": "Original procedural composition created specifically for the AIVA demonstration.",
        "external_samples_or_music": False,
        "generator": "tools/generate-demo-music.py",
        "dependencies": ["Python standard library", "locally installed FFmpeg"],
        "config": CONFIG,
        "chords": [{"start": a, "duration": b, "midi_notes": c, "name": d} for a, b, c, d in CHORDS],
        "bass_events": [{"time": t, "midi": midi} for t, midi in BASS],
        "pluck_events": [{"time": t, "midi": midi, "pan": pan} for t, midi, pan in PLUCKS],
        "master": {"format": "WAV / 24-bit PCM", "duration_seconds": CONFIG["duration_seconds"],
                   "integrated_lufs": float(final["input_i"]),
                   "true_peak_dbtp": float(final["input_tp"]),
                   "loudness_range_lu": float(final["input_lra"])},
    }
    PROVENANCE.write_text(json.dumps(provenance, indent=2) + "\n")
    print(json.dumps({"audio": str(OUTPUT), "provenance": str(PROVENANCE), "master": provenance["master"]}, indent=2))


if __name__ == "__main__":
    main()
