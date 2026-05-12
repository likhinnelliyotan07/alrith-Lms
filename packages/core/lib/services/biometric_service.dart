import 'package:local_auth/local_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access Arlith LMS',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      return false;
    }
  }
}
