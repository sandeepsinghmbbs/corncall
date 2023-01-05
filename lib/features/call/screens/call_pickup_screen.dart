import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:corncall/features/call/controller/call_controller.dart';
import 'package:corncall/features/call/screens/call_screen.dart';
import 'package:corncall/models/call.dart';

class CallPickupScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickupScreen({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        print('lallllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll');
        // print(snapshot.data!.data());
        if (snapshot.hasData && snapshot.data!.data() != null) {
          Call call =
              Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          print(call);
          if (!call.hasDialled && call.callStatus == 'active') {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 50),
                    CircleAvatar(
                      backgroundImage: NetworkImage(call.callerPic),
                      radius: 60,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      call.callerName,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 75),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Call callne = new Call(callerId: call.callerId, callerName: call.callerName, callerPic: call.callerPic, receiverId: call.receiverId, receiverName: call.receiverName, receiverPic: call.receiverPic, callId: call.callId, hasDialled: call.hasDialled, callPickupStatus: false, callStatus: call.callStatus, initCallDateTime: call.initCallDateTime, endCallDateTime: call.endCallDateTime,isAudio:call.isAudio);

                            //callne.callPickupStatus = false;
                            ref.read(callControllerProvider).endCall(
                                                          call.callerId,
                                                          call.receiverId,
                              callne,
                                                          context,
                                                        );
                                                    Navigator.pop(context);
                          },
                          icon: const Icon(Icons.call_end,
                              color: Colors.redAccent),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallScreen(
                                  channelId: call.callId,
                                  call: call,
                                  isGroupChat: false,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          else if (call.hasDialled && call.callStatus == 'active')
            {
            return  Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'OutGoing Call',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 50),
                      CircleAvatar(
                        backgroundImage: NetworkImage(call.callerPic),
                        radius: 60,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        call.receiverName,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Call callnew = new Call(callerId: call.callerId, callerName: call.callerName, callerPic: call.callerPic, receiverId: call.receiverId, receiverName: call.receiverName, receiverPic: call.receiverPic, callId: call.callId, hasDialled: call.hasDialled, callPickupStatus: false, callStatus: call.callStatus, initCallDateTime: call.initCallDateTime, endCallDateTime: call.endCallDateTime,isAudio:call.isAudio);

                              // call.callPickupStatus = false;
                              // call.callPickupStatus = false;
                              ref.read(callControllerProvider).endCall(
                                call.callerId,
                                call.receiverId,
                                callnew,
                                context,
                              );
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.call_end,
                                color: Colors.redAccent),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
        }
        return scaffold;
      },
    );
  }
}
