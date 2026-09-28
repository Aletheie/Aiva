import 'dart:convert';

/// Duplicate keys are rejected before jsonDecode can silently keep the last one.
/// The SDK parser still validates complete JSON syntax, escapes and number forms.
Map<String, Object?> decodeObject(String text, String source) {
  if (utf8.encode(text).length > 8 * 1024 * 1024) {
    throw FormatException('$source: JSON přesahuje 8 MiB.');
  }
  _Guard(text, source).check();
  final Object? decoded;
  try {
    decoded = jsonDecode(text);
  } on FormatException catch (e) {
    throw FormatException('$source: ${e.message}', text, e.offset);
  }
  if (decoded is! Map<String, Object?>) {
    throw FormatException('$source: kořenem JSON musí být objekt.');
  }
  return decoded;
}

class _Guard {
  _Guard(this.text, this.source);
  final String text;
  final String source;
  int pos = 0;
  Never error(String message) =>
      throw FormatException('$source: $message', text, pos);
  void whitespace() {
    while (pos < text.length && ' \t\r\n'.contains(text[pos])) {
      pos++;
    }
  }

  void check() {
    value(0);
    whitespace();
    if (pos != text.length) error('Data za koncem JSON.');
  }

  String string() {
    if (pos >= text.length || text[pos] != '"') error('Očekáván řetězec.');
    final start = pos++;
    while (pos < text.length) {
      if (text[pos] == '\\') {
        pos += 2;
        continue;
      }
      if (text[pos++] == '"') {
        try {
          return jsonDecode(text.substring(start, pos)) as String;
        } on FormatException {
          error('Neplatný řetězec.');
        }
      }
    }
    error('Neukončený řetězec.');
  }

  void value(int depth) {
    if (depth > 64) error('JSON je zanořený hlouběji než 64 úrovní.');
    whitespace();
    if (pos >= text.length) error('Neočekávaný konec JSON.');
    final c = text[pos];
    if (c == '"') {
      string();
      return;
    }
    if (c == '{') {
      pos++;
      whitespace();
      final keys = <String>{};
      if (pos < text.length && text[pos] == '}') {
        pos++;
        return;
      }
      while (true) {
        whitespace();
        final key = string();
        if (!keys.add(key)) error('Duplicitní klíč "$key".');
        whitespace();
        if (pos >= text.length || text[pos++] != ':') error('Chybí dvojtečka.');
        value(depth + 1);
        whitespace();
        if (pos >= text.length) error('Neukončený objekt.');
        final end = text[pos++];
        if (end == '}') return;
        if (end != ',') error('Chybí čárka.');
      }
    }
    if (c == '[') {
      pos++;
      whitespace();
      if (pos < text.length && text[pos] == ']') {
        pos++;
        return;
      }
      while (true) {
        value(depth + 1);
        whitespace();
        if (pos >= text.length) error('Neukončené pole.');
        final end = text[pos++];
        if (end == ']') return;
        if (end != ',') error('Chybí čárka.');
      }
    }
    final start = pos;
    while (pos < text.length && !' \t\r\n,]}'.contains(text[pos])) {
      pos++;
    }
    if (start == pos) error('Chybí hodnota.');
    // jsonDecode validates the scalar after the duplicate/depth pass.
  }
}

final class JsonFields {
  JsonFields(this.data, this.source, Set<String> allowed) {
    final extra = data.keys.toSet().difference(allowed);
    if (extra.isNotEmpty) fail('Neznámá pole: ${extra.join(', ')}.');
  }
  final Map<String, Object?> data;
  final String source;
  Never fail(String message) => throw FormatException('$source: $message');
  String text(String key, {bool empty = false, String? fallback}) {
    final value = data[key] ?? fallback;
    if (value is! String || (!empty && value.trim().isEmpty)) {
      fail('"$key" musí být ${empty ? '' : 'neprázdný '}řetězec.');
    }
    return value;
  }

  int integer(String key, {int min = 0, int max = 100000}) {
    final value = data[key];
    if (value is! int || value < min || value > max) {
      fail('"$key" musí být celé číslo $min až $max.');
    }
    return value;
  }

  bool boolean(String key, {bool fallback = false}) {
    if (!data.containsKey(key)) return fallback;
    final value = data[key];
    if (value is! bool) fail('"$key" musí být boolean.');
    return value;
  }

  List<Object?> array(String key, {bool optional = false}) {
    final value = data[key];
    if (value == null && optional) return const [];
    if (value is! List<Object?>) fail('"$key" musí být pole.');
    return value;
  }

  List<String> strings(String key, {bool optional = false}) {
    final value = array(key, optional: optional);
    if (value.any((e) => e is! String || e.trim().isEmpty)) {
      fail('"$key" musí obsahovat neprázdné řetězce.');
    }
    return List.unmodifiable(value.cast<String>());
  }

  Map<String, Object?> object(String key) =>
      asObject(data[key], '$source.$key');
}

Map<String, Object?> asObject(Object? value, String source) {
  if (value is! Map<String, Object?>) {
    throw FormatException('$source: očekáván objekt.');
  }
  return value;
}
