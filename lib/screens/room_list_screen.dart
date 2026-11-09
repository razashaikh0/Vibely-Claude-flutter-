import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../state/app_state.dart';
import 'live_room_screen.dart';

class RoomListScreen extends StatelessWidget {
  const RoomListScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Voice Rooms'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(child: Text('🪙 ${appState.gold}')),
            ),
          ],
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: rooms.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final room = rooms[i];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(room.emoji, style: const TextStyle(fontSize: 20)),
                ),
                title: Text(
                  room.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  'Host: ${room.host} · ${room.members} members · ${room.category}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  appState.enterRoom(room);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LiveRoomScreen(appState: appState),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
