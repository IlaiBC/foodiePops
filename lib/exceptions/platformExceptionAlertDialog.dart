import 'package:flutter/services.dart';
import 'package:foodiepops/constants/firebaseAuthErrors.dart';
import 'package:foodiepops/widgets/platformAlertDialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({String title, PlatformException exception})
      : super(
    title: title,
    content: message(exception),
    defaultActionText: 'OK',
  );

  static String message(PlatformException exception) {
    if (exception.message == 'FIRFirestoreErrorDomain') {
      if (exception.code == 'Code 7') {
        // This happens when we get a "Missing or insufficient permissions" error
        return 'This operation could not be completed due to a server error';
      }
      return exception.details;
    }
    return FireBaseAuthErrors.errors[exception.code] ?? exception.message;
  }
}
