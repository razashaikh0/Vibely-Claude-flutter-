# Voice Games (Flutter)

Voice room app with a seat grid, chat, gift sheet and a Bingo game room.
Backend is mocked (see `lib/data/mock_data.dart`) so the app runs with no server.

## Run

```bash
flutter pub get
flutter run
flutter test
```

## Structure

- `lib/main.dart` – app entry, theme
- `lib/models/models.dart` – Seat, Room, Gift, ChatMessage
- `lib/data/mock_data.dart` – demo rooms, seats, gifts
- `lib/state/app_state.dart` – gold, room, chat, mic, gifts, bingo session (ChangeNotifier)
- `lib/game/bingo_engine.dart` – pure Dart bingo logic (ticket, draw, mark, line count)
- `lib/screens/` – room list, live room (seat grid + chat), gift sheet, bingo
- `test/bingo_engine_test.dart` – unit tests for the bingo engine

## Rules implemented

- Ticket: 5×5, B/I/N/G/O columns, free centre cell.
- Draw one number at a time; only drawn numbers can be marked (tap the cell).
- Ticket costs 50 gold. Each new completed line (row, column or diagonal) pays 300 gold.
- Gifts are deducted from gold balance; insufficient gold is blocked.

## Not yet built

- Create-room form, room preview, follow/join
- Real voice (Agora / LiveKit / similar), real mic permissions
- Backend, auth, real-time sync, persistence
- Other games beyond Bingo

No dependencies beyond the Flutter SDK are used.

## Open in Firebase Studio

1. Go to https://studio.firebase.google.com and sign in with your Google account.
2. Choose **Import a repo** and paste `https://github.com/razashaikh0/Vibely-Claude-flutter-`.
3. Once the workspace opens, run `flutter pub get` in the terminal, then `flutter run` or `flutter test`.

Backend (Firebase Auth / Firestore) is not connected yet. The app uses mock data from `lib/data/mock_data.dart`.
