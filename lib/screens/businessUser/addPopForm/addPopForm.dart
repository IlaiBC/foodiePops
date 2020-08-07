import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/constants/api_key.dart';
import 'package:foodiepops/constants/keys.dart';
import 'package:foodiepops/exceptions/platformExceptionAlertDialog.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/screens/businessUser/addPopForm/addPopModel.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/widgets/dateTimePicker.dart';
import 'package:foodiepops/widgets/formSubmitButton.dart';
import 'package:foodiepops/widgets/formWidgets.dart';
import 'package:foodiepops/widgets/platformAlertDialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:foodiepops/widgets/ClickableImageUpload.dart';
import 'package:filter_list/filter_list.dart';
import 'package:foodiepops/constants/generalConsts.dart';
import 'package:http/http.dart' as http;

class AddPopFormBuilder extends StatelessWidget {
  const AddPopFormBuilder({Key key, this.popToEdit, this.isDuplicateMode}) : super(key: key);
  final Pop popToEdit;
  final bool isDuplicateMode;

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase database =
        Provider.of<FirestoreDatabase>(context, listen: false);
    final businessUser = Provider.of<User>(context, listen: false);

    return ChangeNotifierProvider<AddPopModel>(
      create: (_) =>
          AddPopModel(database: database, businessUser: businessUser),
      child: Consumer<AddPopModel>(
        builder: (_, AddPopModel model, __) =>
            AddPopForm(model: model, popToEdit: popToEdit, isDuplicateMode: isDuplicateMode),
      ),
    );
  }
}

class AddPopForm extends StatefulWidget {
  AddPopForm({Key key, @required this.model, this.popToEdit, this.isDuplicateMode})
      : super(key: key);
  final AddPopModel model;
  final Pop popToEdit;
  final bool isDuplicateMode;

  @override
  _AddPopFormState createState() => _AddPopFormState();
}

class _AddPopFormState extends State<AddPopForm> {
  final FocusScopeNode _node = FocusScopeNode();

  final TextEditingController _popNameController = TextEditingController();
  final TextEditingController _popDescriptionController =
      TextEditingController();
  final TextEditingController _popUrlController = TextEditingController();
  final TextEditingController _popCouponController = TextEditingController();


  DateTime _popExpirationDate;
  TimeOfDay _popExpirationTime;
  bool _isUploadingPopPhoto;
  bool _isUploadingPopInnerPhoto;
  RangeValues _values = RangeValues(0, 200);
  bool isEditingPop = true;
  Future<LatLng> location;

  Future<LatLng> fetchLocation() async {
  final response = await http.get('https://api.ipify.org');

  if (response.statusCode == 200) {
    String ip = response.body;
    final locationResponse = await http.get('http://ip-api.com/json/$ip?fields=lat,lon');

    if (locationResponse.statusCode == 200) {
      Map<String, dynamic> locationJson = jsonDecode(locationResponse.body);
      return LatLng(locationJson['lat'], locationJson['lon']);
    }

  } 
    return null;
  }

  @override
  void initState() {
    super.initState();
    location = fetchLocation();
    _isUploadingPopPhoto = false;
    _isUploadingPopInnerPhoto = false;
    isEditingPop = true;

    if (widget.popToEdit != null) {
      _setControllersWithPopData();
      _setPopExpirationDateTime();
      model.setPopToEdit(widget.popToEdit);
      _values =
          RangeValues(model.minPrice.toDouble(), model.maxPrice.toDouble());
    } else {
      _popExpirationDate = DateTime.now();
      _popExpirationTime = TimeOfDay.now();
    }
  }

  void _setControllersWithPopData() {
    _popNameController.text = widget.popToEdit.name;
    _popDescriptionController.text = widget.popToEdit.description;
    _popUrlController.text = widget.popToEdit.url;
    _popCouponController.text = widget.popToEdit.coupon;
  }

  void _setPopExpirationDateTime() {
    DateTime popExpirationDateTime = widget.popToEdit.expirationTime;

    _popExpirationDate = popExpirationDateTime;
    _popExpirationTime = TimeOfDay(
        hour: popExpirationDateTime.hour, minute: popExpirationDateTime.minute);
  }

  AddPopModel get model => widget.model;

  @override
  void dispose() {
    _node.dispose();
    _popNameController.dispose();
    _popDescriptionController.dispose();
    _popUrlController.dispose();
    _popCouponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<LatLng>(
                    future: location,
                    builder: (BuildContext context,
                        AsyncSnapshot<LatLng> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return _buildContent(context, snapshot.data);
                      }
                      
                      return Container(height:MediaQuery.of(context).size.height, child: Center(child: new CircularProgressIndicator()));
                    });
  }

  Future<void> _submit(BuildContext context) async {
    model.updatePopExpirationTime(_getPopExpirationTimeFromState());

    try {
      final bool success = await model.submit(widget.popToEdit, widget.isDuplicateMode);
      if (success) {
        await PlatformAlertDialog(
          title: Texts.popSubmitSuccessTitle,
          content: Texts.popSubmitSuccessMessage,
          defaultActionText: Texts.ok,
        ).show(context);

        _clearForm();
      } else {
        _showValidationSnackBar(context);
      }
    } on Exception catch (e) {
              await PlatformAlertDialog(
          title: Texts.errorSubmittingPopTitle,
          content: Texts.errorSubmittingPopMessage,
          defaultActionText: Texts.ok,
        ).show(context);
    }
  }

  _showValidationSnackBar (BuildContext context) {
    String validationErrorText = model.getValidationErrorText();
          Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(validationErrorText),
        ),
      );
  }

  Future<void> _uploadPopPhoto(BuildContext context) async {
    try {
      _setUploadPopPhotoLoading(true);
      await model.choosePopPhoto(context);
      _setUploadPopPhotoLoading(false);
    } on PlatformException catch (e) {
      _setUploadPopPhotoLoading(false);
      _showPopPhotoUploadError(model, e);
    } on Exception catch(e) {
      _setUploadPopPhotoLoading(false);
      _showPopPhotoUploadException(e);
    }
  }

  _setUploadPopPhotoLoading(bool isLoading) {
    setState(() {
      _isUploadingPopPhoto = isLoading;
    });
    model.updateWith(isLoading: isLoading);
  }

  _setUploadPopInnerPhotoLoading(bool isLoading) {
    setState(() {
      _isUploadingPopInnerPhoto = isLoading;
    });
    model.updateWith(isLoading: isLoading);
  }

  Future<void> _uploadPopInnerPhoto(BuildContext context) async {
    try {
      _setUploadPopInnerPhotoLoading(true);
      await model.choosePopInnerPhoto(context);
      _setUploadPopInnerPhotoLoading(false);
    } on PlatformException catch (e) {
      _setUploadPopInnerPhotoLoading(false);
      _showPopPhotoUploadError(model, e);
    }
  }

  DateTime _getPopExpirationTimeFromState() {
    return DateTime(
        _popExpirationDate.year,
        _popExpirationDate.month,
        _popExpirationDate.day,
        _popExpirationTime.hour,
        _popExpirationTime.minute);
  }

  void _clearForm() {
    model.clearData();
    _popNameController.clear();
    _popDescriptionController.clear();
    _popUrlController.clear();
    _popCouponController.clear();
    _popExpirationDate = DateTime.now();
    _popExpirationTime = TimeOfDay.now();
    _values = RangeValues(0, 200);
    isEditingPop = false;
  }

  void _isFieldEditingComplete(bool canSubmitField) {
    if (canSubmitField) {
      _node.nextFocus();
    }
  }

  Widget _buildPopExpirationDatePicker() {
    return DateTimePicker(
      labelText: 'Expiration',
      selectedDate: _popExpirationDate,
      selectedTime: _popExpirationTime,
      onSelectedDate: (date) => setState(() => _popExpirationDate = date),
      onSelectedTime: (time) => setState(() => _popExpirationTime = time),
    );
  }

  Widget _buildPopNameField() {
    return FormWidgets.formFieldContainer(TextField(
      key: Key('popName'),
      controller: _popNameController,
      decoration: InputDecoration(
        labelText: Texts.popNameLabel,
        hintText: Texts.popNameHint,
        errorText: model.popNameErrorText,
        enabled: !model.isLoading,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        border: InputBorder.none,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardAppearance: Brightness.light,
      onChanged: model.updatePopName,
      onEditingComplete: () => _isFieldEditingComplete(model.canSubmitPopName),
    ));
  }

  Widget _buildPopCouponField() {
    return FormWidgets.formFieldContainer(TextField(
      key: Key('popCoupon'),
      controller: _popCouponController,
      decoration: InputDecoration(
        labelText: Texts.popCouponLabel,
        hintText: Texts.popCouponHint,
        errorText: model.popCouponErrorText,
        enabled: !model.isLoading,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        border: InputBorder.none,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardAppearance: Brightness.light,
      onChanged: model.updatePopCoupon,
      onEditingComplete: () =>
          _isFieldEditingComplete(model.canSubmitPopCoupon),
    ));
  }

  Widget _buildPopUrlField() {
    return FormWidgets.formFieldContainer(TextField(
      key: Key('popUrl'),
      controller: _popUrlController,
      decoration: InputDecoration(
        labelText: Texts.popUrlLabel,
        hintText: Texts.popUrlHint,
        errorText: model.popUrlErrorText,
        enabled: !model.isLoading,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        border: InputBorder.none,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardAppearance: Brightness.light,
      onChanged: model.updatePopUrl,
      onEditingComplete: () => _isFieldEditingComplete(model.canSubmitPopUrl),
    ));
  }

  Widget _buildPopDescriptionField() {
    return FormWidgets.formFieldContainer(TextField(
      key: Key('description'),
      controller: _popDescriptionController,
      decoration: InputDecoration(
        labelText: Texts.popDescriptionLabel,
        hintText: Texts.popDescriptionHint,
        errorText: model.popDescriptionErrorText,
        enabled: !model.isLoading,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        border: InputBorder.none,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardAppearance: Brightness.light,
      onChanged: model.updatePopDescription,
      onEditingComplete: () =>
          _isFieldEditingComplete(model.canSubmitPopDescription),
      maxLines: Pop.MAX_DESCRIPTION_LINES,
    ));
  }

  Widget _buildPriceRangeSlider() {
    return Container(
        child: Column(
      children: <Widget>[
        Text('Meal Price Range: ${_values.start.round()}₪ - ${_values.end.round()}₪',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 20.0)),
        SliderTheme(
            data:
                SliderThemeData(showValueIndicator: ShowValueIndicator.always),
            child: RangeSlider(
                values: _values,
                labels: RangeLabels(
                    '${_values.start.round()}₪', '${_values.end.round()}₪'),
                min: 0,
                max: 200,
                divisions: 20,
                onChanged: (RangeValues values) {
                  setState(() {
                    if (values.end - values.start >= 20) {
                      _values = values;
                    } else {
                      if (_values.start == values.start) {
                        _values =
                            RangeValues(_values.start, _values.start + 20);
                      } else {
                        _values = RangeValues(_values.end - 20, _values.end);
                      }
                    }
                  });
                  model.updateMinMaxPrice(
                      _values.start.round(), _values.end.round());
                }))
      ],
    ));
  }

  void _openKitchenTypesList() async {
    var list = await FilterList.showFilterList(
      context,
      allTextList: GeneralConsts.kitchenTypes,
      height: 480,
      borderRadius: 20,
      headlineText: "Select Kitchen Types",
      searchFieldHintText: "Search Here",
      selectedTextList: model.selectedKitchenTypes,
      applyButonTextBackgroundColor: Color(0xffe51923),
      headerTextColor: Color(0xffe51923),
      selectedTextBackgroundColor: Color(0xffe51923),
      closeIconColor: Color(0xffe51923),
      allResetButonColor: Color(0xffe51923),
    );

    if (list != null) {
      model.updateSelectedKitchenTypes(List.from(list));
    }
  }

  Widget _buildKitchenTypesField() {
    if (model.selectedKitchenTypes.length > 0) {
      return Container(
          child: Column(
        children: <Widget>[
          Text("Selected Kitchen types",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20.0)),
          SizedBox(height: 8.0),
          Wrap(alignment: WrapAlignment.center, spacing: 20, children: <Widget>[
            ...List<Widget>.generate(model.selectedKitchenTypes.length,
                (int index) {
              final String currentKitchen = model.selectedKitchenTypes[index];

              return GestureDetector(onTap: _openKitchenTypesList, child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red[500],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Text(currentKitchen),
              ));
            })
          ])
        ],
      ));
    }
    return Container(
        child: Column(
      children: <Widget>[
        Text("Select Kitchen types",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 20.0)),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: _openKitchenTypesList, // handle your image tap here
          child: Icon(
            Icons.restaurant,
            size: 50,
            color: Colors.red,
          ),
        )
      ],
    ));
  }

  Widget _buildContent(BuildContext context, LatLng location) {
    return FocusScope(
      node: _node,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 8.0),
          _buildPopNameField(),
          SizedBox(height: 8.0),
          _buildPopDescriptionField(),
          SizedBox(height: 8.0),
          _buildPopCouponField(),
          SizedBox(height: 8.0),
          _buildPopUrlField(),
          SizedBox(height: 8.0),
          _buildPopExpirationDatePicker(),
          SizedBox(height: 16.0),
          _buildPriceRangeSlider(),
          SizedBox(height: 16.0),
          SearchMapPlaceWidget(
              apiKey: API_KEY,
              location: location,
              radius: location != null ? 50 * 1000 : null,
              placeholder: isEditingPop == true && widget.popToEdit != null
                  ? widget.popToEdit.address
                  : Texts.addressSearchPlaceHolder,
              onSelected: (place) async {

                final geolocation = await place.geolocation;
                model.updatePopLocation(geolocation.coordinates);
                model.updatePopAddress(place.description);
              }),
          SizedBox(height: 16.0),
          _buildKitchenTypesField(),
          SizedBox(height: 16.0),
          Text(
              model.popPhotoPath == Texts.emptyPath
                  ? Texts.choosePopPhoto
                  : Texts.selectedPopPhoto,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20.0)),
          SizedBox(height: 8.0),
          ClickableImageUpload(
              height: model.popPhotoPath == Texts.emptyPath ? 70 : 200,
              loading: _isUploadingPopPhoto,
              onPressed: () {
                _uploadPopPhoto(context);
              },
              photoPath: model.popPhotoPath),
          SizedBox(height: 16.0),
          Text(
              model.popInnerPhotoPath == Texts.emptyPath
                  ? Texts.choosePopInnerPhoto
                  : Texts.selectedPopInnerPhoto,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20.0)),
          SizedBox(height: 8.0),
          ClickableImageUpload(
              height: model.popInnerPhotoPath == Texts.emptyPath ? 70 : 200,
              loading: _isUploadingPopInnerPhoto,
              onPressed: () {
                _uploadPopInnerPhoto(context);
              },
              photoPath: model.popInnerPhotoPath),
          SizedBox(height: 16.0),
          FormSubmitButton(
            key: Key(Keys.businessFormSubmit),
            text: Texts.submit,
            loading: model.isLoading,
            onPressed: model.isLoading ? null : () => _submit(context),
          ),
        ],
      ),
    );
  }


  void _showPopPhotoUploadError(
      AddPopModel model, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: Texts.popImageUploadError,
      exception: exception,
    ).show(context);
  }

  void _showPopPhotoUploadException(Exception exception) async {
        await PlatformAlertDialog(
          title: Texts.popImageUploadError,
          content: exception.toString(),
          defaultActionText: Texts.ok,
        ).show(context);
  }
}
