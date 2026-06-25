import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex/main.dart';

void main() {
  testWidgets('PokedexApp loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PokedexApp());

    // Verify that the title is present.
    expect(find.text('Pokedex'), findsWidgets);
    expect(find.text('Pro'), findsWidgets);
  });
}
