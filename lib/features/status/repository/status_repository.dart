import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corncall/features/auth/apis/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:corncall/common/repositories/common_firebase_storage_repository.dart';
import 'package:corncall/common/utils/utils.dart';
import 'package:corncall/models/status_model.dart';
import 'package:corncall/models/user_model.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required String statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageurl = statusImage;//'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      //await AuthApi.uploadFile(statusImage,'status');
     print(imageurl);
     print("ddddddddddddddddddddddddddd");
      // await ref
      //     .read(commonFirebaseStorageRepositoryProvider)
      //     .storeFileToFirebase(
      //       '/status/$statusId$uid',
      //       statusImage,
      //     );
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        String selectedPhoneNum1 = contacts[i].phones[0].number.replaceAll(
          ' ',
          '',
        );
        String selectedPhoneNum2 =selectedPhoneNum1.replaceAll(
          '(',
          '',
        );
        String selectedPhoneNum3 =selectedPhoneNum2.replaceAll(
          ')',
          '',
        );
        String selectedPhoneNum4 =selectedPhoneNum3.replaceAll(
          '-',
          '',
        );
        String selectedPhoneNum = '+91'+selectedPhoneNum4;
        var userDataFirebase = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedPhoneNum,
            )
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageurl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageurl];
      }

      Status status = Status(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        String selectedPhoneNum1 = contacts[i].phones[0].number.replaceAll(
          ' ',
          '',
        );
        String selectedPhoneNum2 =selectedPhoneNum1.replaceAll(
          '(',
          '',
        );
        String selectedPhoneNum3 =selectedPhoneNum2.replaceAll(
          ')',
          '',
        );
        String selectedPhoneNum4 =selectedPhoneNum3.replaceAll(
          '-',
          '',
        );
        String selectedPhoneNum = '+91'+selectedPhoneNum4;
        var statusesSnapshot = await firestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: selectedPhoneNum,
            )
            .where(
              'createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch,
            )
            .get();
        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          //if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
         // }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }
}
