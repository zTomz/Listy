import 'package:flutter/material.dart';
import 'package:listy/services/authentication.dart';
import 'package:listy/widgets/button.dart';
import 'package:listy/widgets/text_field.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  int currentPage = 0;
  PageController pageController = PageController();

  TextEditingController email1 = TextEditingController();
  TextEditingController password11 = TextEditingController();
  TextEditingController password12 = TextEditingController();
  TextEditingController email2 = TextEditingController();
  TextEditingController password2 = TextEditingController();

  @override
  void dispose() {
    email1.dispose();
    password11.dispose();
    password12.dispose();
    email2.dispose();
    password2.dispose();

    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 32, left: 32, bottom: 64, right: 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
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
                const SizedBox(height: 100),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (newPage) {
                      setState(() {
                        currentPage = newPage;
                      });
                    },
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            TextInputField(
                                textEditingController: email1,
                                hint: "Email",
                                textInputType: TextInputType.emailAddress),
                            TextInputField(
                                textEditingController: password11,
                                hint: "Password",
                                textInputType: TextInputType.visiblePassword),
                            TextInputField(
                                textEditingController: password12,
                                hint: "Repeat password",
                                textInputType: TextInputType.visiblePassword),
                            const SizedBox(height: 25),
                            Button(
                              title: "Sign Up",
                              onPressed: () async {
                                String result =
                                    await singUpWithEmailAndPassword(
                                  email1.text,
                                  password11.text,
                                  password12.text,
                                );
                                debugPrint(result);
                                if (result == "Signed In") {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
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
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            TextInputField(
                                textEditingController: email2,
                                hint: "Email",
                                textInputType: TextInputType.emailAddress),
                            TextInputField(
                                textEditingController: password2,
                                hint: "Password",
                                textInputType: TextInputType.visiblePassword),
                            const SizedBox(height: 25),
                            Button(
                              title: "Sign Up",
                              onPressed: () async {
                                String result =
                                    await singInWithEmailAndPassword(
                                  email1.text,
                                  password11.text,
                                );
                                debugPrint(result);
                                if (result == "Signed In") {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
