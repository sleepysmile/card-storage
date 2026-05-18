import 'package:card_storage/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Card Storage - Главная'), findsOneWidget);
    expect(find.text('Главная'), findsOneWidget);
    expect(find.text('Настройки'), findsOneWidget);
  });
}
