import {execFileSync} from 'node:child_process';
import {fileURLToPath} from 'node:url';

const root = fileURLToPath(new URL('../', import.meta.url));
execFileSync('ffmpeg', [
  '-y', '-hide_banner', '-loglevel', 'warning', '-i', 'aiva-demo.mp4',
  '-filter_complex', '[0:v]fps=12,scale=800:450:flags=lanczos,split[a][b];[a]palettegen=stats_mode=diff[p];[b][p]paletteuse=dither=bayer:bayer_scale=4:diff_mode=rectangle',
  '-loop', '0', 'aiva-preview.gif',
], {cwd: root, stdio: 'inherit'});
