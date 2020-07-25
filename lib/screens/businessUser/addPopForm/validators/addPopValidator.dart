import 'package:foodiepops/validators/dateTimeValidator.dart';
import 'package:foodiepops/validators/stringValidator.dart';
import 'package:foodiepops/validators/RegexValidator.dart';


class AddPopValidator {
  final StringValidator popNameValidator = NonEmptyStringValidator();
  final StringValidator popSubTitleValidator = NonEmptyStringValidator();
  final StringValidator popDescriptionValidator = NonEmptyStringValidator();
  final StringValidator popCouponValidator = NonEmptyStringValidator();
  final DateTimeValidator popExpirationTimeValidator = DateTimeValidator();
}