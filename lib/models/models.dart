/// A person sitting on a seat in the voice room.
class Seat {
  const Seat({
    required this.name,
    required this.emoji,
    this.isHost = false,
    this.isMuted = false,
    this.isSpeaking = false,
  });

  final String name;
  final String emoji;
  final bool isHost;
  final bool isMuted;
  final bool isSpeaking;

  Seat copyWith({bool? isMuted, bool? isSpeaking}) => Seat(
        name: name,
        emoji: emoji,
        isHost: isHost,
        isMuted: isMuted ?? this.isMuted,
        isSpeaking: isSpeaking ?? this.isSpeaking,
      );
}

/// A voice room shown in the room list.
class Room {
  const Room({
    required this.id,
    required this.name,
    required this.host,
    required this.emoji,
    required this.members,
    required this.category,
  });

  final String id;
  final String name;
  final String host;
  final String emoji;
  final int members;
  final String category;
}

enum GiftTab { package, gift, lucky, member, vip }

extension GiftTabLabel on GiftTab {
  String get label => switch (this) {
        GiftTab.package => 'Package',
        GiftTab.gift => 'Gift',
        GiftTab.lucky => 'Lucky',
        GiftTab.member => 'Member',
        GiftTab.vip => 'VIP',
      };
}

class Gift {
  const Gift({
    required this.emoji,
    required this.name,
    required this.price,
    required this.tab,
  });

  final String emoji;
  final String name;
  final int price;
  final GiftTab tab;
}

class ChatMessage {
  const ChatMessage({
    required this.sender,
    required this.text,
    this.isSystem = false,
  });

  final String sender;
  final String text;
  final bool isSystem;
}
