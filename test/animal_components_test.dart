import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: buildAnimalIslandTheme(),
      home: Scaffold(body: Center(child: child)),
    );
  }

  Widget wrapNes(Widget child) {
    return MaterialApp(
      theme: buildAnimalIslandTheme(gameStyle: AnimalIslandGameStyle.nes8Bit),
      home: Scaffold(body: Center(child: child)),
    );
  }

  Widget wrapWestworld(Widget child) {
    return MaterialApp(
      theme: buildAnimalIslandTheme(gameStyle: AnimalIslandGameStyle.westworld),
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

  testWidgets('NES switch loading avoids Material circular spinner', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapNes(const AnimalSwitch(initialValue: true, loading: true)),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('Dashed card centers its child content', (tester) async {
    await tester.pumpWidget(
      wrapNes(
        const SizedBox(
          width: 240,
          height: 120,
          child: AnimalCard(type: AnimalCardType.dashed, child: Text('居中')),
        ),
      ),
    );

    final cardCenter = tester.getCenter(find.byType(AnimalCard));
    final textCenter = tester.getCenter(find.text('居中'));

    expect((cardCenter.dx - textCenter.dx).abs(), lessThan(1));
    expect((cardCenter.dy - textCenter.dy).abs(), lessThan(1));
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

  testWidgets('Westworld modal primary footer keeps readable foreground', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWestworld(
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

    expect(find.text('确定'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Westworld button variants and loading render without geometry errors',
    (tester) async {
      await tester.pumpWidget(
        wrapWestworld(
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: () {},
                child: const Text('Primary'),
              ),
              AnimalButton(
                type: AnimalButtonType.defaultType,
                onPressed: () {},
                child: const Text('Default'),
              ),
              AnimalButton(
                type: AnimalButtonType.dashed,
                onPressed: () {},
                child: const Text('Dashed'),
              ),
              AnimalButton(
                type: AnimalButtonType.text,
                onPressed: () {},
                child: const Text('Text'),
              ),
              AnimalButton(
                type: AnimalButtonType.link,
                onPressed: () {},
                child: const Text('Link'),
              ),
              AnimalButton(
                type: AnimalButtonType.primary,
                loading: true,
                onPressed: () {},
                child: const Text('Loading'),
              ),
            ],
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 120));
      await tester.pump(const Duration(milliseconds: 120));

      expect(find.text('Loading'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

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

  testWidgets('Westworld bottom sheet, switch, and status states render', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWestworld(
        const Stack(
          children: [
            AnimalBottomSheet(
              open: true,
              title: Text('CONTROL VECTOR'),
              showCloseButton: true,
              child: Text('Narrative controls are available.'),
            ),
            Positioned.fill(
              top: 220,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    AnimalSwitch(initialValue: true, loading: true),
                    SizedBox(height: 24),
                    AnimalLoading(compact: true),
                    SizedBox(height: 24),
                    AnimalErrorState(compact: true),
                    SizedBox(height: 24),
                    AnimalEmptyState(compact: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text('CONTROL VECTOR'), findsOneWidget);
    expect(find.byType(AnimalSwitch), findsOneWidget);
    expect(find.byType(AnimalLoading), findsOneWidget);
    expect(find.byType(AnimalErrorState), findsOneWidget);
    expect(find.byType(AnimalEmptyState), findsOneWidget);
    expect(tester.takeException(), isNull);
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

  testWidgets('Westworld refresh and load-more remove island copy/assets', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWestworld(
        SizedBox(
          height: 360,
          child: Column(
            children: [
              Expanded(
                child: AnimalPullToRefresh(
                  onRefresh: () async {},
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) =>
                        SizedBox(height: 48, child: Text('node $index')),
                  ),
                ),
              ),
              const AnimalLoadMoreFooter(state: AnimalLoadMoreState.loading),
            ],
          ),
        ),
      ),
    );

    await tester.drag(find.byType(ListView), const Offset(0, 120));
    await tester.pump();

    expect(find.textContaining('island', findRichText: true), findsNothing);
    expect(find.textContaining('Tom Nook', findRichText: true), findsNothing);
    expect(find.textContaining('Kapp', findRichText: true), findsNothing);
    expect(find.text('ACQUIRING NEXT VECTOR'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Westworld checkbox group uses custom HUD tiles', (tester) async {
    await tester.pumpWidget(
      wrapWestworld(
        AnimalCheckboxGroup<String>(
          defaultValues: const ['host'],
          options: const [
            AnimalCheckboxOption(value: 'host', label: Text('HOST')),
            AnimalCheckboxOption(value: 'guest', label: Text('GUEST')),
          ],
        ),
      ),
    );

    expect(find.byIcon(Icons.check_rounded), findsNothing);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.text('HOST'), findsOneWidget);
    expect(tester.takeException(), isNull);
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

  testWidgets('Westworld slider renders calibrated system track', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWestworld(
        const SizedBox(
          width: 320,
          child: AnimalSlider(
            initialValue: 42,
            leadingLabel: 'LOW',
            trailingLabel: 'HIGH',
            divisions: 10,
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text('42'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AnimalDateTimePicker hour wheel supports multi-step fling', (
    tester,
  ) async {
    var selected = DateTime(2026, 5, 18, 10, 0);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAnimalIslandTheme(),
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Center(
                child: SizedBox(
                  width: 320,
                  child: AnimalDateTimePicker(
                    mode: AnimalDateTimePickerMode.time,
                    value: selected,
                    onChanged: (value) {
                      setState(() => selected = value);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.fling(
      find.byType(ListWheelScrollView).first,
      const Offset(0, -320),
      2400,
    );
    await tester.pumpAndSettle();

    expect((selected.hour - 10).abs(), greaterThan(1));
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

  testWidgets('NES status states use pixel painters instead of image assets', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapNes(
        const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimalLoading(compact: true),
              SizedBox(height: 12),
              AnimalEmptyState(compact: true),
              SizedBox(height: 12),
              AnimalErrorState(compact: true),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(Image), findsNothing);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('Westworld date time picker renders system headers and wheels', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWestworld(
        SizedBox(
          width: 420,
          child: AnimalDateTimePicker(
            value: DateTime(2026, 5, 23, 14, 30),
            mode: AnimalDateTimePickerMode.dateTime,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('CALENDAR VECTOR'), findsOneWidget);
    expect(find.text('TIME WINDOW'), findsOneWidget);
    expect(find.text('2026.05'), findsOneWidget);
    expect(find.text('14:30'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Westworld and NES footers use custom painters', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            Theme(
              data: buildAnimalIslandTheme(
                gameStyle: AnimalIslandGameStyle.westworld,
              ),
              child: const AnimalFooter(type: AnimalFooterType.tree),
            ),
            Theme(
              data: buildAnimalIslandTheme(
                gameStyle: AnimalIslandGameStyle.nes8Bit,
              ),
              child: const AnimalFooter(type: AnimalFooterType.sea),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(CustomPaint), findsAtLeastNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Westworld icon and collapse use HUD rendering', (tester) async {
    await tester.pumpWidget(
      wrapWestworld(
        const Column(
          children: [
            AnimalIcon(name: AnimalIconName.map, size: 32),
            SizedBox(height: 12),
            AnimalCollapse(
              question: Text('CONTROL LOOP'),
              answer: Text('Branch detail panel.'),
              defaultExpanded: true,
            ),
          ],
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsNothing);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.text('CONTROL LOOP'), findsOneWidget);
    expect(find.text('Branch detail panel.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
