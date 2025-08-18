class Character {
  final String id;
  final String name;
  final String description;
  final List<String> tags;
  final String imageAsset;
  final int likes;
  final String author;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.tags,
    required this.imageAsset,
    required this.likes,
    required this.author,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] as List<dynamic>),
      imageAsset: json['imageAsset'] as String,
      likes: json['likes'] as int,
      author: json['author'] as String,
    );
  }
}

class ChatSummary {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String avatarAsset;

  ChatSummary({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.avatarAsset,
  });

  factory ChatSummary.fromJson(Map<String, dynamic> json) {
    return ChatSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      lastMessage: json['lastMessage'] as String,
      time: json['time'] as String,
      unreadCount: json['unreadCount'] as int,
      avatarAsset: json['avatarAsset'] as String,
    );
  }
}

class Profile {
  final String name;
  final String avatarAsset;
  final int credits;
  final int coins;

  Profile({
    required this.name,
    required this.avatarAsset,
    required this.credits,
    required this.coins,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] as String,
      avatarAsset: json['avatarAsset'] as String,
      credits: json['credits'] as int,
      coins: json['coins'] as int,
    );
  }
}


