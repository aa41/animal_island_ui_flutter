import 'package:flutter/material.dart';

import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';

class DemoSection extends StatelessWidget {
  const DemoSection({
    super.key,
    required this.title,
    required this.tag,
    required this.description,
    required this.children,
  });

  final String title;
  final String tag;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return AnimalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(width: 8),
              AnimalBadge(label: tag),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: theme.textSecondary),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

class DemoLabel extends StatelessWidget {
  const DemoLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: context.animalIslandTheme.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class DemoBox extends StatelessWidget {
  const DemoBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.borderLight.withValues(alpha: 0.8)),
      ),
      child: child,
    );
  }
}

class DemoApiRow {
  const DemoApiRow({
    required this.prop,
    required this.desc,
    required this.type,
    this.defaultValue = '-',
    this.required = false,
  });

  final String prop;
  final String desc;
  final String type;
  final String defaultValue;
  final bool required;
}

class DemoApiTable extends StatelessWidget {
  const DemoApiTable({super.key, required this.rows});

  final List<DemoApiRow> rows;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final headerStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: const Color(0xFFE8D5BC),
      fontWeight: FontWeight.w600,
    );
    final cellStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: const Color(0xFFC8BBA8));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const AnimalBadge(
          label: 'API',
          backgroundColor: Color(0xFF3D3028),
          foregroundColor: Color(0xFFE7E4E0),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.codeBackground,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(1.3),
              2: FlexColumnWidth(1.2),
              3: IntrinsicColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFF3D3028)),
                children: [
                  _tableCell('属性', headerStyle),
                  _tableCell('说明', headerStyle),
                  _tableCell('类型', headerStyle),
                  _tableCell('默认值', headerStyle),
                ],
              ),
              for (final row in rows)
                TableRow(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFF3D3028))),
                  ),
                  children: [
                    _tableCell(
                      row.required ? '${row.prop} *' : row.prop,
                      cellStyle?.copyWith(color: const Color(0xFFE8C87A)),
                    ),
                    _tableCell(row.desc, cellStyle),
                    _tableCell(
                      row.type,
                      cellStyle?.copyWith(color: const Color(0xFFD4A0E0)),
                    ),
                    _tableCell(
                      row.defaultValue,
                      cellStyle?.copyWith(color: const Color(0xFFA8D4A0)),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tableCell(String text, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(text, style: style),
    );
  }
}

class DemoCodeBlock extends StatelessWidget {
  const DemoCodeBlock(this.code, {super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 36),
        const AnimalBadge(
          label: '使用示例',
          backgroundColor: Color(0xFF3D3028),
          foregroundColor: Color(0xFFE7E4E0),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        const SizedBox(height: 0),
        const SizedBox(height: 8),
        AnimalCodeBlock(code: code),
      ],
    );
  }
}
