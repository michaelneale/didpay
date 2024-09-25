import 'package:flutter/material.dart';
import 'biometric_auth_service.dart';

class BiometricAuthPage extends StatefulWidget {
  const BiometricAuthPage({Key? key}) : super(key: key);

  @override
  _BiometricAuthPageState createState() => _BiometricAuthPageState();
}

class _BiometricAuthPageState extends State<BiometricAuthPage> {
  final BiometricAuthService _authService = BiometricAuthService();
  bool _isAuthenticated = false;

  Future<void> _authenticate() async {
    final isAuthenticated = await _authService.authenticate();
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isAuthenticated)
              const Text('You are authenticated')
            else
              const Text('Not authenticated'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }
}
