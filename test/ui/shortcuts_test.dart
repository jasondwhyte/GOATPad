import 'package:flutter_test/flutter_test.dart';
import 'package:goatpad/src/app.dart';
import 'package:goatpad/src/notepad/notepad.dart';
import 'package:goatpad/src/store/note_store.dart';

Future<Notepad> _pumpApp(WidgetTester tester, NoteStore store) async {
  tester.view.physicalSize = const Size(1280, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final notepad = Notepad.load(store);
  await tester.pumpWidget(GPadApp(notepad: notepad));
  await tester.pump(const Duration(milliseconds: 1));
  return notepad;
}

void main() {
  testWidgets('the sidebar lists one shortcut per line and can hide them', (
    tester,
  ) async {
    final store = NoteStore.inMemory();
    final notepad = await _pumpApp(tester, store);

    expect(find.text('Ctrl+N'), findsOneWidget);
    expect(find.text('New note'), findsOneWidget);
    expect(find.text('Ctrl+Shift+V'), findsOneWidget);
    expect(find.text('Paste as new note'), findsOneWidget);
    expect(find.text('Ctrl+W'), findsOneWidget);
    expect(find.text('Close tab'), findsOneWidget);
    expect(find.text('Ctrl+P'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    // Each on its own line.
    expect(
      tester.getTopLeft(find.text('Ctrl+W')).dy,
      greaterThan(tester.getTopLeft(find.text('Ctrl+Shift+V')).dy),
    );

    await tester.tap(find.byTooltip('Hide keyboard shortcuts'));
    await tester.pump();
    expect(find.text('Ctrl+Shift+V'), findsNothing);
    expect(find.byTooltip('Show keyboard shortcuts'), findsOneWidget);

    // The choice is saved, and a restart keeps it.
    notepad.flush();
    final restarted = await _pumpApp(tester, store);
    expect(restarted.showShortcuts.value, isFalse);
    expect(find.text('Ctrl+Shift+V'), findsNothing);

    await tester.tap(find.byTooltip('Show keyboard shortcuts'));
    await tester.pump();
    expect(find.text('Ctrl+Shift+V'), findsOneWidget);
  });
}
