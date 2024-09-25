import 'package:didpay/services/biometric_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:local_auth/local_auth.dart';

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  late BiometricAuthService biometricAuthService;
  late MockLocalAuthentication mockLocalAuthentication;

  setUpAll(() {
    registerFallbackValue(const AuthenticationOptions());
  });

  setUp(() {
    mockLocalAuthentication = MockLocalAuthentication();
    biometricAuthService = BiometricAuthService();
    biometricAuthService.auth = mockLocalAuthentication;
  });

  group('BiometricAuthService', () {
    test('canCheckBiometrics returns true when biometrics are available', () async {
      when(() => mockLocalAuthentication.canCheckBiometrics)
          .thenAnswer((_) async => true);

      final result = await biometricAuthService.canCheckBiometrics();

      expect(result, true);
      verify(() => mockLocalAuthentication.canCheckBiometrics).called(1);
    });

    test('authenticate returns true when authentication is successful', () async {
      when(() => mockLocalAuthentication.authenticate(
            localizedReason: any(named: 'localizedReason'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => true);

      final result = await biometricAuthService.authenticate();

      expect(result, true);
      verify(
        () => mockLocalAuthentication.authenticate(
          localizedReason: any(named: 'localizedReason'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('authenticate returns false when authentication fails', () async {
      when(() => mockLocalAuthentication.authenticate(
            localizedReason: any(named: 'localizedReason'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => false);

      final result = await biometricAuthService.authenticate();

      expect(result, false);
      verify(
        () => mockLocalAuthentication.authenticate(
          localizedReason: any(named: 'localizedReason'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });
  });
}
