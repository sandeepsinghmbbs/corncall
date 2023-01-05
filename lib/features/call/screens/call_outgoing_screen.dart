import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:corncall/features/call/controller/call_controller.dart';
import 'package:corncall/features/call/screens/call_screen.dart';
import 'package:corncall/models/call.dart';

class CallOutGoingScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallOutGoingScreen({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          Call call =
          Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialled && call.callStatus == 'active') {
            return Scaffold(
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
                            ref.read(callControllerProvider).endCall(
                              call.callerId,
                              call.receiverId,
                              call,
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
