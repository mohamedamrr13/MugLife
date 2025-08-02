import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/auth/logic/google_cubit/google_cubit.dart';
import 'package:drinks_app/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:drinks_app/utils/validation/text_validation.dart';
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
  final _searchController = TextEditingController();
  bool isEnabled = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 80),

            Text(
              "M u g L i f e",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 56),
                  Container(
                    constraints: BoxConstraints(maxWidth: double.infinity),
                    child: Form(
                      key: _formKey,
                      child: BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginLoading) {
                            isEnabled = false;
                          }
                          if (state is LoginSuccess) {
                            context.push(AppRouter.homeScreen);
                          }
                          if (state is LoginFailure) {
                            isEnabled = true;
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Log In to Order',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Enter your details below',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 14),
                              TextFormField(
                                enabled: isEnabled,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  errorText:
                                      (state is LoginFailure &&
                                              (state).errMessage.isNotEmpty)
                                          ? (state)
                                              .errMessage // ✅
                                          : null,
                                  hintText: 'Email',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.mainColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.grey.withAlpha(50),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.grey.withAlpha(50),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: AppColors.errorColor.withAlpha(
                                        200,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.grey.withAlpha(50),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Your Email";
                                  } else {
                                    TextValidation.emailValidator(value);
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enabled: isEnabled,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.mainColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.grey.withAlpha(50),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.grey.withAlpha(50),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: AppColors.errorColor.withAlpha(
                                        200,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.grey.withAlpha(50),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Your Password";
                                  } else {
                                    TextValidation.passwordValidator(value);
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<LoginCubit>(
                                        context,
                                      ).login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.mainColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child:
                                      state is LoginLoading
                                          ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              color: AppColors.mainColor,
                                            ),
                                          )
                                          : Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                ),
                              ),
                              SizedBox(height: 16),
                              BlocConsumer<GoogleCubit, GoogleState>(
                                listener: (context, state) {
                                  if (state is GoogleLoading) {
                                    isEnabled = false;
                                  }
                                  if (state is GoogleSuccess) {
                                    isEnabled = true;
                                    context.push(AppRouter.homeScreen);
                                  }
                                  if (state is GoogleFailure) {
                                    isEnabled = true;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.errMessage),
                                        backgroundColor: Colors.black,
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: OutlinedButton.icon(
                                      onPressed: () async {
                                        await BlocProvider.of<GoogleCubit>(
                                          context,
                                        ).signUpWithGoogle();
                                      },
                                      icon: Image.asset(
                                        'assets/icons/IconGoogle.png',
                                        height: 20,
                                      ),
                                      label:
                                          state is GoogleLoading
                                              ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 3,
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                              )
                                              : Text(
                                                'Login with Google',
                                                style: TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          width: 2,
                                          color: Colors.grey[300]!,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password ?',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    GoRouter.of(
                                      context,
                                    ).go(AppRouter.signUpScreen);
                                  },
                                  child: Text(
                                    'Don\'t Have An Account? Sign Up!',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
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
