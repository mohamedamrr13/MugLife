import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/auth/logic/google_cubit/google_cubit.dart';
import 'package:drinks_app/features/auth/logic/register_cubit/register_cubit.dart';
import 'package:drinks_app/features/auth/presentation/widgets/custom_auth_appbar.dart';
import 'package:drinks_app/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:drinks_app/utils/theming/app_colors.dart';
import 'package:drinks_app/utils/helper/helper_functions.dart';
import 'package:drinks_app/utils/validation/text_validation.dart';
import 'package:drinks_app/utils/shared/custom_button.dart';
import 'package:drinks_app/utils/shared/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isEnabled = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
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
                  const SizedBox(height: 50),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    child: Form(
                      key: _formKey,
                      child: BlocConsumer<RegisterCubit, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterLoading) {
                            setState(() => isEnabled = false);
                          }
                          if (state is RegisterSuccess) {
                            context.push(AppRouter.homeScreen);
                          }
                          if (state is RegisterFailure) {
                            setState(() => isEnabled = true);
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 20),

                              CustomTextFormField(
                                enabled: isEnabled,
                                controller: _nameController,
                                hintText: 'Name',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                enabled: isEnabled,
                                controller: _emailController,
                                hintText: 'Email',
                                errorText:
                                    (state is RegisterFailure &&
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: isEnabled,
                                controller: _passwordController,
                                hintText: 'Password',
                                obscureText: true,
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
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: isEnabled,
                                controller: _confirmPasswordController,
                                hintText: 'Confirm Password',
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  } else if (value !=
                                      _passwordController.text) {
                                    return 'Password does not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              CustomElevatedButton(
                                onPressed:
                                    isEnabled
                                        ? () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            BlocProvider.of<RegisterCubit>(
                                              context,
                                            ).signIn(
                                              _emailController.text,
                                              _passwordController.text,
                                            );
                                          }
                                        }
                                        : null,
                                text: 'Sign Up',
                                isLoading: state is RegisterLoading,
                              ),
                              const SizedBox(height: 16),
                              BlocConsumer<GoogleCubit, GoogleState>(
                                listener: (context, state) {
                                  if (state is GoogleLoading) {
                                    setState(() => isEnabled = false);
                                  }
                                  if (state is GoogleSuccess) {
                                    setState(() => isEnabled = true);
                                    context.push(AppRouter.homeScreen);
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
                                    text: 'Sign Up with Google',
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
                                    ).go(AppRouter.loginScreen);
                                  },
                                  child: const Text(
                                    'Already have an account? Sign In!',
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 15,
                                    ),
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
