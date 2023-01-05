class CallHistory {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String callStatus;
  final bool isAudio;
  CallHistory({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.callStatus,
    required this.isAudio,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'callStatus': callStatus,
      'isAudio': isAudio,
    };
  }

  factory CallHistory.fromMap(Map<String, dynamic> map) {
    return CallHistory(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      contactId: map['contactId'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      callStatus: map['callStatus'] ?? '',
      isAudio: map['isAudio'] ?? false,
    );
  }
}
