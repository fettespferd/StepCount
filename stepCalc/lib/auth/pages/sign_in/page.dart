import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stepCalc/app/module.dart';

import '../../widgets/black_button.dart';
import 'cubit.dart';
import 'utils.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with StateWithCubit<SignInCubit, SignInState, SignInPage> {
  @override
  SignInCubit cubit = SignInCubit();
  bool _triedSubmitting = false;
  bool _isSigningIn = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void onCubitData(SignInState state) {
    state.maybeWhen(
      isSigningIn: () => _isSigningIn = true,
      error: (error) {
        String message;
        switch (error) {
          case SignInError.offline:
            message = context.s.auth_error_offline;
            break;
          case SignInError.credentialsInvalid:
            message = context.s.auth_error_credentialsInvalid;
            break;
          case SignInError.emailNotVerified:
            message = context.s.auth_error_emailNotVerified;
            break;
          case SignInError.userDisabled:
            message = context.s.auth_error_userDisabled;
            break;
        }
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(message)));
        _isSigningIn = false;
      },
      success: () {
        context.navigator.pushReplacementNamed(appSchemeUrl('main'));
        // We intentionally don't clear [_isSigningIn] to avoid as we're already
        // navigating away from this page.
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Spacer(flex: 2),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'stepCalc',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                )),
            Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: _buildEmailForm(),
            ),
            Spacer(flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () =>
                      context.rootNavigator.pushNamed('/passwordReset'),
                  child: Text(context.s.auth_signIn_forgotPassword),
                ),
                TextButton(
                  onPressed: () => context.rootNavigator.pushNamed('/signUp'),
                  child: Text(context.s.auth_signIn_newAccount),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    Widget buttonChild = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(context.s.auth_signIn_login),
        Icon(OMIcons.arrowForward),
      ],
    );
    // When a loading indicator is shown, we must explicitly expand the row to
    // fill the full width of the button. When there's no loading indicator, the
    // [Expanded] is used without a [Row] as it's parent, which would be
    // invalid.
    if (_isSigningIn) buttonChild = Expanded(child: buttonChild);

    return Form(
      key: _formKey,
      onChanged: () {
        // We only apply live validation after the first try to sign in.
        if (!_triedSubmitting) return;

        _formKey.currentState.validate();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SignInTextField(
            controller: _emailController,
            label: context.s.auth_signIn_email,
            icon: Icon(Icons.alternate_email),
            isEnabled: !_isSigningIn,
            focusNode: _emailFocusNode,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp('\\s'))],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (_) => _emailFocusNode.nextFocus(),
            validators: [
              FormValidator.notBlank(context.s.auth_error_emailMissing),
              FormValidator.email(context.s.auth_error_emailInvalid),
            ],
          ),
          SizedBox(height: 24),
          PasswordInputWrapper(builder: (isVisible, toggleVisibility) {
            return SignInTextField(
              controller: _passwordController,
              label: context.s.auth_signIn_password,
              icon: IconButton(
                icon: Icon(isVisible ? OMIcons.lockOpen : OMIcons.lock),
                onPressed: toggleVisibility,
              ),
              isEnabled: !_isSigningIn,
              focusNode: _passwordFocusNode,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              onFieldSubmitted: (_) => _submitForm(),
              obscureText: !isVisible,
              validators: [
                FormValidator.notBlank(context.s.auth_error_passwordMissing),
              ],
            );
          }),
          SizedBox(height: 24),
          BlackButton(
            isLoading: _isSigningIn,
            onPressed: _submitForm,
            borderRadius: InputWrapper.defaultBorderRadius,
            child: buttonChild,
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    _triedSubmitting = true;
    if (!_formKey.currentState.validate()) return;

    cubit.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
  }
}
