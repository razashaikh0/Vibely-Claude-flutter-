import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../game/bingo_engine.dart';
import '../models/models.dart';

const int bingoTicketPrice = 50;
const int bingoLinePrize = 300;

/// Single source of truth for the demo. Screens listen to it and rebuild on change.
class AppState extends ChangeNotifier {
  AppState({int startingGold = 1200}) : _gold = startingGold;

  int _gold;
  int get gold => _gold;

  Room? _room;
  Room? get room => _room;

  final List<Seat?> seats = mockSeats();
  final List<ChatMessage> messages = [];

  bool _micOn = false;
  bool get micOn => _micOn;

  BingoGame? _bingo;
  BingoGame? get bingo => _bingo;
  int _claimedLines = 0;

  bool _spend(int amount) {
    if (amount > _gold) return false;
    _gold -= amount;
    return true;
  }

  void _system(String text) {
    messages.add(ChatMessage(sender: 'System', text: text, isSystem: true));
  }

  // ---- Room ----

  void enterRoom(Room room) {
    _room = room;
    _micOn = false;
    _bingo = null;
    _claimedLines = 0;
    seats.setAll(0, mockSeats());
    messages.clear();
    _system('Welcome to ${room.name}');
    notifyListeners();
  }

  void leaveRoom() {
    _room = null;
    _bingo = null;
    _claimedLines = 0;
    notifyListeners();
  }

  void sendMessage(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    messages.add(ChatMessage(sender: 'You', text: t));
    notifyListeners();
  }

  void toggleMic() {
    _micOn = !_micOn;
    final i = seats.indexWhere((s) => s?.name == 'You');
    if (i >= 0) seats[i] = seats[i]!.copyWith(isMuted: !_micOn);
    notifyListeners();
  }

  /// Demo only: lights up one random unmuted speaker.
  void rotateSpeaker(Random rng) {
    final candidates = <int>[
      for (var i = 0; i < seats.length; i++)
        if (seats[i] != null && !seats[i]!.isMuted) i,
    ];
    if (candidates.isEmpty) return;
    final pick = candidates[rng.nextInt(candidates.length)];
    for (var i = 0; i < seats.length; i++) {
      final s = seats[i];
      if (s == null) continue;
      final speaking = i == pick;
      if (s.isSpeaking != speaking) seats[i] = s.copyWith(isSpeaking: speaking);
    }
    notifyListeners();
  }

  // ---- Gifts ----

  bool sendGift(Gift gift) {
    if (!_spend(gift.price)) return false;
    _system('You sent ${gift.emoji} ${gift.name} to ${_room?.host ?? 'host'}');
    notifyListeners();
    return true;
  }

  // ---- Bingo ----

  bool buyBingoTicket() {
    if (_bingo != null) return false;
    if (!_spend(bingoTicketPrice)) return false;
    _bingo = BingoGame(ticket: BingoTicket.random());
    _claimedLines = 0;
    _system('Bingo ticket bought for $bingoTicketPrice gold');
    notifyListeners();
    return true;
  }

  int? drawBingoNumber() {
    final n = _bingo?.drawNext();
    if (n != null) notifyListeners();
    return n;
  }

  /// Returns false if the number is not drawn yet or not on the ticket.
  bool markBingoNumber(int n) {
    final game = _bingo;
    if (game == null || !game.mark(n)) return false;

    final lines = game.completedLines;
    if (lines > _claimedLines) {
      final newLines = lines - _claimedLines;
      _claimedLines = lines;
      final prize = newLines * bingoLinePrize;
      _gold += prize;
      _system('BINGO! $newLines new line(s), +$prize gold');
    }
    notifyListeners();
    return true;
  }
}
