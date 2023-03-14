import 'package:detest/constant.dart';
import 'package:detest/home_screen.dart';
import 'package:detest/text_input_field.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool apireault = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  Future<void> login() async {
    String email = _emailController.text;
    String psw = _passwordController.text;
    if (email != '' && psw != '') {
      setState(() {
        apireault = true;
      });
      // hashpsw(psw);
      String status = await isUserFound(email, psw);
      if (status == '200') {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(
                  email: email,
                )));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Login successfully!'),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('User Not Exist or Something went wrrong!'),
          ),
        );
        setState(() {
          apireault = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please Enter email or password!'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: SizedBox(
                  width: size.width > 900 ? 460 : size.width * 0.9,
                  height: size.height > 700 ? 450 : size.height * 0.65,
                  // width: 460,
                  // height: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Center(
                        child: Text(
                          'Digital Entomologist',
                          style: TextStyle(
                            fontSize: 35,
                            color: buttonColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 25,
                            color: buttonColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextInputField(
                          initalvalue: 'milanpreetkaur502@gmail.com',
                          controller: _emailController,
                          labelText: 'Email',
                          icon: Icons.email,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextInputField(
                          initalvalue: 'milan@123',
                          controller: _passwordController,
                          labelText: 'Password',
                          icon: Icons.lock,
                          isObscure: true,
                        ),
                      ),
                      const SizedBox(height: 30),
                      !apireault
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: 50,
                              decoration: const BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: InkWell(
                                onTap: login,
                                child: const Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.purple,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
