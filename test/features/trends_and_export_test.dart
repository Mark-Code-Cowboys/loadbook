import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loadbook/core/export/export_service.dart';
import 'package:loadbook/data/database/app_database.dart';
import 'package:loadbook/data/providers.dart';
import 'package:loadbook/data/repositories/cartridge_repository.dart';
import 'package:loadbook/data/repositories/component_repository.dart';
import 'package:loadbook/data/repositories/load_repository.dart';
import 'package:loadbook/data/repositories/range_session_repository.dart';
import 'package:loadbook/features/trends/trends_screen.dart';

import '../helpers.dart';

Future<void> seed(AppDatabase db) async {
  final cartridgeId =
      await CartridgeRepository(db).create(name: '.308 Test');
  final components = ComponentRepository(db);
  final bullet = await components.create(const ComponentDraft(
      kind: ComponentKind.bullet,
      maker: 'Testmaker',
      name: 'Match',
      weightGr: 168));
  final powder = await components.create(const ComponentDraft(
      kind: ComponentKind.powder, maker: 'Fakeco', name: 'TP-1'));
  final primer = await components.create(const ComponentDraft(
      kind: ComponentKind.primer, maker: 'Testmaker', name: 'LR'));
  final loads = LoadRepository(db);
  final withSessions = await loads.create(LoadDraft(
    cartridgeId: cartridgeId,
    bulletId: bullet,
    powderId: powder,
    chargeGr: 42.5,
    primerId: primer,
    dateDeveloped: DateTime(2025, 3, 1),
    notes: 'the card',
  ));
  // A second load never taken out — still a CSV row.
  await loads.create(LoadDraft(
    cartridgeId: cartridgeId,
    bulletId: bullet,
    powderId: powder,
    chargeGr: 41.0,
    primerId: primer,
    dateDeveloped: DateTime(2026, 1, 5),
  ));
  await RangeSessionRepository(db).create(SessionDraft(
    loadId: withSessions,
    date: DateTime(2026, 3, 14),
    distanceYd: 100,
    shots: 5,
    groupSizeIn: 1.047,
    chronoSdFps: 8.2,
    weather: 'calm',
    notes: 'windy later',
  ));
}

void main() {
  test('the CSV flattens loads with and without sessions', () async {
    final db = makeTestDb();
    await seed(db);
    final share = FakeShareLauncher();
    final service = ExportService(
        db, share, () async => Directory.systemTemp.createTemp('lb'));

    final file = await service.shareLoadsCsv(now: DateTime(2026, 6, 1));
    expect(share.sharedFiles, [file.path]);
    expect(file.path, endsWith('loadbook-loads-2026-06-01.csv'));

    final lines = file.readAsStringSync().trim().split('\n');
    expect(lines.first,
        startsWith('cartridge,status,bullet,bullet_weight_gr,powder'));
    // One session row, one sessionless row.
    expect(lines, hasLength(3));
    final sessionRow =
        lines.singleWhere((l) => l.contains('2026-03-14'));
    expect(sessionRow, contains('.308 Test'));
    expect(sessionRow, contains('42.5'));
    expect(sessionRow, contains('Fakeco TP-1'));
    expect(sessionRow, contains('the card'));
    // MOA is the recorded arithmetic: 1.047" at 100 yd is 1.000.
    expect(sessionRow, contains('1.000'));
    expect(sessionRow, contains('8.2'));
    final bareRow = lines.singleWhere((l) => l.contains('41.0'));
    expect(bareRow.contains('2026-03-14'), isFalse);

    await db.close();
  });

  test('the backup zip carries the export JSON', () async {
    final db = makeTestDb();
    await seed(db);
    final share = FakeShareLauncher();
    final service = ExportService(
        db, share, () async => Directory.systemTemp.createTemp('lb'));

    final file = await service.shareBackup(
        lifetimeCartridges: 3, now: DateTime(2026, 6, 1));
    final contents = readBackupArchive(file.readAsBytesSync());
    expect(contents.exportData['app'], 'Loadbook');
    expect(contents.exportData['lifetimeCartridges'], 3);
    expect((contents.exportData['loads'] as List), hasLength(2));

    await db.close();
  });

  testWidgets('free users get the teaser; restore is never gated',
      (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const TrendsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('The long arc of your load development.'),
        findsOneWidget);
    expect(find.text('Restore a backup'), findsOneWidget);
    expect(find.text('The notebook so far'), findsNothing);
    await disposeApp(tester);
    await db.close();
  });

  testWidgets('Pro sees the long view and shares the CSV from it',
      (tester) async {
    final db = makeTestDb();
    await seed(db);
    final share = FakeShareLauncher();
    await tester.pumpWidget(testApp(
      db: db,
      entitled: true,
      home: const TrendsScreen(),
      overrides: [
        shareLauncherProvider.overrideWithValue(share),
        // Sync creation: real async IO never completes in the
        // widget-test fake zone (drift-stream-test-gotchas).
        tempDirProvider.overrideWithValue(
            () async => Directory.systemTemp.createTempSync('lb')),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('1 cartridge'), findsOneWidget);
    expect(find.textContaining('2 loads'), findsOneWidget);
    // Per-cartridge development bars: 2025 and 2026 each hold one.
    expect(find.text('.308 Test'), findsOneWidget);
    expect(find.text('2025'), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);

    await tester.ensureVisible(find.text('Share loads as CSV'));
    await tester.tap(find.text('Share loads as CSV'));
    await tester.pumpAndSettle();
    expect(share.sharedFiles, hasLength(1));

    await disposeApp(tester);
    await db.close();
  });
}
