import 'dart:math';

/// Centre cell of every ticket. It always counts as marked.
const int bingoFreeCell = 0;

/// A 5 x 5 ticket. Column 0 holds B (1-15), column 1 I (16-30), and so on.
class BingoTicket {
  BingoTicket(this.grid);

  /// grid[row][col]
  final List<List<int>> grid;

  factory BingoTicket.random([Random? rng]) {
    final r = rng ?? Random();
    final columns = <List<int>>[];
    for (var c = 0; c < 5; c++) {
      final numbers = List<int>.generate(15, (i) => c * 15 + i + 1)..shuffle(r);
      columns.add(numbers.take(5).toList());
    }
    final grid = List.generate(
      5,
      (row) => List.generate(5, (col) => columns[col][row]),
    );
    grid[2][2] = bingoFreeCell;
    return BingoTicket(grid);
  }

  bool contains(int n) =>
      n != bingoFreeCell && grid.any((row) => row.contains(n));
}

/// One game session on one ticket.
class BingoGame {
  /// [drawOrder] makes the draw sequence deterministic (used in tests).
  BingoGame({required this.ticket, List<int>? drawOrder, Random? rng})
      : _pool = drawOrder?.toList() ??
            (List<int>.generate(75, (i) => i + 1)..shuffle(rng ?? Random()));

  final BingoTicket ticket;
  final List<int> _pool;
  final List<int> drawn = [];
  final Set<int> _marked = {};

  int? get lastDrawn => drawn.isEmpty ? null : drawn.last;
  bool get isExhausted => _pool.isEmpty;

  /// Draws the next number from the pool, or returns null when none are left.
  int? drawNext() {
    if (_pool.isEmpty) return null;
    final n = _pool.removeAt(0);
    drawn.add(n);
    return n;
  }

  /// Marks a number on the ticket. Only numbers that were already drawn can be marked.
  bool mark(int n) {
    if (!ticket.contains(n) || !drawn.contains(n)) return false;
    _marked.add(n);
    return true;
  }

  bool isMarked(int row, int col) {
    final v = ticket.grid[row][col];
    return v == bingoFreeCell || _marked.contains(v);
  }

  /// Number of fully marked rows, columns and diagonals.
  int get completedLines {
    var count = 0;
    bool full(List<(int, int)> cells) =>
        cells.every((p) => isMarked(p.$1, p.$2));

    for (var i = 0; i < 5; i++) {
      if (full([for (var j = 0; j < 5; j++) (i, j)])) count++; // row
      if (full([for (var j = 0; j < 5; j++) (j, i)])) count++; // column
    }
    if (full([for (var i = 0; i < 5; i++) (i, i)])) count++; // diagonal
    if (full([for (var i = 0; i < 5; i++) (i, 4 - i)])) count++; // anti-diagonal
    return count;
  }
}
