class DateTimeValidator {
  bool isValid(DateTime dateTime) {
    return dateTime.isAfter(DateTime.now());
  }
}