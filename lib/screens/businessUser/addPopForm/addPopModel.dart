import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/screens/businessUser/addPopForm/validators/addPopValidator.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddPopModel with AddPopValidator, ChangeNotifier {
  AddPopModel({
    @required this.database,
    @required this.businessUser,
    this.popName = '',
    this.popDescription = '',
    this.popExpirationTime,
    this.popPhotoPath = '',
    this.popInnerPhotoPath = '',
    this.popUrl = '',
    this.popLocation,
    this.isLoading = false,
    this.submitted = false,
  });

  final FirestoreDatabase database;
  final User businessUser;
  String popName;
  String popDescription;
  DateTime popExpirationTime;
  String popPhotoPath;
  String popInnerPhotoPath;
  String popUrl;
  GeoPoint popLocation;
  bool isLoading;
  bool submitted;

  void updatePopName(String popName) => updateWith(popName: popName);

  void updatePopDescription(String popDescription) => updateWith(popDescription: popDescription);

  void updatePopExpirationTime(DateTime popExpirationTime) => updateWith(popExpirationTime: popExpirationTime);

  void updatePopPhotoPath(String popPhotoPath) => updateWith(popPhotoPath: popPhotoPath);

  void updatePopInnerPhotoPath(String popInnerPhotoPath) => updateWith(popInnerPhotoPath: popInnerPhotoPath);

  void updatePopUrl(String popUrl) => updateWith(popUrl: popUrl);

  void updatePopLocation(LatLng popLocation) => updateWith(popLocation: popLocation);
 
  void updateWith({
    String popName,
    String popDescription,
    DateTime popExpirationTime,
    String popPhotoPath,
    String popInnerPhotoPath,
    String popUrl,
    LatLng popLocation,
    bool isLoading,
    bool submitted,
  }) {
    this.popName = popName ?? this.popName;
    this.popDescription = popDescription ?? this.popDescription;
    this.popExpirationTime = popExpirationTime ?? this.popExpirationTime;
    this.popPhotoPath = popPhotoPath ?? this.popPhotoPath;
    this.popInnerPhotoPath = popInnerPhotoPath ?? this.popInnerPhotoPath;
    this.popUrl = popUrl ?? this.popUrl;
    this.popLocation = popLocation ?? this.popLocation;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  void clearData() {
    updateWith(
      popName: '',
      popDescription: '',
      popExpirationTime: null,
      popPhotoPath: '',
      popInnerPhotoPath: '',
      popUrl: '',
      popLocation: null,
      isLoading: false,
      submitted: false,
    );
  }

  Future<bool> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }

      updateWith(isLoading: true);
      await database.addPop(_createPopFromFormData());

      return true;
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  Pop _createPopFromFormData () {
    return Pop(name: popName, description:  popDescription, expirationTime: popExpirationTime,
    photo: popPhotoPath, innerPhoto: popInnerPhotoPath, url: popUrl, location: popLocation, businessId: businessUser.uid);
  } 

  // Getters
  bool get canSubmitPopName {
    return popNameValidator.isValid(popName);
  }

  bool get canSubmitPopDescription {
    return popDescriptionValidator.isValid(popDescription);
  }

  bool get canSubmitPopExpirationTime {
    return popExpirationTimeValidator.isValid(popExpirationTime);
  }

  bool get canSubmit {
    final bool canSubmitFields = canSubmitPopName && canSubmitPopDescription && canSubmitPopExpirationTime;
    return canSubmitFields && !isLoading;
  }

  String get popNameErrorText {
    final bool showErrorText = submitted && !canSubmitPopName;
    return showErrorText ? Texts.cannotBeEmptyError : null;
  }

  String get popDescriptionErrorText {
    final bool showErrorText = submitted && !canSubmitPopDescription;
    return showErrorText ? Texts.cannotBeEmptyError : null;
  }

  String get popExpirationTimeErrorText {
    final bool showErrorText = submitted && !canSubmitPopExpirationTime;
    return showErrorText ? Texts.expirationTimeError : null;
  }
}
