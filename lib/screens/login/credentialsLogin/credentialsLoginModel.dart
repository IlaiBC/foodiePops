import 'package:flutter/foundation.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/screens/login/validators/credentialsValidators.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';

enum CredentialsFormType { signIn, register, forgotPassword }

class CredentialsLoginModel with CredentialsValidator, ChangeNotifier {
  CredentialsLoginModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = CredentialsFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final FirebaseAuthService auth;

  String email;
  String password;
  CredentialsFormType formType;
  bool isLoading;
  bool submitted;

  Future<bool> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }
      updateWith(isLoading: true);
      switch (formType) {
        case CredentialsFormType.signIn:
          await auth.signInWithEmailAndPassword(email, password);
          break;
        case CredentialsFormType.register:
          await auth.createUserWithEmailAndPassword(email, password);
          break;
        case CredentialsFormType.forgotPassword:
          await auth.sendPasswordResetEmail(email);
          updateWith(isLoading: false);
          break;
      }
      return true;
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateFormType(CredentialsFormType formType) {
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String email,
    String password,
    CredentialsFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == CredentialsFormType.register) {
      return Texts.password8CharactersLabel;
    }
    return Texts.passwordLabel;
  }

  // Getters
  String get primaryButtonText {
    return <CredentialsFormType, String>{
      CredentialsFormType.register: Texts.createAnAccount,
      CredentialsFormType.signIn: Texts.signIn,
      CredentialsFormType.forgotPassword: Texts.sendResetLink,
    }[formType];
  }

  String get secondaryButtonText {
    return <CredentialsFormType, String>{
      CredentialsFormType.register: Texts.haveAnAccount,
      CredentialsFormType.signIn: Texts.needAnAccount,
      CredentialsFormType.forgotPassword: Texts.backToSignIn,
    }[formType];
  }

  CredentialsFormType get secondaryActionFormType {
    return <CredentialsFormType, CredentialsFormType>{
      CredentialsFormType.register: CredentialsFormType.signIn,
      CredentialsFormType.signIn: CredentialsFormType.register,
      CredentialsFormType.forgotPassword:
          CredentialsFormType.signIn,
    }[formType];
  }

  String get errorAlertTitle {
    return <CredentialsFormType, String>{
      CredentialsFormType.register: Texts.registrationFailed,
      CredentialsFormType.signIn: Texts.signInFailed,
      CredentialsFormType.forgotPassword: Texts.passwordResetFailed,
    }[formType];
  }

  String get title {
    return <CredentialsFormType, String>{
      CredentialsFormType.register: Texts.register,
      CredentialsFormType.signIn: Texts.signIn,
      CredentialsFormType.forgotPassword: Texts.forgotPassword,
    }[formType];
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    if (formType == CredentialsFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmit {
    final bool canSubmitFields =
        formType == CredentialsFormType.forgotPassword
            ? canSubmitEmail
            : canSubmitEmail && canSubmitPassword;
    return canSubmitFields && !isLoading;
  }

  String get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText = email.isEmpty
        ? Texts.invalidEmailEmpty
        : Texts.invalidEmailErrorText;
    return showErrorText ? errorText : null;
  }

  String get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty
        ? Texts.invalidPasswordEmpty
        : Texts.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}
