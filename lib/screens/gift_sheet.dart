import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';

class GiftSheet extends StatefulWidget {
  const GiftSheet({super.key, required this.appState});

  final AppState appState;

  @override
  State<GiftSheet> createState() => _GiftSheetState();
}

class _GiftSheetState extends State<GiftSheet> {
  GiftTab _tab = GiftTab.gift;

  void _send(Gift gift) {
    final ok = widget.appState.sendGift(gift);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(ok ? 'Sent ${gift.name}' : 'Not enough gold'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = gifts.where((g) => g.tab == _tab).toList();

    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Send gift',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  Text('🪙 ${widget.appState.gold}'),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<GiftTab>(
                  segments: [
                    for (final t in GiftTab.values)
                      ButtonSegment<GiftTab>(value: t, label: Text(t.label)),
                  ],
                  selected: {_tab},
                  onSelectionChanged: (s) => setState(() => _tab = s.first),
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  for (final g in items)
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _send(g),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(g.emoji, style: const TextStyle(fontSize: 26)),
                            Text(
                              g.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11),
                            ),
                            Text(
                              '🪙 ${g.price}',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
