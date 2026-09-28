enum JavaTokenKind { plain, keyword, string, comment, number, annotation }

final class JavaToken {
  const JavaToken(this.text, this.kind);
  final String text;
  final JavaTokenKind kind;
}

List<JavaToken> tokenizeJava(String code) {
  const keywords = {
    'abstract',
    'assert',
    'boolean',
    'break',
    'byte',
    'case',
    'catch',
    'char',
    'class',
    'const',
    'continue',
    'default',
    'do',
    'double',
    'else',
    'enum',
    'extends',
    'final',
    'finally',
    'float',
    'for',
    'if',
    'implements',
    'import',
    'instanceof',
    'int',
    'interface',
    'long',
    'native',
    'new',
    'package',
    'private',
    'protected',
    'public',
    'return',
    'short',
    'static',
    'strictfp',
    'super',
    'switch',
    'synchronized',
    'this',
    'throw',
    'throws',
    'transient',
    'try',
    'void',
    'volatile',
    'while',
    'true',
    'false',
    'null',
    'var',
    'record',
    'sealed',
    'permits',
    'yield',
  };
  final tokens = <JavaToken>[];
  final identifier = RegExp(r'[A-Za-z_$][A-Za-z0-9_$]*');
  final number = RegExp(
    r'(?:0[xX][0-9a-fA-F_]+|0[bB][01_]+|\d[\d_]*(?:\.\d[\d_]*)?(?:[eE][+-]?\d[\d_]*)?)[fFdDlL]?',
  );
  var i = 0;
  while (i < code.length) {
    final start = i;
    var kind = JavaTokenKind.plain;
    if (code.startsWith('//', i)) {
      final end = code.indexOf('\n', i);
      i = end < 0 ? code.length : end;
      kind = JavaTokenKind.comment;
    } else if (code.startsWith('/*', i)) {
      final end = code.indexOf('*/', i + 2);
      i = end < 0 ? code.length : end + 2;
      kind = JavaTokenKind.comment;
    } else if (code.startsWith('"""', i)) {
      i += 3;
      while (i < code.length && !code.startsWith('"""', i)) {
        i += code[i] == '\\' && i + 1 < code.length ? 2 : 1;
      }
      if (i < code.length) i += 3;
      kind = JavaTokenKind.string;
    } else if (code[i] == '"' || code[i] == "'") {
      final quote = code[i++];
      while (i < code.length) {
        if (code[i] == '\\') {
          i += i + 1 < code.length ? 2 : 1;
          continue;
        }
        if (code[i++] == quote) break;
      }
      kind = JavaTokenKind.string;
    } else if (code[i] == '@') {
      i++;
      final match = identifier.matchAsPrefix(code, i);
      if (match != null) i = match.end;
      kind = JavaTokenKind.annotation;
    } else {
      final word = identifier.matchAsPrefix(code, i);
      final numeric = number.matchAsPrefix(code, i);
      if (word != null) {
        i = word.end;
        if (keywords.contains(word[0])) kind = JavaTokenKind.keyword;
      } else if (numeric != null) {
        i = numeric.end;
        kind = JavaTokenKind.number;
      } else {
        i++;
      }
    }
    final text = code.substring(start, i);
    if (tokens.isNotEmpty && tokens.last.kind == kind) {
      final previous = tokens.removeLast();
      tokens.add(JavaToken(previous.text + text, kind));
    } else {
      tokens.add(JavaToken(text, kind));
    }
  }
  return tokens;
}

List<List<JavaToken>> javaTokenLines(String code, {bool highlight = true}) {
  final result = <List<JavaToken>>[[]];
  final tokens = highlight
      ? tokenizeJava(code)
      : [JavaToken(code, JavaTokenKind.plain)];
  for (final token in tokens) {
    final parts = token.text.split('\n');
    for (var index = 0; index < parts.length; index++) {
      if (index > 0) result.add([]);
      result.last.add(JavaToken(parts[index], token.kind));
    }
  }
  return result;
}
