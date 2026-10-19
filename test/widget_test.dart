import 'package:flutter_test/flutter_test.dart';
import 'package:orivis_fyp/main.dart';
import 'package:orivis_fyp/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('App renders splash screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
