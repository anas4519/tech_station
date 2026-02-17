import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tech_station/config/supabase/supabase_config.dart';

import '../../../../core/error/exceptions.dart' as app_exceptions;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(
    String email,
    String password,
    String? displayName,
  );
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required SupabaseClient supabaseClient,
    GoogleSignIn? googleSignIn,
  }) : _supabase = supabaseClient,
       _googleSignIn =
           googleSignIn ??
           GoogleSignIn(
             serverClientId: SupabaseConfig.googleWebClientId,
             scopes: ['email', 'profile'],
           );

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user == null) return null;
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        displayName:
            user.userMetadata?['display_name'] as String? ??
            user.userMetadata?['full_name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );
    });
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        displayName:
            user.userMetadata?['display_name'] as String? ??
            user.userMetadata?['full_name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );
    } catch (e) {
      throw app_exceptions.ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw app_exceptions.AuthException('Sign in failed. No user returned.');
      }

      return UserModel(
        id: user.id,
        email: user.email ?? email,
        displayName:
            user.userMetadata?['display_name'] as String? ??
            user.userMetadata?['full_name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );
    } on AuthApiException catch (e) {
      throw app_exceptions.AuthException(e.message);
    } catch (e) {
      if (e is app_exceptions.AuthException) rethrow;
      throw app_exceptions.ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmail(
    String email,
    String password,
    String? displayName,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          if (displayName != null) 'display_name': displayName,
          if (displayName != null) 'full_name': displayName,
        },
      );

      final user = response.user;
      if (user == null) {
        throw app_exceptions.AuthException('Sign up failed. No user returned.');
      }

      return UserModel(
        id: user.id,
        email: user.email ?? email,
        displayName: displayName,
        avatarUrl: null,
      );
    } on AuthApiException catch (e) {
      throw app_exceptions.AuthException(e.message);
    } catch (e) {
      if (e is app_exceptions.AuthException) rethrow;
      throw app_exceptions.ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      debugPrint('GOOGLE_SIGN_IN: Starting Google Sign-In flow');
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('GOOGLE_SIGN_IN: User cancelled sign-in');
        throw app_exceptions.AuthException('Google sign-in was cancelled.');
      }
      debugPrint('GOOGLE_SIGN_IN: Google user signed in: ${googleUser.email}');

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      debugPrint('GOOGLE_SIGN_IN: ID Token retrieved: ${idToken != null}');
      debugPrint(
        'GOOGLE_SIGN_IN: Access Token retrieved: ${accessToken != null}',
      );

      if (idToken == null) {
        throw app_exceptions.AuthException('Failed to get Google ID token.');
      }

      debugPrint('GOOGLE_SIGN_IN: Attempting Supabase sign-in with ID token');
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      debugPrint('GOOGLE_SIGN_IN: Supabase response received');
      final user = response.user;
      if (user == null) {
        debugPrint('GOOGLE_SIGN_IN: No user returned from Supabase');
        throw app_exceptions.AuthException(
          'Google sign-in failed. No user returned.',
        );
      }
      debugPrint('GOOGLE_SIGN_IN: Sign-in successful for user: ${user.id}');

      return UserModel(
        id: user.id,
        email: user.email ?? googleUser.email,
        displayName:
            googleUser.displayName ??
            user.userMetadata?['full_name'] as String?,
        avatarUrl:
            googleUser.photoUrl ?? user.userMetadata?['avatar_url'] as String?,
      );
    } on AuthApiException catch (e) {
      debugPrint(
        'GOOGLE_SIGN_IN: AuthApiException: ${e.message} code: ${e.statusCode}',
      );
      throw app_exceptions.AuthException(e.message);
    } catch (e) {
      debugPrint('GOOGLE_SIGN_IN: General Exception: $e');
      if (e is app_exceptions.AuthException) rethrow;
      throw app_exceptions.ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _supabase.auth.signOut();
    } catch (e) {
      throw app_exceptions.ServerException(e.toString());
    }
  }
}
