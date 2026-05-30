import 'package:animal_island_ui_flutter_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('example app boots', (tester) async {
    await tester.pumpWidget(const AnimalIslandExampleApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('开始使用 →'), findsOneWidget);
    expect(find.text('查看 Demo'), findsOneWidget);
  });
}
