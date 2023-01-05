class Call {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callId;
  final bool hasDialled;
   final bool callPickupStatus;
  final String callStatus;
  final String initCallDateTime;
  final String endCallDateTime;
  final bool isAudio;
  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.callId,
    required this.hasDialled,
    required this.callPickupStatus,
    required this.callStatus,
    required this.initCallDateTime,
    required this.endCallDateTime,
    required this.isAudio,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'callId': callId,
      'hasDialled': hasDialled,
      'callPickupStatus': callPickupStatus,
      'callStatus': callStatus,
      'initCallDateTime': initCallDateTime,
      'endCallDateTime': endCallDateTime,
      'isAudio': isAudio,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callerPic: map['callerPic'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverPic: map['receiverPic'] ?? '',
      callId: map['callId'] ?? '',
      hasDialled: map['hasDialled'] ?? false,
      callPickupStatus: map['callPickupStatus'] ?? false,
      callStatus: map['callStatus'] ?? 'active',
      initCallDateTime: map['initCallDateTime'] ?? DateTime.now().toString(),
      endCallDateTime: map['endCallDateTime'] ?? '',
      isAudio: map['isAudio'] ?? false
      ,
    );
  }
}
