import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

import '../datasources/remote/remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Stream<UserEntity?> get authStateChanges => _firebaseAuth
      .authStateChanges()
      .map((user) => user != null ? UserEntity.fromFirebaseUser(user) : null);

  @override
  UserEntity? get currentUser => _firebaseAuth.currentUser != null
      ? UserEntity.fromFirebaseUser(_firebaseAuth.currentUser!)
      : null;

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      debugPrint('GOOGLE SIGN-IN: Starting sign-in process...');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('GOOGLE SIGN-IN: User cancelled sign-in');
        return null;
      }

      debugPrint('GOOGLE SIGN-IN: Got Google user: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      debugPrint('GOOGLE SIGN-IN: Got auth tokens');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('GOOGLE SIGN-IN: Creating Firebase credential...');
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      debugPrint('GOOGLE SIGN-IN: Firebase sign-in successful');

      if (userCredential.user != null) {
        final entity = UserEntity.fromFirebaseUser(userCredential.user!);
        // Save/Update profile in Firestore
        await _remoteDataSource.saveUserProfile({
          'uid': entity.id,
          'email': entity.email,
          'displayName': entity.displayName,
          'photoUrl': entity.photoUrl,
          'lastLogin': FieldValue.serverTimestamp(),
        });
        debugPrint('GOOGLE SIGN-IN: Profile saved to Firestore');
        return entity;
      }
      return null;
    } catch (e) {
      debugPrint('GOOGLE SIGN-IN ERROR: $e');
      debugPrint('GOOGLE SIGN-IN ERROR TYPE: ${e.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return UserEntity.fromFirebaseUser(credential.user!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        final entity = UserEntity.fromFirebaseUser(credential.user!);
        // Save profile to Firestore
        await _remoteDataSource.saveUserProfile({
          'uid': entity.id,
          'email': entity.email,
          'displayName': entity.displayName,
          'photoUrl': entity.photoUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return entity;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
