import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodiepops/constants/Texts.dart';
import 'package:foodiepops/exceptions/platformExceptionAlertDialog.dart';
import 'package:foodiepops/screens/login/credentialsLogin/credentialsLoginModel.dart';
import 'package:foodiepops/services/firebaseAuthService.dart';
import 'package:foodiepops/widgets/formSubmitButton.dart';
import 'package:foodiepops/widgets/platformAlertDialog.dart';
import 'package:provider/provider.dart';

class CredentialsSignInFormBuilder extends StatelessWidget {
  const CredentialsSignInFormBuilder({Key key, @required this.isBusinessUser, this.onSignedIn})
      : super(key: key);
  final VoidCallback onSignedIn;
  final bool isBusinessUser;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return ChangeNotifierProvider<CredentialsLoginModel>(
      create: (_) => CredentialsLoginModel(auth: auth, isBusinessUser: isBusinessUser),
      child: Consumer<CredentialsLoginModel>(
        builder: (_, CredentialsLoginModel model, __) =>
            CredentialsSignInForm(model: model, onSignedIn: onSignedIn),
      ),
    );
  }
}

class CredentialsSignInForm extends StatefulWidget {
  const CredentialsSignInForm(
      {Key key, @required this.model, this.onSignedIn})
      : super(key: key);
  final CredentialsLoginModel model;
  final VoidCallback onSignedIn;

  @override
  _CredentialsSignInFormState createState() =>
      _CredentialsSignInFormState();
}

class _CredentialsSignInFormState extends State<CredentialsSignInForm> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  CredentialsLoginModel get model => widget.model;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(
      CredentialsLoginModel model, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: model.errorAlertTitle,
      exception: exception,
    ).show(context);
  }

  Future<void> _submit() async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == CredentialsFormType.forgotPassword) {
          await PlatformAlertDialog(
            title: Texts.resetLinkSentTitle,
            content: Texts.resetLinkSentMessage,
            defaultActionText: Texts.ok,
          ).show(context);
        } else {
          if (widget.onSignedIn != null) {
            widget.onSignedIn();
          }
        }
      }
    } on PlatformException catch (e) {
      _showSignInError(model, e);
    }
  }

  void _emailEditingComplete() {
    if (model.canSubmitEmail) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!model.canSubmitEmail) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType(CredentialsFormType formType) {
    model.updateFormType(formType);
    _emailController.clear();
    _passwordController.clear();
  }

  Widget _buildEmailField() {
    return TextField(
      key: Key('email'),
      controller: _emailController,
      decoration: InputDecoration(
        labelText: Texts.emailLabel,
        hintText: Texts.emailHint,
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onChanged: model.updateEmail,
      onEditingComplete: _emailEditingComplete,
      inputFormatters: <TextInputFormatter>[
        model.emailInputFormatter,
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      key: Key('password'),
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: model.passwordLabelText,
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onChanged: model.updatePassword,
      onEditingComplete: _passwordEditingComplete,
    );
  }

  Widget _buildContent() {
    return FocusScope(
      node: _node,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 8.0),
          _buildEmailField(),
          if (model.formType !=
              CredentialsFormType.forgotPassword) ...<Widget>[
            SizedBox(height: 8.0),
            _buildPasswordField(),
          ],
          SizedBox(height: 8.0),
          FormSubmitButton(
            key: Key('primary-button'),
            text: model.primaryButtonText,
            loading: model.isLoading,
            onPressed: model.isLoading ? null : _submit,
          ),
          SizedBox(height: 8.0),
          FlatButton(
            key: Key('secondary-button'),
            child: Text(model.secondaryButtonText),
            onPressed: model.isLoading
                ? null
                : () => _updateFormType(model.secondaryActionFormType),
          ),
          if (model.formType == CredentialsFormType.signIn)
            FlatButton(
              key: Key('tertiary-button'),
              child: Text(Texts.forgotPasswordQuestion),
              onPressed: model.isLoading
                  ? null
                  : () => _updateFormType(
                      CredentialsFormType.forgotPassword),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
}
