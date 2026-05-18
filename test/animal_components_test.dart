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

  testWidgets('AnimalBottomSheet renders title, body, and custom footer', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const Stack(
          children: [
            AnimalBottomSheet(
              open: true,
              title: Text('岛屿设置'),
              footer: AnimalBottomSheetActionBar(
                primaryLabel: '保存',
                secondaryLabel: '返回',
              ),
              child: Text('这里可以调整公告板和岛歌设置。'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('岛屿设置'), findsOneWidget);
    expect(find.text('这里可以调整公告板和岛歌设置。'), findsOneWidget);
    expect(find.text('保存'), findsOneWidget);
    expect(find.text('返回'), findsOneWidget);
  });

  testWidgets('AnimalBottomSheet hides close button when disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const Stack(
          children: [
            AnimalBottomSheet(
              open: true,
              showCloseButton: false,
              child: Text('sheet body'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('×'), findsNothing);
    expect(find.text('sheet body'), findsOneWidget);
  });

  testWidgets('AnimalBottomSheet drag gesture triggers close callback', (
    tester,
  ) async {
    var closed = false;

    await tester.pumpWidget(
      wrap(
        Stack(
          children: [
            AnimalBottomSheet(
              open: true,
              title: const Text('可拖拽面板'),
              onClose: () {
                closed = true;
              },
              child: const Text('drag body'),
            ),
          ],
        ),
      ),
    );

    await tester.drag(find.text('可拖拽面板'), const Offset(0, 160));
    await tester.pump();

    expect(closed, isTrue);
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

  testWidgets('AnimalTabs supports horizontal swipe and change callback', (
    tester,
  ) async {
    var activeId = 'fish';

    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 320,
          child: AnimalTabs(
            leafAnimation: false,
            onChanged: (id) {
              activeId = id;
            },
            items: const [
              AnimalTabItem(
                id: 'fish',
                label: Text('鱼类'),
                child: SizedBox(height: 120, child: Text('fish body')),
              ),
              AnimalTabItem(
                id: 'bug',
                label: Text('昆虫'),
                child: SizedBox(height: 180, child: Text('bug body')),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('fish body'), findsOneWidget);
    expect(find.text('bug body'), findsNothing);

    await tester.drag(find.byType(TabBarView), const Offset(-240, 0));
    await tester.pumpAndSettle();

    expect(find.text('fish body'), findsNothing);
    expect(find.text('bug body'), findsOneWidget);
    expect(activeId, 'bug');
  });

  testWidgets('AnimalTabs uses start alignment for scrollable tabs', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 320,
          child: AnimalTabs(
            leafAnimation: false,
            items: const [
              AnimalTabItem(
                id: 'fish',
                label: Text('鱼类'),
                child: SizedBox(height: 120, child: Text('fish body')),
              ),
              AnimalTabItem(
                id: 'bug',
                label: Text('昆虫'),
                child: SizedBox(height: 180, child: Text('bug body')),
              ),
            ],
          ),
        ),
      ),
    );

    final tabBar = tester.widget<TabBar>(find.byType(TabBar));
    expect(tabBar.tabAlignment, TabAlignment.start);
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
