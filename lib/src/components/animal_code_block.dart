import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';

class AnimalCodeBlock extends StatelessWidget {
  const AnimalCodeBlock({
    super.key,
    required this.code,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  });

  final String code;
  final EdgeInsetsGeometry padding;

  static const Map<String, Color> _colors = <String, Color>{
    'comment': Color(0xFF6B5E50),
    'string': Color(0xFFA8D4A0),
    'keyword': Color(0xFFD4A0E0),
    'react': Color(0xFFE06C75),
    'component': Color(0xFF80C0E0),
    'func': Color(0xFF61AFEF),
    'prop': Color(0xFFE8C87A),
    'jsx': Color(0xFFF0A870),
    'operator': Color(0xFFD4B896),
    'number': Color(0xFFA8D4A0),
    'default': Color(0xFFE8D5BC),
  };

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.codeBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.codeBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: SelectableText.rich(
          TextSpan(
            style: TextStyle(
              color: _colors['default'],
              fontFamily: 'monospace',
              fontSize: AnimalIslandTokens.fontLabel,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
            children: _highlight(code),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _highlight(String value) {
    final spans = <_CodeToken>[];

    void addPattern(RegExp regex, String key) {
      final re = RegExp(
        regex.pattern,
        multiLine: regex.isMultiLine,
        caseSensitive: regex.isCaseSensitive,
        dotAll: regex.isDotAll,
      );
      for (final match in re.allMatches(value)) {
        spans.add(
          _CodeToken(start: match.start, end: match.end, color: _colors[key]!),
        );
      }
    }

    addPattern(RegExp(r'/\*[\s\S]*?\*/'), 'comment');
    addPattern(RegExp(r'//.*$', multiLine: true), 'comment');
    addPattern(RegExp(r'`[^`]*`'), 'string');
    addPattern(RegExp(r'"[^"]*"'), 'string');
    addPattern(RegExp(r"'[^']*'"), 'string');
    addPattern(RegExp(r'<\/?[A-Z][\w.$]*'), 'jsx');
    addPattern(RegExp(r'<\/?[a-z][\w-]*'), 'jsx');
    addPattern(RegExp(r'\/?>'), 'jsx');
    addPattern(
      RegExp(
        r'\b(React|useState|useEffect|useCallback|useMemo|useRef|useContext|lazy|Suspense|memo|forwardRef|FC|Widget|BuildContext|StatefulWidget|StatelessWidget)\b',
      ),
      'react',
    );
    addPattern(RegExp(r'\b(true|false|null|undefined)\b'), 'keyword');
    addPattern(RegExp(r'\b\d+\.?\d*\b'), 'number');
    addPattern(
      RegExp(
        r'\b(import|from|as|export|default|const|let|var|function|return|if|else|for|while|switch|case|break|continue|try|catch|throw|finally|new|typeof|async|await|class|enum|extends|required)\b',
      ),
      'keyword',
    );
    addPattern(RegExp(r'\b[A-Z][a-zA-Z0-9_$]*\b'), 'component');
    addPattern(RegExp(r'\b[a-z][a-zA-Z0-9_$]*\s*(?=\()'), 'func');
    addPattern(RegExp(r'\b[a-zA-Z_$][\w$]*\s*(?==)'), 'prop');
    addPattern(
      RegExp(r'[{}[\]();,]|===|!==|==|!=|<=|>=|&&|\|\||[+\-*/%=<>!&|^~?:]'),
      'operator',
    );

    spans.sort((a, b) => a.start.compareTo(b.start));

    final result = <TextSpan>[];
    var cursor = 0;
    for (final token in spans) {
      if (token.start < cursor) {
        continue;
      }
      if (token.start > cursor) {
        result.add(
          TextSpan(
            text: value.substring(cursor, token.start),
            style: TextStyle(color: _colors['default']),
          ),
        );
      }
      result.add(
        TextSpan(
          text: value.substring(token.start, token.end),
          style: TextStyle(color: token.color),
        ),
      );
      cursor = token.end;
    }

    if (cursor < value.length) {
      result.add(
        TextSpan(
          text: value.substring(cursor),
          style: TextStyle(color: _colors['default']),
        ),
      );
    }
    return result;
  }
}

class _CodeToken {
  const _CodeToken({
    required this.start,
    required this.end,
    required this.color,
  });

  final int start;
  final int end;
  final Color color;
}
