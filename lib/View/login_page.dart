import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikum1/Controller/AuthController.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.put(AuthController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF34303E),
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.blueAccent)),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.blueAccent),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Obx(() {
              return ElevatedButton(
                  onPressed: _authController.isLoading.value
                      ? null
                      : () {
                          _authController.loginUser(
                              _emailController.text, _passwordController.text);
                        },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          _authController.isLoading.value
                              ? Colors.grey
                              : Colors.blue)),
                  child: _authController.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Login',
                          style: TextStyle(color: Colors.black87)));
            })
          ],
        ),
      ),
    );
  }
}
