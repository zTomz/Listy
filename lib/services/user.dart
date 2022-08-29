import 'package:firebase_auth/firebase_auth.dart';

Future getProfileImage() async {
  String? photoUrl = await FirebaseAuth.instance.currentUser?.photoURL;
  print(photoUrl);
}
