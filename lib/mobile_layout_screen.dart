import 'dart:convert';
import 'dart:io';
import 'package:corncall/models/chat_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:corncall/common/utils/colors.dart';
import 'package:corncall/common/utils/utils.dart';
import 'package:corncall/features/auth/controller/auth_controller.dart';
import 'package:corncall/features/group/screens/create_group_screen.dart';
import 'package:corncall/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:corncall/features/chat/widgets/contacts_list.dart';
import 'package:corncall/features/status/screens/confirm_status_screen.dart';
import 'package:corncall/features/status/screens/status_contacts_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'features/chat/api/apis/socketHelper.dart';
// import 'features/chat/api/apis/websocketHelper.dart';
import 'features/call/screens/call_pickup_screen.dart';
import 'features/chat/repositories/chat_repository.dart';
import 'features/chat/widgets/call_history.dart';
import 'global_view_modal.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    // wshelper.addListener(_onGameDataReceived);
    print("111111111111111111111111111111111111111111111");
    // _listenSocket();
  }

//   _listenSocket() async {
//
//     final contactsProvider = Provider((ref) => ref.watch(chatRepositoryProvider));
//     final counterRef = ref.read(contactsProvider);
//     final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//     final SharedPreferences prefs = await _prefs;
//     var phoneNumber = await prefs.getString('phoneNumber');
//     SocketService().channel.stream.listen(
//           (data) async {
//         print("datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata");
//         var dData = jsonDecode(data);
//         if(dData['cmd'] == 'connectSucess')
//         {
//           var suserIDs = await prefs.setString('socketUserID',dData['userID']);
//           var userIDs = await prefs.getString('socketUserID');
// //           var d =  ChatContact(
// //             name: userIDs.toString(),
// //             profilePic: dData['profilePic'],
// //             contactId: dData['contactId'],
// //             timeSent: DateTime.now(),
// //             lastMessage: dData['lastMessage'],
// //           );
// // // print(dData.toString());
// //
// //           counterRef.stream.add(d);
//         }
//         if(dData['cmd'] == 'chatContactsList')
//         {
//          var d =  ChatContact(
//             name: dData['name'],
//             profilePic: dData['profilePic'],
//             contactId: dData['contactId'],
//             timeSent: DateTime.now(),
//             lastMessage: dData['lastMessage'],
//           );
// // print(dData.toString());
//
//          counterRef.stream.add(d);
//         }
//         if(dData['cmd'] == 'ChatGroupsList')
//         {
//           var d =  ChatContact(
//             name: dData['name'],
//             profilePic: dData['profilePic'],
//             contactId: dData['contactId'],
//             timeSent: DateTime.now(),
//             lastMessage: dData['lastMessage'],
//           );
// // print(dData.toString());
//
//           counterRef.stream.add(d);
//         }
//
//       },
//       onError: (error) => print(error),
//     );
//
//    //  final contactsProvider = Provider((ref) => ref.watch(chatRepositoryProvider));
//    //  final counterRef = ref.read(contactsProvider);
//    // // GlobalValueProvider contactsList = GlobalValueProvider();
//    //  switch (message["cmd"]) {
//    //    case "chatContacts":
//    //      counterRef.stream.add(message);
//    //     // ref.read(chatRepositoryProvider.stream).update((stream) => stream - 1);
//    //      // contactsList = message["data"];
//    //      // ref.read(GlobalValueProvider.state).update((state) => null);
//    //      // contactsProvider.read(context)?.contactsList = message["data"];
//    //      break;
//    //  }
//     }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: CallPickupScreen(
        scaffold: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appBarColor,
            centerTitle: false,
            title: const Text(
              'CornCall',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text(
                      'Create Group',
                    ),
                    onTap: () => Future(
                      () => Navigator.pushNamed(
                          context, CreateGroupScreen.routeName),
                    ),
                  )
                ],
              ),
            ],
            bottom: TabBar(
              controller: tabBarController,
              indicatorColor: tabColor,
              indicatorWeight: 4,
              labelColor: tabColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(
                  text: 'CHATS',
                ),
                Tab(
                  text: 'STATUS',
                ),
                Tab(
                  text: 'CALLS',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabBarController,
            children: const [
              ContactsList(),
              StatusContactsScreen(),
              CallHistoryScreen()
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (tabBarController.index == 0) {
                Navigator.pushNamed(context, SelectContactsScreen.routeName);
              } else {
                File? pickedImage = await pickImageFromGallery(context);
                if (pickedImage != null) {
                  Navigator.pushNamed(
                    context,
                    ConfirmStatusScreen.routeName,
                    arguments: pickedImage,
                  );
                }
              }
            },
            backgroundColor: tabColor,
            child: const Icon(
              Icons.comment,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
