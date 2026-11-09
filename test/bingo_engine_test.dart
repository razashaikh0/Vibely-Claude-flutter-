import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:voice_games/game/bingo_engine.dart';

void main() {
  test('random ticket respects B-I-N-G-O ranges and has a free centre', () {
    final t = BingoTicket.random(Random(1));
    for (var r = 0; r < 5; r++) {
      for (var c = 0; c < 5; c++) {
        final v = t.grid[r][c];
        if (r == 2 && c == 2) {
          expect(v, bingoFreeCell);
        } else {
          expect(v, inInclusiveRange(c * 15 + 1, c * 15 + 15));
        }
      }
    }
  });

  test('random ticket has no duplicate numbers', () {
    final t = BingoTicket.random(Random(7));
    final nums = t.grid.expand((row) => row).where((n) => n != bingoFreeCell);
    expect(nums.toSet().length, nums.length);
  });

  test('cannot mark a number that has not been drawn', () {
    final ticket = BingoTicket([
      [1, 16, 31, 46, 61],
      [2, 17, 32, 47, 62],
      [3, 18, 0, 48, 63],
      [4, 19, 33, 49, 64],
      [5, 20, 34, 50, 65],
    ]);
    final game = BingoGame(ticket: ticket, drawOrder: [40, 41]);
    expect(game.mark(1), isFalse);
    game.drawNext();
    expect(game.mark(1), isFalse);
  });

  test('a full row counts as one completed line', () {
    final ticket = BingoTicket([
      [1, 16, 31, 46, 61],
      [2, 17, 32, 47, 62],
      [3, 18, 0, 48, 63],
      [4, 19, 33, 49, 64],
      [5, 20, 34, 50, 65],
    ]);
    final game = BingoGame(ticket: ticket, drawOrder: [1, 16, 31, 46, 61]);
    for (var i = 0; i < 5; i++) {
      game.drawNext();
    }
    expect(game.completedLines, 0);
    for (final n in [1, 16, 31, 46, 61]) {
      expect(game.mark(n), isTrue);
    }
    expect(game.completedLines, 1);
  });

  test('centre free cell completes a diagonal with four marks', () {
    final ticket = BingoTicket([
      [1, 16, 31, 46, 61],
      [2, 17, 32, 47, 62],
      [3, 18, 0, 48, 63],
      [4, 19, 33, 49, 64],
      [5, 20, 34, 50, 65],
    ]);
    // Main diagonal: (0,0)=1, (1,1)=17, (2,2)=free, (3,3)=49, (4,4)=65
    final game = BingoGame(ticket: ticket, drawOrder: [1, 17, 49, 65]);
    for (var i = 0; i < 4; i++) {
      game.drawNext();
    }
    for (final n in [1, 17, 49, 65]) {
      game.mark(n);
    }
    expect(game.completedLines, 1);
  });
}
