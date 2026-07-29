cat > lib/services/auth_service.dart <<'EOF'
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> register({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
EOF
