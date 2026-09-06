import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/cartridge_repository.dart';
import '../../data/repositories/component_repository.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../data/repositories/load_repository.dart';
import '../../data/repositories/range_session_repository.dart';
import 'app_database.dart';

/// Screenshot data. Runs when the app is launched with
/// `--dart-define=DEMO_SEED=true` and the database is empty.
///
/// Rails §1: everything here is unmistakably fictional. Cartridges no
/// reloader could mistake for real ones, made-up makers, and charges
/// as repeating-digit placeholders (11.1 / 22.2 / 33.3 gr — the
/// "555-0100" of grain weights). Nothing anyone could transcribe as a
/// recipe. Never ship this flag (release-checklist.md).
Future<void> seedDemoData(AppDatabase db, {PhotoService? photos}) async {
  if ((await db.select(db.cartridges).get()).isNotEmpty) return;

  final cartridges = CartridgeRepository(db);
  final components = ComponentRepository(db);
  final loads = LoadRepository(db);
  final sessions = RangeSessionRepository(db);
  final inventory = InventoryRepository(db);

  final fable = await cartridges.create(
      name: '.30 Fable', notes: 'The demo chapter.');
  final folktale = await cartridges.create(name: '6.5 Folktale');

  final px7 = await components.create(const ComponentDraft(
      kind: ComponentKind.powder,
      maker: 'Ponderosa',
      name: 'PX-7',
      lot: 'DEMO-1'));
  final skippingStone = await components.create(const ComponentDraft(
      kind: ComponentKind.bullet,
      maker: 'Bluestem',
      name: 'Skipping Stone',
      weightGr: 150,
      bulletType: 'demo'));
  final riverRock = await components.create(const ComponentDraft(
      kind: ComponentKind.bullet,
      maker: 'Bluestem',
      name: 'River Rock',
      weightGr: 140,
      bulletType: 'demo'));
  final smallTale = await components.create(const ComponentDraft(
      kind: ComponentKind.primer, maker: 'Caprock', name: 'Small Tale'));
  final brass = await components.create(const ComponentDraft(
      kind: ComponentKind.brass, maker: 'Drybrush', name: 'Demo Brass'));

  Future<int> load(int cartridgeId, int bulletId, double charge,
          LoadStatus status, DateTime date, String? notes) =>
      loads.create(LoadDraft(
        cartridgeId: cartridgeId,
        bulletId: bulletId,
        powderId: px7,
        chargeGr: charge,
        primerId: smallTale,
        brassId: brass,
        coalIn: 2.222,
        crimp: 'light roll',
        dateDeveloped: date,
        status: status,
        notes: notes,
      ));

  await load(fable, skippingStone, 11.1, LoadStatus.working,
      DateTime(2026, 5, 2), 'Placeholder card — your notes go here.');
  final keeper = await load(fable, skippingStone, 22.2, LoadStatus.keeper,
      DateTime(2025, 9, 14), 'The one the demo rifle likes.');
  await load(fable, riverRock, 33.3, LoadStatus.retired,
      DateTime(2025, 3, 8), null);
  await load(folktale, riverRock, 11.1, LoadStatus.working,
      DateTime(2026, 2, 21), null);
  await load(folktale, riverRock, 22.2, LoadStatus.keeper,
      DateTime(2025, 11, 30), 'Demo keeper.');

  // Three trips on the keeper: groups shrinking and SD walking down so
  // both per-load trend lines draw.
  final trips = [
    (DateTime(2026, 3, 7), 2.2, 9.9, 33.0, 'Cold, still.'),
    (DateTime(2026, 4, 11), 1.6, 8.8, 22.0, 'Breezy afternoon.'),
    (DateTime(2026, 5, 16), 1.1, 7.7, 11.0, 'Calm morning at the demo bench.'),
  ];
  for (final (i, (date, group, sd, es, note)) in trips.indexed) {
    var photoDrafts = const <JournalPhotoDraft>[];
    if (photos != null) {
      final name = 'demo-target-${i + 1}.png';
      await photos.importBytes(name, await paintDemoTarget(group));
      photoDrafts = [JournalPhotoDraft(path: name)];
    }
    await sessions.create(SessionDraft(
      loadId: keeper,
      date: date,
      firearm: 'the demo rifle',
      distanceYd: 100,
      shots: 5,
      groupSizeIn: group,
      chronoAvgFps: 2222.2,
      chronoSdFps: sd,
      chronoEsFps: es,
      weather: note,
      notes: i == 2 ? 'Best demo group yet.' : null,
      photos: photoDrafts,
    ));
  }

  await inventory.set(
      componentId: px7, qtyOnHand: 1.1, unit: 'lb', costPaidCents: 1111);
  await inventory.set(componentId: smallTale, qtyOnHand: 222, unit: 'ct');
  await inventory.set(
      componentId: skippingStone,
      qtyOnHand: 111,
      unit: 'ct',
      costPaidCents: 2222);
}

/// A 600×600 PNG that reads as a photographed paper target: cream
/// ground, a one-inch-look grid, scoring rings, and a five-dot cluster
/// sized to [groupIn] — grid squares for the measure screen to
/// calibrate against. Targets are allowed art (rails §4).
Future<Uint8List> paintDemoTarget(double groupIn) async {
  const size = 600.0;
  const inch = 55.0; // grid pitch, "one inch" on the paper
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(const Rect.fromLTWH(0, 0, size, size),
      Paint()..color = const Color(0xFFF3EDDD));

  final grid = Paint()
    ..color = const Color(0xFFCBBFA3)
    ..strokeWidth = 1;
  for (var x = inch / 2; x < size; x += inch) {
    canvas.drawLine(Offset(x, 0), Offset(x, size), grid);
  }
  for (var y = inch / 2; y < size; y += inch) {
    canvas.drawLine(Offset(0, y), Offset(size, y), grid);
  }

  const center = Offset(size / 2, size / 2);
  final ring = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3
    ..color = const Color(0xFF7A6A4C);
  for (final r in [200.0, 140.0, 80.0]) {
    canvas.drawCircle(center, r, ring);
  }
  canvas.drawCircle(center, 26, Paint()..color = const Color(0xFF7A6A4C));

  // Five "holes" spread across groupIn inches of paper.
  final spread = groupIn * inch / 2;
  final hole = Paint()..color = const Color(0xFF2B2620);
  const offsets = [
    Offset(-1, -0.4), Offset(1, 0.1), Offset(-0.3, 1),
    Offset(0.4, -1), Offset(0, 0.2),
  ];
  for (final o in offsets) {
    canvas.drawCircle(center + o * spread, 9, hole);
  }

  final image =
      await recorder.endRecording().toImage(size.toInt(), size.toInt());
  try {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}
