import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: CenteredBtn(),
      ),
    );
  }
}

class CenteredBtn extends StatefulWidget {
  const CenteredBtn({super.key});

  @override
  State<CenteredBtn> createState() => _CenteredBtnState();
}

class _CenteredBtnState extends State<CenteredBtn> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await signInWithGoogle();
            },
            child: Text("SIGN IN"),
          ),
          ElevatedButton(
            onPressed: () async {
              await signOut();
            },
            child: Text("SIGN OUT"),
          )
        ],
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  final cred = await FirebaseAuth.instance.signInWithCredential(credential);

  if(cred.user!.email!.contains("@student.ub.ac.id")){
    debugPrint("AKUN STUDENT, NOT DELETED");
  }else{
    await cred.user?.delete();
    debugPrint("BUKAN AKUN STUDENT, DELETED");
  }

  // Once signed in, return the UserCredential
  return cred;
}

Future<GoogleSignInAccount?> signOut() async {
  return await GoogleSignIn().signOut();
}
