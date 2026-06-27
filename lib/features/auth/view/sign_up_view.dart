import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/auth/cubit/auth_cubit.dart';
import 'package:green_mind/global/gen/assets.gen.dart';
import 'package:green_mind/global/router/app_router.gr.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/utils/utils.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

abstract class SignUpViewCallBacks {
  void onShowPassword();
  void onGoToSignIn();
  void onSignUpTap();
}

@RoutePage()
class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignUpPage();
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    implements SignUpViewCallBacks {
  late final AuthCubit authCubit = context.read();
  final _formKey = GlobalKey<FormState>();

  bool isObsecurePassword = true;

  @override
  void onShowPassword() =>
      setState(() => isObsecurePassword = !isObsecurePassword);

  @override
  void onSignUpTap() {
    if (_formKey.currentState!.validate()) {
      authCubit.signUp();
    }
  }

  @override
  void onGoToSignIn() => context.router.replace(const SignInRoute());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: AppConstants.padding30,
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              _buildImage(context),
              _buildTitle(context),
              const SizedBox(height: 40),
              _buildNameTextField(context),
              const SizedBox(height: 5),
              _buildEmailTextField(context),
              const SizedBox(height: 5),
              _buildPasswordTextField(context),
              const SizedBox(height: 20),
              _buildMainActionButton(),
              const SizedBox(height: 20),
              _buildOrText(context),
              // const SizedBox(height: 20),
              // _buildAnotherLoginTypes(),
              const SizedBox(height: 20),
              _buildGoSignIn(context),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Assets.images.greenMindPng.image(
      width: 150,
      height: 150,
      color: context.cs.primary,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "sign_up".tr(),
      style: context.tt.headlineMedium?.copyWith(
        color: context.cs.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNameTextField(BuildContext context) {
    return MainTextField(
      prefixIcon: Icon(
        Icons.person_outline,
        color: context.cs.onSurfaceVariant,
      ),
      hintText: "username".tr(),
      onChanged: authCubit.setName,
      validator: (val) => Utils.validateInput(val, InputTextType.none),
    );
  }

  Widget _buildEmailTextField(BuildContext context) {
    return MainTextField(
      prefixIcon: Icon(
        Icons.email_outlined,
        color: context.cs.onSurfaceVariant,
      ),
      hintText: "email".tr(),
      onChanged: authCubit.setEmailSignUp,
      textInputType: TextInputType.emailAddress,
      validator: (val) => Utils.validateInput(val, InputTextType.email),
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return MainTextField(
      obscureText: isObsecurePassword,
      hintText: "password".tr(),
      onChanged: authCubit.setPasswordSignUp,
      prefixIcon: Icon(Icons.lock_outline, color: context.cs.onSurfaceVariant),
      validator: (val) => Utils.validateInput(val, InputTextType.password),
      maxLines: 1,
      suffixIcon: IconButton(
        icon: Icon(
          isObsecurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: context.cs.onSurfaceVariant,
        ),
        onPressed: onShowPassword,
      ),
    );
  }

  Widget _buildMainActionButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is SignInState,
      listener: (context, state) {
        if (state is SignUpSuccess) {
          MainSnackBar.showSuccessMessage(context, state.message);
          // context.router.replace(
          //   VerifyRoute(isForget: false, email: authCubit.emailView ?? ""),
          // );
        } else if (state is SignInFail) {
          MainSnackBar.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: AppConstants.paddingH40,
          child: MainActionButton(
            padding: AppConstants.padding18,
            onPressed: onSignUpTap,
            text: "sign_up".tr(),
            isLoading: state is SignInLoading,
          ),
        );
      },
    );
  }

  Widget _buildOrText(BuildContext context) {
    return Text(
      "or".tr(),
      style: context.tt.bodyMedium?.copyWith(
        color: context.cs.onSurfaceVariant,
        fontSize: 14,
        fontFamily: "Alkatra",
      ),
    );
  }

  Widget _buildGoSignIn(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "already_have_account".tr(),
            style: context.tt.bodyMedium?.copyWith(
              color: context.cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onGoToSignIn,
            child: Text(
              "sign_in".tr(),
              style: context.tt.bodyMedium?.copyWith(
                color: context.cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
