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
  List<String> selectedKitchenTypes = [];
  int minPrice = 0;
  int maxPrice = 100;

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

      
  void updateSelectedKitchenTypes(List<String> selectedKitchenTypes) =>
      updateWith(selectedKitchenTypes: selectedKitchenTypes);

  void updateMinMaxPrice(int minPrice, int maxPrice) =>
      updateWith(minPrice: minPrice, maxPrice: maxPrice);

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
    List<String> selectedKitchenTypes,
    int minPrice,
    int maxPrice,
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
    this.selectedKitchenTypes = selectedKitchenTypes ?? this.selectedKitchenTypes;
    this.minPrice = minPrice ?? this.minPrice;
    this.maxPrice = maxPrice ?? this.maxPrice;
    notifyListeners();
  }

  void setPopToEdit(Pop pop) {
    print('pop name is ${pop.name}');
    this.popName = pop.name;
    this.popSubTitle = pop.subtitle;
    this.popDescription = pop.description;
    this.popExpirationTime = pop.expirationTime;
    this.popPhotoPath = pop.photo;
    this.popInnerPhotoPath = pop.innerPhoto;
    this.popUrl = pop.url;
    this.popLocation =  LatLng(pop.location.latitude, pop.location.longitude);
    this.popAddress = pop.address;
    this.selectedKitchenTypes = pop.kitchenTypes;
    this.minPrice = pop.minPrice;
    this.maxPrice = pop.maxPrice;
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
      selectedKitchenTypes: [],
      minPrice: 0,
      maxPrice: 100,
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

  Future<bool> submit(Pop editedPop) async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }

      updateWith(isLoading: true);

      if (editedPop != null) {
        await database.updatePop(_updatePopFromFormData(editedPop));
        updateWith(isLoading: false);
      } else {
        await database.addPop(_createPopFromFormData());
      }

      updateWith(isLoading: false);
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
        businessId: businessUser.uid,
        kitchenTypes: selectedKitchenTypes,
        minPrice: minPrice,
        maxPrice: maxPrice,
        priceRank: _calculatePriceRank(),
        );
  }

  Pop _updatePopFromFormData(Pop editedPop) {
      return Pop(
        id: editedPop.id,
        name: popName,
        subtitle: popSubTitle,
        description: popDescription,
        expirationTime: popExpirationTime,
        photo: popPhotoPath,
        innerPhoto: popInnerPhotoPath,
        url: popUrl,
        location: GeoPoint(popLocation.latitude, popLocation.longitude),
        address: popAddress,
        businessId: businessUser.uid,
        kitchenTypes: selectedKitchenTypes,
        minPrice: minPrice,
        maxPrice: maxPrice,
        priceRank: _calculatePriceRank(),
        );
  }

  int _calculatePriceRank (){
    if (maxPrice <= 60) {
      return 1;
    }

    if (maxPrice <= 80) {
      return 2;
    }

    if (maxPrice <= 100) {
      return 3;
    }

    return 3;
  }

  // Getters
  bool get canSubmitPopName {
    return popNameValidator.isValid(popName);
  }

  bool get canSubmitPopSubTitle {
    return popSubTitleValidator.isValid(popSubTitle);
  }

  bool get canSubmitPopUrl {
    String popUrlToParse = (popUrl.contains("http://") || popUrl.contains("https://")) ? popUrl : 'http://$popUrl'; 
    return Uri.parse(popUrlToParse).isAbsolute;
  }

  bool get canSubmitPopDescription {
    return popDescriptionValidator.isValid(popDescription);
  }

  bool get canSubmitPopExpirationTime {
    return popExpirationTimeValidator.isValid(popExpirationTime);
  }

  bool get canSubmit {
    print('checking if can submit');
    print('checking if can submit canSubmitPopName $canSubmitPopName');
    print('checking if can submit canSubmitPopDescription $canSubmitPopDescription');
    print('checking if can submit canSubmitPopExpirationTime $canSubmitPopExpirationTime');
    print('checking if can submit isLoading $isLoading');




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
