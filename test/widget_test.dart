import 'package:flutter_test/flutter_test.dart';
import 'package:ai_photo_editor/main.dart';

void main() {
  testWidgets(
    'AI Photo Editor starts correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const AIPhotoEditorApp(),
      );

      expect(
        find.text('AI Photo Editor'),
        findsOneWidget,
      );

      expect(
        find.text('Choose a Photo'),
        findsOneWidget,
      );
    },
  );
}
