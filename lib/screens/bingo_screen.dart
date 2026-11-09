import 'package:flutter/material.dart';

import '../game/bingo_engine.dart';
import '../state/app_state.dart';

class BingoScreen extends StatelessWidget {
  const BingoScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final game = appState.bingo;
        return Scaffold(
          appBar: AppBar(title: const Text('Bingo')),
          body: game == null
              ? _Lobby(appState: appState)
              : _Board(appState: appState, game: game),
        );
      },
    );
  }
}

class _Lobby extends StatelessWidget {
  const _Lobby({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎟️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text(
              'Bingo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Ticket: 🪙 $bingoTicketPrice · Each line wins 🪙 $bingoLinePrize',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: appState.gold >= bingoTicketPrice
                  ? () => appState.buyBingoTicket()
                  : null,
              child: const Text('Buy ticket'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({required this.appState, required this.game});

  final AppState appState;
  final BingoGame game;

  static const _letters = ['B', 'I', 'N', 'G', 'O'];

  void _onTap(BuildContext context, int n) {
    if (appState.markBingoNumber(n)) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text('$n is not drawn yet'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Drawn ${game.drawn.length}/75 · Last: ${game.lastDrawn ?? '-'}',
                ),
              ),
              Text('Lines: ${game.completedLines}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final l in _letters)
                Expanded(
                  child: Center(
                    child: Text(
                      l,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var r = 0; r < 5; r++)
                for (var c = 0; c < 5; c++)
                  _Cell(
                    game: game,
                    row: r,
                    col: c,
                    onTap: () => _onTap(context, game.ticket.grid[r][c]),
                  ),
            ],
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed:
                game.isExhausted ? null : () => appState.drawBingoNumber(),
            icon: const Icon(Icons.casino),
            label: Text(game.isExhausted ? 'All numbers drawn' : 'Draw number'),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.game,
    required this.row,
    required this.col,
    required this.onTap,
  });

  final BingoGame game;
  final int row;
  final int col;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final n = game.ticket.grid[row][col];
    final free = n == bingoFreeCell;
    final marked = game.isMarked(row, col);
    final drawn = !free && game.drawn.contains(n);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: free ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: marked ? scheme.primary : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: drawn && !marked
              ? Border.all(color: scheme.primary, width: 2)
              : null,
        ),
        child: Text(
          free ? 'FREE' : '$n',
          style: TextStyle(
            color: marked ? scheme.onPrimary : scheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: free ? 11 : 18,
          ),
        ),
      ),
    );
  }
}
