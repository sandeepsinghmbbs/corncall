import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:corncall/common/utils/colors.dart';
import 'package:corncall/common/widgets/error.dart';
import 'package:corncall/common/widgets/loader.dart';
import 'package:corncall/features/auth/controller/auth_controller.dart';
import 'package:corncall/features/landing/screens/landing_screen.dart';
import 'package:corncall/firebase_options.dart';
import 'package:corncall/router.dart';
import 'package:corncall/mobile_layout_screen.dart';
import 'package:provider/provider.dart';

//import 'features/chat/api/apis/socketHelper.dart';
import 'global_view_modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 // SocketService().initConnection();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CornCall',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
