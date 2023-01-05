import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:corncall/common/utils/utils.dart';
import 'package:corncall/features/call/screens/call_screen.dart';
import 'package:corncall/models/call.dart';
import 'package:corncall/models/group.dart' as model;

import '../../../models/call_history.dart';
import '../../../models/user_model.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toMap());

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => CallScreen(
      //       channelId: senderCallData.callId,
      //       call: senderCallData,
      //       isGroupChat: false,
      //     ),
      //   ),
      // );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void makeGroupCall(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupSnapshot = await firestore
          .collection('groups')
          .doc(senderCallData.receiverId)
          .get();
      model.Group group = model.Group.fromMap(groupSnapshot.data()!);

      for (var id in group.membersUid) {
        await firestore
            .collection('call')
            .doc(id)
            .set(receiverCallData.toMap());
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: true,
          ),
        ),
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
  Stream<List<CallHistory>> getCallHistory() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('callHistory')
        .snapshots()
        .asyncMap((event) async {
      List<CallHistory> history = [];
      for (var document in event.docs) {
        var call = Call.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(call.callerId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        history.add(
          CallHistory(
              name: user.name,
              profilePic: user.profilePic,
              contactId: call.receiverId,
              timeSent: DateTime.parse(call.initCallDateTime),
              callStatus: call.receiverName,
              isAudio : call.isAudio
            // name: user.name,
            // profilePic: user.profilePic,
            // contactId: chatContact.contactId,
            // timeSent: chatContact.timeSent,
            // lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return history;
    });
  }
  void endCall(
    String callerId,
    String receiverId,
    Call call,
    BuildContext context,
  ) async {
    try {
    //  Call callnew = call;
    //   call.callPickupStatus = '';
      await firestore
          .collection('users')
          .doc(call.callerId)
          .collection('callHistory')
          .doc(call.callId)
          .set(call.toMap());

      await firestore
          .collection('users')
          .doc(call.receiverId)
          .collection('callHistory')
          .doc(call.callId)
          .set(call.toMap());


      // await firestore
      //     .collection('callHistory')
      //     .doc(auth.currentUser!.uid)
      //     .collection('historyDetails')
      //     .doc(call.callerId)
      //     .set(call.toMap());
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      var groupSnapshot =
          await firestore.collection('groups').doc(receiverId).get();
      model.Group group = model.Group.fromMap(groupSnapshot.data()!);
      for (var id in group.membersUid) {
        await firestore.collection('call').doc(id).delete();
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
