import 'package:flutter/material.dart';
import 'home_page.dart';
import 'services/api_service.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

 void _handleLogin() async {
  final email = _userController.text.trim();
  final password = _passController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter email and password')),
    );
    return;
  }

  try {
    final token = await ApiService.login(email, password);

    if (token != null) {
      debugPrint("JWT Token: $token");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MyHomePage(
              title: 'Flutter Demonstration Home Page'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
  
  debugPrint('login email="$email" password length=${password.length}');

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => const MyHomePage(title: 'Flutter Demonstration Home Page'),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
           title: const Row(
            children: [
              Text('Employee List',style: TextStyle(fontSize: 16)),
            ],

        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // On wide screens (tablet / laptop), keep form at a nice max width
                  maxWidth: 420,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _userController,
                      decoration: const InputDecoration(
                        labelText: 'Email or Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedSuperellipseBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
