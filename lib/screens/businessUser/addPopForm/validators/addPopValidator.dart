import 'package:foodiepops/validators/dateTimeValidator.dart';
import 'package:foodiepops/validators/stringValidator.dart';

class AddPopValidator {
  final StringValidator popNameValidator = NonEmptyStringValidator();
  final StringValidator popDescriptionValidator = NonEmptyStringValidator();
  final DateTimeValidator popExpirationTimeValidator = DateTimeValidator();
}