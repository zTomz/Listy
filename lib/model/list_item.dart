import 'package:firebase_auth/firebase_auth.dart';

class ListItem {
  final String text;
  bool done;

  ListItem({required this.text, required this.done});

  void cycle() {
    done = !done;
  }
}
