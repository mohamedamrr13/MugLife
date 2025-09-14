import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/auth/logic/google_cubit/google_cubit.dart';
import 'package:drinks_app/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:drinks_app/features/auth/presentation/widgets/custom_auth_appbar.dart';
import 'package:drinks_app/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:drinks_app/utils/helper/helper_functions.dart';
import 'package:drinks_app/utils/validation/text_validation.dart';
import 'package:drinks_app/utils/shared/custom_button.dart';
import 'package:drinks_app/utils/shared/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isEnabled = true;
  //for disabling textfields

  bool obscureText = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBgColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const CustomAuthAppbar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 56),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    child: Form(
                      key: _formKey,
                      child: BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginLoading) {
                            setState(() => isEnabled = false);
                          }
                          if (state is LoginSuccess) {
                            context.go(AppRouter.pageNavBar);
                          }
                          if (state is LoginFailure) {
                            setState(() => isEnabled = true);
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Text(
                                'Log In to Order',
                                style: context.textTheme.headlineSmall
                                    ?.copyWith(
                                      color: context.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const SizedBox(height: 18),
                              CustomTextFormField(
                                enabled: isEnabled,
                                controller: _emailController,
                                hintText: 'Email',
                                errorText:
                                    (state is LoginFailure &&
                                            state.errMessage.isNotEmpty)
                                        ? state.errMessage
                                        : null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Your Email";
                                  } else {
                                    return TextValidation.emailValidator(value);
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  icon:
                                      obscureText
                                          ? Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: isEnabled,
                                controller: _passwordController,
                                hintText: 'Password',
                                obscureText: obscureText,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Your Password";
                                  } else {
                                    return TextValidation.passwordValidator(
                                      value,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 30),
                              CustomElevatedButton(
                                onPressed:
                                    isEnabled
                                        ? () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            BlocProvider.of<LoginCubit>(
                                              context,
                                            ).login(
                                              _emailController.text,
                                              _passwordController.text,
                                            );
                                          }
                                        }
                                        : null,
                                text: 'Login',
                                isLoading: state is LoginLoading,
                              ),
                              const SizedBox(height: 16),
                              BlocConsumer<GoogleCubit, GoogleState>(
                                listener: (context, state) {
                                  if (state is GoogleLoading) {
                                    setState(() => isEnabled = false);
                                  }
                                  if (state is GoogleSuccess) {
                                    setState(() => isEnabled = true);
                                  }
                                  if (state is GoogleFailure) {
                                    setState(() => isEnabled = true);
                                    HelperFunctions.showErrorSnackBar(
                                      state.errMessage,
                                      MessageType.error,
                                      context,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return GoogleSignButton(
                                    onPressed:
                                        isEnabled
                                            ? () async {
                                              await BlocProvider.of<
                                                GoogleCubit
                                              >(context).signUpWithGoogle();
                                            }
                                            : null,
                                    text: 'Login with Google',
                                    isLoading: state is GoogleLoading,
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    GoRouter.of(
                                      context,
                                    ).go(AppRouter.signUpScreen);
                                  },
                                  child: Text(
                                    'Don\'t Have An Account? Sign Up!',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(color: context.primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
