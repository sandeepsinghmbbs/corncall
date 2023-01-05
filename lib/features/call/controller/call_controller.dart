import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corncall/models/call_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:corncall/features/auth/controller/auth_controller.dart';
import 'package:corncall/features/call/repository/call_repository.dart';
import 'package:corncall/models/call.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;
  Stream<List<CallHistory>> getCallHistory() {
    return callRepository.getCallHistory();
  }
  void makeCall(BuildContext context, String receiverName, String receiverUid,
      String receiverProfilePic, bool isGroupChat) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: true,
          callPickupStatus: false,
        callStatus: 'active',
          initCallDateTime:DateTime.now().toString(),
          endCallDateTime:'',
          isAudio:false
      );

      Call recieverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: false,
          callPickupStatus: false,
          callStatus: 'active',
          initCallDateTime:DateTime.now().toString(),
          endCallDateTime:'',
          isAudio:false
      );
      if (isGroupChat) {
        callRepository.makeGroupCall(senderCallData, context, recieverCallData);
      } else {
        callRepository.makeCall(senderCallData, context, recieverCallData);
      }
    });
  }

  void endCall(
    String callerId,
    String receiverId,
    Call call,
    BuildContext context,
  ) {
    callRepository.endCall(callerId, receiverId,call, context);
  }
}
//