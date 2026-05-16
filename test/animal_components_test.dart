import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: buildAnimalIslandTheme(),
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('AnimalSwitch checked children do not expand to full width', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const AnimalSwitch(
          initialValue: true,
          checkedChild: Text('开'),
          uncheckedChild: Text('关'),
        ),
      ),
    );

    final switchSize = tester.getSize(find.byType(AnimalSwitch));
    final textSize = tester.getSize(find.text('开'));

    expect(switchSize.width, greaterThan(textSize.width));
    expect(switchSize.width, lessThan(90));
  });

  testWidgets('AnimalModal hides footer when footer is null', (tester) async {
    await tester.pumpWidget(
      wrap(
        const Stack(
          children: [
            AnimalModal(
              open: true,
              footer: null,
              typewriter: false,
              child: Text('modal body'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('modal body'), findsOneWidget);
    expect(find.text('取消'), findsNothing);
    expect(find.text('确定'), findsNothing);
  });

  testWidgets('AnimalModal shows two right-aligned action buttons by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const Stack(
          children: [
            AnimalModal(
              open: true,
              typewriter: false,
              child: Text('modal body'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('取消'), findsOneWidget);
    expect(find.text('确定'), findsOneWidget);
  });

  testWidgets('AnimalPullToRefresh triggers callback after pull', (
    tester,
  ) async {
    var refreshCount = 0;

    await tester.pumpWidget(
      wrap(
        SizedBox(
          height: 320,
          child: AnimalPullToRefresh(
            onRefresh: () async {
              refreshCount += 1;
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: 20,
              itemBuilder: (context, index) =>
                  SizedBox(height: 40, child: Text('item $index')),
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(ListView), const Offset(0, 180));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(refreshCount, 1);
  });

  testWidgets('AnimalSlider renders value badge and labels', (tester) async {
    await tester.pumpWidget(
      wrap(
        const SizedBox(
          width: 320,
          child: AnimalSlider(
            initialValue: 42,
            leadingLabel: '低',
            trailingLabel: '高',
          ),
        ),
      ),
    );

    expect(find.text('42'), findsOneWidget);
    expect(find.text('低'), findsOneWidget);
    expect(find.text('高'), findsOneWidget);
  });

  testWidgets('AnimalLoading and AnimalEmptyState render default content', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimalLoading(compact: true),
              SizedBox(height: 12),
              AnimalEmptyState(compact: true),
            ],
          ),
        ),
      ),
    );

    expect(find.text('正在准备'), findsOneWidget);
    expect(find.text('暂时空白'), findsOneWidget);
  });
}
