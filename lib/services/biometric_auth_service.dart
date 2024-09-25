import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  late LocalAuthentication auth;

  Future<bool> canCheckBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print(e);
      return false;
    }
  }
}
