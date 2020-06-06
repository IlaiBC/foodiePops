import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/screens/businessUser/addPopForm/validators/addPopValidator.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/services/firebaseStorageService.dart';
import 'package:foodiepops/services/imagePickerService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPopModel with AddPopValidator, ChangeNotifier {

  AddPopModel({
    @required this.database,
    @required this.businessUser,
    this.popName = '',
    this.popSubTitle= '',
    this.popDescription = '',
    this.popExpirationTime,
    this.popPhotoPath = Texts.emptyPath,
    this.popInnerPhotoPath = Texts.emptyPath,
    this.popUrl = '',
    this.popLocation,
    this.popAddress = '',
    this.isLoading = false,
    this.submitted = false,
  });

  final FirestoreDatabase database;
  final User businessUser;
  String popName;
  String popSubTitle;
  String popDescription;
  DateTime popExpirationTime;
  String popPhotoPath;
  String popInnerPhotoPath;
  String popUrl;
  LatLng popLocation;
  String popAddress;
  bool isLoading;
  bool submitted;

  void updatePopName(String popName) => updateWith(popName: popName);

  void updatePopSubTitle(String popSubTitle) => updateWith(popSubTitle: popSubTitle);


  void updatePopDescription(String popDescription) =>
      updateWith(popDescription: popDescription);

  void updatePopExpirationTime(DateTime popExpirationTime) =>
      updateWith(popExpirationTime: popExpirationTime);

  void updatePopPhotoPath(String popPhotoPath) =>
      updateWith(popPhotoPath: popPhotoPath);

  void updatePopInnerPhotoPath(String popInnerPhotoPath) =>
      updateWith(popInnerPhotoPath: popInnerPhotoPath);

  void updatePopUrl(String popUrl) => updateWith(popUrl: popUrl);

  void updatePopLocation(LatLng popLocation) =>
      updateWith(popLocation: popLocation);

  void updatePopAddress(String popAddress) =>
      updateWith(popAddress: popAddress);

  void updateWith({
    String popName,
    String popSubTitle,
    String popDescription,
    DateTime popExpirationTime,
    String popPhotoPath,
    String popInnerPhotoPath,
    String popUrl,
    LatLng popLocation,
    String popAddress,
    bool isLoading,
    bool submitted,
  }) {
    this.popName = popName ?? this.popName;
    this.popSubTitle = popSubTitle ?? this.popSubTitle;
    this.popDescription = popDescription ?? this.popDescription;
    this.popExpirationTime = popExpirationTime ?? this.popExpirationTime;
    this.popPhotoPath = popPhotoPath ?? this.popPhotoPath;
    this.popInnerPhotoPath = popInnerPhotoPath ?? this.popInnerPhotoPath;
    this.popUrl = popUrl ?? this.popUrl;
    this.popLocation = popLocation ?? this.popLocation;
    this.popAddress = popAddress ?? this.popAddress;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  void clearData() {
    updateWith(
      popName: '',
      popSubTitle: '',
      popDescription: '',
      popExpirationTime: null,
      popPhotoPath: Texts.emptyPath,
      popInnerPhotoPath: Texts.emptyPath,
      popUrl: '',
      popLocation: null,
      popAddress: '',
      isLoading: false,
      submitted: false,
    );
  }

  Future<void> choosePopPhoto(BuildContext context) async {
    String popPhotoPath = await _uploadPhotoAndGetPhotoUrl(context);
    updatePopPhotoPath(popPhotoPath);

  }

  Future<void> choosePopInnerPhoto(BuildContext context) async {
    String popPhotoPath = await _uploadPhotoAndGetPhotoUrl(context);
    updatePopInnerPhotoPath(popPhotoPath);
  }

  Future<String> _uploadPhotoAndGetPhotoUrl(BuildContext context) async {
    final imagePicker = Provider.of<ImagePickerService>(context, listen: false);
    final File file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final storage =
          Provider.of<FirebaseStorageService>(context, listen: false);
      final String popPhotoPath = await storage.uploadPopImage(file: file);

      await file.delete();

      return popPhotoPath;
    }

    return null;
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

  Pop _createPopFromFormData() {
    return Pop(
        name: popName,
        subtitle: popSubTitle,
        description: popDescription,
        expirationTime: popExpirationTime,
        photo: popPhotoPath,
        innerPhoto: popInnerPhotoPath,
        url: popUrl,
        location: GeoPoint(popLocation.latitude, popLocation.longitude),
        address: popAddress,
        businessId: businessUser.uid);
  }

  // Getters
  bool get canSubmitPopName {
    return popNameValidator.isValid(popName);
  }

  bool get canSubmitPopSubTitle {
    return popSubTitleValidator.isValid(popSubTitle);
  }

  bool get canSubmitPopUrl {
    return Uri.parse(popUrl).isAbsolute;
  }

  bool get canSubmitPopDescription {
    return popDescriptionValidator.isValid(popDescription);
  }

  bool get canSubmitPopExpirationTime {
    return popExpirationTimeValidator.isValid(popExpirationTime);
  }

  bool get canSubmit {
    final bool canSubmitFields = canSubmitPopName &&
        canSubmitPopDescription &&
        canSubmitPopExpirationTime;
    return canSubmitFields && !isLoading;
  }

  String get popNameErrorText {
    final bool showErrorText = submitted && !canSubmitPopName;
    return showErrorText ? Texts.cannotBeEmptyError : null;
  }

  String get popSubTitleErrorText {
    final bool showErrorText = submitted && !canSubmitPopSubTitle;
    return showErrorText ? Texts.cannotBeEmptyError : null;
  }

    String get popUrlErrorText {
    final bool showErrorText = submitted && !canSubmitPopUrl;
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
