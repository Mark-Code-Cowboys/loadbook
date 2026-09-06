import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../scan_import/notebook_flow.dart';

/// First run seen? Refreshed after onboarding completes.
final firstRunSeenProvider = FutureProvider<bool>(
  (ref) => FirstRunFlag(ref.watch(kvStoreProvider)).seen(),
);

/// The first thing a new user reads is the framing — this is their
/// reloading notebook, nothing more — then the privacy promise, then
/// the fork: index-card keepers start with the converter, everyone
/// else with a look around.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(WidgetRef ref) async {
    await FirstRunFlag(ref.read(kvStoreProvider)).markSeen();
    ref.invalidate(firstRunSeenProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScaffold(
      icon: Icons.menu_book_outlined,
      positioning: 'Your reloading notebook, off the index cards.',
      subtitle: 'A journal of what you did at your bench — recipes, '
          'range sessions, and what\'s on the shelf, written in your '
          'own words. Loadbook ships empty and never suggests a thing.',
      actions: [
        FilledButton.icon(
          icon: const Icon(Icons.document_scanner_outlined),
          label: const Text('Import my index cards'),
          onPressed: () async {
            // Run the flow first so this screen stays alive under it,
            // then swap to the shell.
            await runNotebookImport(context, ref);
            await _finish(ref);
          },
        ),
        TextButton(
          onPressed: () => _finish(ref),
          child: const Text('Just look around'),
        ),
      ],
    );
  }
}
