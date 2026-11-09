import '../models/models.dart';

/// Mock data only. Replace with a real backend later.
const rooms = <Room>[
  Room(id: '1356535', name: 'Late Night Chai ☕', host: 'Sana', emoji: '☕', members: 24, category: 'Chat'),
  Room(id: '2208114', name: 'Dil Se Dil Tak', host: 'Kiran', emoji: '💞', members: 41, category: 'Music'),
  Room(id: '3390021', name: 'PK Arena', host: 'Omar', emoji: '🧧', members: 67, category: 'PK'),
];

/// 8 seats (2 x 4 grid). The last one is empty, so the user can see the empty state.
/// Returns a fresh, growable list each time, because AppState mutates it.
List<Seat?> mockSeats() => [
      Seat(name: 'Sana', emoji: '👑', isHost: true),
      Seat(name: 'Zara', emoji: '🦊'),
      Seat(name: 'Ayaan', emoji: '🐯'),
      Seat(name: 'Riya', emoji: '🌸'),
      Seat(name: 'Omar', emoji: '🦁'),
      Seat(name: 'Kiran', emoji: '🐼'),
      Seat(name: 'You', emoji: '🙂', isMuted: true),
      null,
    ];

const gifts = <Gift>[
  Gift(emoji: '🌹', name: 'Rose', price: 20, tab: GiftTab.gift),
  Gift(emoji: '🎂', name: 'Cake', price: 66, tab: GiftTab.gift),
  Gift(emoji: '🎁', name: 'Lucky Box', price: 88, tab: GiftTab.lucky),
  Gift(emoji: '⭐', name: 'Star Box', price: 220, tab: GiftTab.lucky),
  Gift(emoji: '👍', name: 'Thumbs Up', price: 120, tab: GiftTab.member),
  Gift(emoji: '🪧', name: 'Light Board', price: 200, tab: GiftTab.member),
  Gift(emoji: '🎉', name: 'Celebration', price: 2500, tab: GiftTab.package),
  Gift(emoji: '🚀', name: 'Rocket', price: 9999, tab: GiftTab.package),
  Gift(emoji: '🦄', name: 'Unicorn', price: 500, tab: GiftTab.vip),
  Gift(emoji: '🚗', name: 'Sports Car', price: 2000, tab: GiftTab.vip),
];
