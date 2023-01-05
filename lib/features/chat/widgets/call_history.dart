import 'package:corncall/models/call_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:corncall/common/utils/colors.dart';
import 'package:corncall/common/widgets/loader.dart';
import 'package:corncall/features/chat/controller/chat_controller.dart';
import 'package:corncall/features/chat/screens/mobile_chat_screen.dart';
import 'package:corncall/models/chat_contact.dart';
import 'package:corncall/models/group.dart';

import '../../call/controller/call_controller.dart';

class CallHistoryScreen extends ConsumerWidget {
  const CallHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person,color: Colors.white,size:30),
                  radius: 25,
                  backgroundColor: Colors.green.shade700,
                ),
                const SizedBox(width: 25 ,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  const [
                    Text("Create call link",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,)),
                    Text("Share a link for your Corncall call",style: TextStyle(fontSize: 13),)
                  ],
                )
              ],
            ),
            StreamBuilder<List<CallHistory>>(
                stream: ref.watch(callControllerProvider).getCallHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }

                  return //Container();
                    ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var history = snapshot.data![index];

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              // Navigator.pushNamed(
                              //   context,
                              //   MobileChatScreen.routeName,
                              //   arguments: {
                              //     'name': groupData.name,
                              //     'uid': groupData.groupId,
                              //     'isGroupChat': true,
                              //     'profilePic': groupData.groupPic,
                              //   },
                              // );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  history.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                      DateFormat.d().format(history.timeSent) + '/' + DateFormat.M().format(history.timeSent) + '/' +  DateFormat.y().format(history.timeSent) + ', ' +  DateFormat.Hm().format(history.timeSent) ,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    history.profilePic,
                                  ),
                                  radius: 30,
                                ),
                                trailing: Icon(Icons.call,color: Colors.green.shade700,size:27,)
                      // Text(
                      //             DateFormat.Hm().format(history.timeSent),
                      //             style: const TextStyle(
                      //               color: Colors.grey,
                      //               fontSize: 13,
                      //             ),
                      //           ),
                              ),
                            ),
                          ),
                          const Divider(color: dividerColor, indent: 85),
                        ],
                      );
                    },
                  );
                }),
            // StreamBuilder<List<ChatContact>>(
            //     stream: ref.watch(chatControllerProvider).chatContacts(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const Loader();
            //       }
            //
            //       return ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: snapshot.data!.length,
            //         itemBuilder: (context, index) {
            //           var chatContactData = snapshot.data![index];
            //
            //           return Column(
            //             children: [
            //               InkWell(
            //                 onTap: () {
            //                   Navigator.pushNamed(
            //                     context,
            //                     MobileChatScreen.routeName,
            //                     arguments: {
            //                       'name': chatContactData.name,
            //                       'uid': chatContactData.contactId,
            //                       'isGroupChat': false,
            //                       'profilePic': chatContactData.profilePic,
            //                     },
            //                   );
            //                 },
            //                 child: Padding(
            //                   padding: const EdgeInsets.only(bottom: 8.0),
            //                   child: ListTile(
            //                     title: Text(
            //                       chatContactData.name,
            //                       style: const TextStyle(
            //                         fontSize: 18,
            //                       ),
            //                     ),
            //                     subtitle: Padding(
            //                       padding: const EdgeInsets.only(top: 6.0),
            //                       child: Text(
            //                         chatContactData.lastMessage,
            //                         style: const TextStyle(fontSize: 15),
            //                       ),
            //                     ),
            //                     leading: CircleAvatar(
            //                       backgroundImage: NetworkImage(
            //                         chatContactData.profilePic,
            //                       ),
            //                       radius: 30,
            //                     ),
            //                     trailing: Text(
            //                       DateFormat.Hm()
            //                           .format(chatContactData.timeSent),
            //                       style: const TextStyle(
            //                         color: Colors.grey,
            //                         fontSize: 13,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               const Divider(color: dividerColor, indent: 85),
            //             ],
            //           );
            //         },
            //       );
            //     }),
          ],
        ),
      ),
    );
  }
}
