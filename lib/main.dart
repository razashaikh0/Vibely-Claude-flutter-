import 'package:flutter/material.dart';

import 'screens/room_list_screen.dart';
import 'state/app_state.dart';

void main() {
  runApp(VoiceGamesApp(appState: AppState()));
}

class VoiceGamesApp extends StatelessWidget {
  const VoiceGamesApp({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Games',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFFFF5D86),
      ),
      home: RoomListScreen(appState: appState),
    );
  }
}
