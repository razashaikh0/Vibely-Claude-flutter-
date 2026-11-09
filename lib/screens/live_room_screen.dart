import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import 'bingo_screen.dart';
import 'gift_sheet.dart';

class LiveRoomScreen extends StatefulWidget {
  const LiveRoomScreen({super.key, required this.appState});

  final AppState appState;

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  final _input = TextEditingController();
  final _rng = Random();
  Timer? _speakTimer;

  @override
  void initState() {
    super.initState();
    _speakTimer = Timer.periodic(
      const Duration(milliseconds: 1800),
      (_) => widget.appState.rotateSpeaker(_rng),
    );
  }

  @override
  void dispose() {
    _speakTimer?.cancel();
    _input.dispose();
    super.dispose();
  }

  void _send() {
    widget.appState.sendMessage(_input.text);
    _input.clear();
  }

  void _openGifts() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => GiftSheet(appState: widget.appState),
    );
  }

  void _openBingo() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BingoScreen(appState: widget.appState)),
    );
  }

  void _leave() {
    widget.appState.leaveRoom();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final room = state.room;
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room?.name ?? '',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                Text(
                  'ID ${room?.id ?? ''} · ${room?.members ?? 0} members',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: _leave, child: const Text('Leave')),
            ],
          ),
          body: Column(
            children: [
              _SeatGrid(seats: state.seats),
              const Divider(height: 1),
              Expanded(child: _MessageFeed(messages: state.messages)),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Mic',
                    onPressed: state.toggleMic,
                    icon: Icon(state.micOn ? Icons.mic : Icons.mic_off),
                    color: state.micOn ? Colors.greenAccent : null,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _input,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Say something…',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Gifts',
                    onPressed: _openGifts,
                    icon: const Icon(Icons.card_giftcard),
                  ),
                  IconButton(
                    tooltip: 'Game room',
                    onPressed: _openBingo,
                    icon: const Icon(Icons.casino),
                  ),
                  IconButton(
                    tooltip: 'Send',
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SeatGrid extends StatelessWidget {
  const _SeatGrid({required this.seats});

  final List<Seat?> seats;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 4,
        childAspectRatio: 0.8,
        children: [for (final seat in seats) _SeatTile(seat: seat)],
      ),
    );
  }
}

class _SeatTile extends StatelessWidget {
  const _SeatTile({required this.seat});

  final Seat? seat;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = seat;

    if (s == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: scheme.outline),
            ),
            child: Icon(Icons.add, color: scheme.outline),
          ),
          const SizedBox(height: 4),
          Text('Empty', style: TextStyle(fontSize: 11, color: scheme.outline)),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.surfaceContainerHighest,
                border: Border.all(
                  color: s.isSpeaking ? Colors.greenAccent : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Text(s.emoji, style: const TextStyle(fontSize: 28)),
            ),
            if (s.isMuted)
              const Positioned(
                right: -2,
                bottom: -2,
                child: Icon(Icons.mic_off, size: 16),
              ),
            if (s.isHost)
              const Positioned(top: -6, right: -6, child: Text('👑')),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          s.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _MessageFeed extends StatelessWidget {
  const _MessageFeed({required this.messages});

  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, i) {
        final m = messages[messages.length - 1 - i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(
            m.isSystem ? m.text : '${m.sender}: ${m.text}',
            style: TextStyle(
              color: m.isSystem ? Colors.amber : null,
              fontStyle: m.isSystem ? FontStyle.italic : null,
            ),
          ),
        );
      },
    );
  }
}
