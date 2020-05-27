import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/constants/api_key.dart';
import 'package:foodiepops/exceptions/platformExceptionAlertDialog.dart';
import 'package:foodiepops/models/pop.dart';
import 'package:foodiepops/screens/businessUser/addPopForm/addPopModel.dart';
import 'package:foodiepops/services/fireStoreDatabase.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/widgets/dateTimePicker.dart';
import 'package:foodiepops/widgets/formSubmitButton.dart';
import 'package:foodiepops/widgets/formWidgets.dart';
import 'package:foodiepops/widgets/platformAlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place/search_map_place.dart';

class AddPopFormBuilder extends StatelessWidget {
  const AddPopFormBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase database =
    Provider.of<FirestoreDatabase>(context, listen: false);
    final businessUser = Provider.of<User>(context, listen: false); 

    return ChangeNotifierProvider<AddPopModel>(
      create: (_) => AddPopModel(database: database, businessUser: businessUser),
      child: Consumer<AddPopModel>(
        builder: (_, AddPopModel model, __) =>
            AddPopForm(model: model),
      ),
    );
  }
}

class AddPopForm extends StatefulWidget {
  const AddPopForm({Key key, @required this.model}) : super(key: key);
  final AddPopModel model;

  @override
  _AddPopFormState createState() => _AddPopFormState();
}

class _AddPopFormState extends State<AddPopForm> {
  final FocusScopeNode _node = FocusScopeNode();

  final TextEditingController _popNameController = TextEditingController();
  final TextEditingController _popDescriptionController = TextEditingController();

  DateTime _popExpirationDate;
  TimeOfDay _popExpirationTime;


  @override
  void initState() {
    super.initState();
    _popExpirationDate = DateTime.now();
    _popExpirationTime = TimeOfDay.now();
  }

  AddPopModel get model => widget.model;

  @override
  void dispose() {
    _node.dispose();
    _popNameController.dispose();
    _popDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Future<void> _submit() async {
    model.updatePopExpirationTime(_getPopExpirationTimeFromState());

    try {
      final bool success = await model.submit();
      if (success) {
          await PlatformAlertDialog(
            title: Texts.popSubmitSuccessTitle,
            content: Texts.popSubmitSuccessMessage,
            defaultActionText: Texts.ok,
          ).show(context);

          _clearForm();
      }
    } on PlatformException catch (e) {
      _showSubmitError(model, e);
    }
  }

  DateTime _getPopExpirationTimeFromState () {
    return DateTime(_popExpirationDate.year, _popExpirationDate.month,
     _popExpirationDate.day, _popExpirationTime.hour, _popExpirationTime.minute); 
  }

  void _clearForm() {
    model.clearData();
    _popNameController.clear();
    _popDescriptionController.clear();
  }

  void _isFieldEditingComplete(bool canSubmitField) {
    if(canSubmitField) {
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
        onEditingComplete: () => _isFieldEditingComplete(model.canSubmitPopDescription),
        maxLines: Pop.MAX_DESCRIPTION_LINES,
      ));
  }

  Widget _buildContent() {
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
          _buildPopExpirationDatePicker(),
          SizedBox(height: 16.0),
          SearchMapPlaceWidget(
        apiKey: API_KEY
      ),
          SizedBox(height: 16.0),
          FormSubmitButton(
            key: Key('primary-button'),
            text: Texts.submit,
            loading: model.isLoading,
            onPressed: model.isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }

  void _showSubmitError(
      AddPopModel model, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: Texts.unknownError,
      exception: exception,
    ).show(context);
  }
}
