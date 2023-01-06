// import 'package:agora_uikit/agora_uikit.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:corncall/common/widgets/loader.dart';
import 'package:corncall/config/agora_config.dart';
import 'package:corncall/features/call/controller/call_controller.dart';

import 'package:corncall/models/call.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  // AgoraClient? client;
  String baseUrl = 'https://nutrianalyser.net';
  bool? isAudioOnly = true;
  bool? isAudioMuted = true;
  bool? isVideoMuted = true;
  @override
  void initState() {
    super.initState();
    // client = AgoraClient(
    //   agoraConnectionData: AgoraConnectionData(
    //     appId: AgoraConfig.appId,
    //     channelName: widget.channelId,
    //     tokenUrl: baseUrl,
    //   ),
    // );
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
    _joinMeeting();
  //  initAgora();
  }

  // void initAgora() async {
  //   // await client!.initialize();
  // }
  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String? serverUrl = baseUrl;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: widget.channelId)
      ..serverURL = serverUrl
      ..subject = "test"
      ..userDisplayName = "sandeep"
      ..userEmail = "demo@demo.com"
      ..iosAppBarRGBAColor = "#0080FF80"
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": "test",
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": "sandeep"}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }
  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }
  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Doctor List',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.call.callerPic),
              radius: 60,
            ),
            const SizedBox(height: 50),
            Text(
              widget.call.receiverName,
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
                      widget.call.callerId,
                      widget.call.receiverId,
                      widget.call,
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
    // return Scaffold(
    //   body: const Loader()
    //
    //   // client == null
    //   //     ? const Loader()
    //   //     : SafeArea(
    //   //         child: Stack(
    //   //           children: [
    //   //             AgoraVideoViewer(client: client!),
    //   //             AgoraVideoButtons(
    //   //               client: client!,
    //   //               disconnectButtonChild: IconButton(
    //   //                 onPressed: () async {
    //   //                   await client!.engine.leaveChannel();
    //   //                   ref.read(callControllerProvider).endCall(
    //   //                         widget.call.callerId,
    //   //                         widget.call.receiverId,
    //   //                         context,
    //   //                       );
    //   //                   Navigator.pop(context);
    //   //                 },
    //   //                 icon: const Icon(Icons.call_end),
    //   //               ),
    //   //             ),
    //   //           ],
    //   //         ),
    //   //       ),
    // );
  }
}
