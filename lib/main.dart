// import 'package:dars_73/models/location_view_model.dart';
// import 'package:dars_73/views/screens/home_page.dart';
// import 'package:dars_73/views/widgets/login_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main()async {
//   runApp(
    
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => LocationViewModel()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // home: HomeScreen(),
//       home: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (ctx, snapshot) {
//             if (snapshot.hasData) {
//               return const HomeScreen();
//             }

//             return const LoginScreen();
//           },
//         ),
//     );
//   }
// }









import 'package:dars_73/firebase_options.dart';
import 'package:dars_73/models/location_view_model.dart';
import 'package:dars_73/views/screens/home_page.dart';
import 'package:dars_73/views/widgets/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      // home: StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (ctx, snapshot) {
      //     if (snapshot.hasData) {
      //       return const HomeScreen();
      //     }

      //     return const LoginScreen();
      //   },
      // ),
    );
  }
}
