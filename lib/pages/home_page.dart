import 'package:flutter/material.dart';
import 'package:listy/services/authentication.dart';
import 'package:listy/widgets/authentication_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Listy",
                  style: theme.textTheme.headline1,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Container(
                        margin: const EdgeInsets.only(
                          top: 75,
                          left: 50,
                          right: 50,
                          bottom: 150,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const AuthPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.face_rounded),
                  iconSize: 35,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
