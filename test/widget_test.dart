import 'package:flutter_test/flutter_test.dart';

import 'package:fresh_home/main.dart';

void main() {
  testWidgets('App renders role selector', (WidgetTester tester) async {
    await tester.pumpWidget(const FreshHomeApp());
    await tester.pump();
    expect(find.text('Fresh Home'), findsOneWidget);
  });
}
