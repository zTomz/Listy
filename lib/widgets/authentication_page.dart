import 'package:flutter/material.dart';
import 'package:listy/services/authentication.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int currentPage = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                pageController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                "Sign Up",
                style: theme.textTheme.bodyText1!.copyWith(
                  fontSize: 20,
                  color: currentPage == 0 ? Colors.black : Colors.grey,
                ),
              ),
            ),
            Container(
              width: 3,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(90),
              ),
            ),
            GestureDetector(
              onTap: () {
                /*
                The following code, does not work:
                pageController.animateTo(
                  1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
                I dont know why. It goes every time to the first page and not o the second.
                */
                pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                "Sign In",
                style: theme.textTheme.bodyText1!.copyWith(
                  fontSize: 20,
                  color: currentPage == 1 ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (newPage) {
              setState(() {
                currentPage = newPage;
              });
            },
            children: [
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.blue,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            signInWithGoogle();
          },
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade300,
                  spreadRadius: 5,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Image.asset(
              "assets/img/google.png",
            ),
          ),
        )
      ],
    );
  }
}
