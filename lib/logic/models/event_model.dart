
class EventModel {
  final String eventId;
  final String? creatorId;
  final List<String>? joinedUserIds;
  final String? title, description, location, image;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isUpcomingForDemo;
  final int remindMeBefore;
  final bool enablePush;
  final bool enableEmail;

  EventModel({
    this.remindMeBefore = 15,
    this.enablePush = true,
    this.enableEmail = false,
    this.isUpcomingForDemo = false,
    required this.eventId,
    this.creatorId,
    this.joinedUserIds,
    required this.title,
    required this.location,
    required this.image,
    required this.description, required this.startDate, required this.endDate,
  });

  EventModel copyWith({
    int? remindMeBefore,
    bool? enablePush,
    bool? enableEmail,
    String? eventId,
    String? creatorId,
    List<String>? joinedUserIds,
    String? title,
    String? description,
    String? location,
    String? image,
    DateTime? startDate,
    DateTime? endDate,
    bool? isUpcomingForDemo,
  }) {
    return EventModel(
      remindMeBefore: remindMeBefore ?? this.remindMeBefore,
      enablePush: enablePush ?? this.enablePush,
      enableEmail: enableEmail ?? this.enableEmail,
      eventId: eventId ?? this.eventId,
      creatorId: creatorId ?? this.creatorId,
      joinedUserIds: joinedUserIds ?? this.joinedUserIds,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      image: image ?? this.image,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,

      isUpcomingForDemo: isUpcomingForDemo ?? this.isUpcomingForDemo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remindMeBefore': remindMeBefore,
      'enablePush': enablePush,
      'enableEmail': enableEmail,
      'eventId': eventId,
      'creatorId': creatorId,
      'joinedUserIds': joinedUserIds ?? [],
      'title': title,
      'description': description,
      'location': location,
      'image': image,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isUpcomingForDemo': isUpcomingForDemo,
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      remindMeBefore: json['remindMeBefore'] ?? 15,
      enablePush: json['enablePush'] ?? true,
      enableEmail: json['enableEmail'] ?? false,
      eventId: json['eventId'],
      creatorId: json['creatorId'],
      joinedUserIds: List<String>.from(json['joinedUserIds'] ?? []),
      title: json['title'],
      description: json['description'],
      location: json['location'],
      image: json['image'],
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      isUpcomingForDemo: json['isUpcomingForDemo'] ?? false,
    );
  }
}


