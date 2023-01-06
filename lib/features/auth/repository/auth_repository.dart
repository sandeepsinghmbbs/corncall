import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:corncall/common/repositories/common_firebase_storage_repository.dart';
import 'package:corncall/common/utils/utils.dart';
import 'package:corncall/features/auth/screens/otp_screen.dart';
import 'package:corncall/features/auth/screens/user_information_screen.dart';
import 'package:corncall/models/user_model.dart';
import 'package:corncall/mobile_layout_screen.dart';

import '../apis/api.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {

    // try {
    //  await auth.createUserWithEmailAndPassword(
    //       email: phoneNumber + "@gmail.com",
    //       password: "123456"
    //   );
    // } on FirebaseAuthException catch(signUpError) {
    //   print('-------------------');
    //   print(signUpError.code);
    //   print('-------------------');
    //     if(signUpError.code == 'email-already-in-use') {
    //       var e = phoneNumber + "@gmail.com";
    //       /// `foo@bar.com` has alread been registered
    //
    //       Navigator.pushNamed(
    //         context,
    //         OTPScreen.routeName,
    //         arguments: e,
    //       );
    //     }
    //
    // }


    try {
      print('2222222222222222222');
      await auth.signInWithEmailAndPassword(
        email: phoneNumber + "@gmail.com",
        password: "123456",
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if(e.code.toString() == 'user-not-found')
        {
          try {
        var id =     await AuthApi.otpSend( 'sendOTPNew',phoneNumber, );
              // verificationCompleted: (PhoneAuthCredential credential) async {
              //   await AuthApi.signInWithCredential(credential);
              // },
              // verificationFailed: (e) {
              //   throw Exception(e.message);
              // },
              // codeSent: ((String verificationId, int? resendToken) async {
              //   Navigator.pushNamed(
              //     context,
              //     OTPScreen.routeName,
              //     arguments: verificationId,
              //   );
              // }),
              // codeAutoRetrievalTimeout: (String verificationId) {},

        Navigator.pushNamed(
          context,
          OTPScreen.routeName,
          arguments: {'verificationId': id.toString(),'phoneNumber':phoneNumber},

        );
          } on FirebaseAuthException catch (e) {
            showSnackBar(context: context, content: e.message!);
          }
          //send otp here

        }
      //showSnackBar(context: context, content: e.message!);

    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
    var d =  await AuthApi.signInWithCredential(credential);
      var mobNo = d['responseValue'][0]['phoneNumber'];
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email:  mobNo + "@gmail.com",
          password: "123456",
        );
        await auth.signInWithEmailAndPassword(
          email:  mobNo + "@gmail.com",
          password: "123456",
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          UserInformationScreen.routeName,
              (route) => false,
        );

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          await auth.signInWithEmailAndPassword(
            email: verificationId,
            password: "123456",
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            UserInformationScreen.routeName,
                (route) => false,
          );
        }
      } catch (e) {
        print(e);
      }


      // PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //   verificationId: verificationId,
      //   smsCode: userOTP,
      // );
      // await auth.signInWithCredential(credential);
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   UserInformationScreen.routeName,
      //   (route) => false,
      // );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required String profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = profilePic;
          //'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      // if (profilePic != null) {
      //   photoUrl = await ref
      //       .read(commonFirebaseStorageRepositoryProvider)
      //       .storeFileToFirebase(
      //         'profilePic/$uid',
      //         profilePic,
      //       );
      // }
      final splitted = auth.currentUser!.email!.toString().split('@');
      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: splitted[0],
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
