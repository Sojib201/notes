import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/auth_service.dart';
import '../../core/constants/app_router.dart';
import 'note_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  User? get currentUser => _authService.currentUser;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  void clearError() => errorMessage.value = '';

  Future<void> signInWithEmail(BuildContext context) async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _authService.signInWithEmail(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.find<NoteController>().startListeningToNotes();

      if (context.mounted) {
        context.go(AppRouter.home);
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getAuthErrorMessage(e.code);
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerWithEmail(BuildContext context) async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _authService.registerWithEmail(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      await _authService.signOut();

      _clearControllers();

      Get.snackbar(
        'Account Created',
        'Please log in with your new account',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00BFA5),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );

      if (context.mounted) {
        context.go(AppRouter.login);
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getAuthErrorMessage(e.code);
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    isLoading.value = true;
    try {
      await _authService.signOut();
      _clearControllers();
      if (context.mounted) {
        context.go(AppRouter.login);
      }
    } catch (e) {
      errorMessage.value = 'Failed to sign out. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordResetEmail(BuildContext context) async {
    if (emailController.text.isEmpty) {
      errorMessage.value = 'Please enter your email address first.';
      return;
    }

    isLoading.value = true;
    try {
      await _authService.sendPasswordResetEmail(emailController.text);
      if (context.mounted) {
        Get.snackbar(
          'Email Sent',
          'Password reset email sent to ${emailController.text}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF00BFA5),
          colorText: const Color(0xFFFFFFFF),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to send reset email. Check your email address.';
    } finally {
      isLoading.value = false;
    }
  }

  void _clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check and try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Minimum 6 characters required';
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }
}
