import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:corncall/common/utils/utils.dart';
import 'package:corncall/models/user_model.dart';
import 'package:corncall/features/chat/screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    // Conatct c = Contact(id: )
    try {
      if (await FlutterContacts.requestPermission()) {
        print("bbbbbbbbbbbbbbbbbbb");
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeee");
      print(e);
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      print("------------------");
      print(selectedContact);
      print("------------------");
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum1 = selectedContact.phones[0].number.replaceAll(
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
        print(selectedPhoneNum);
        print(userData.phoneNumber);
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
              'isGroupChat':false,
              'profilePic':''
            },
          );
        }
      }

      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'This number does not exist on this app.',
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
