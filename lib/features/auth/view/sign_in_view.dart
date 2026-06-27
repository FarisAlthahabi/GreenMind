import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/auth/cubit/auth_cubit.dart';
import 'package:green_mind/global/router/app_router.gr.dart';
import 'package:green_mind/global/utils/app_colors.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/utils/utils.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

abstract class SignInViewCallBacks {
  void onShowPassword();
  void onForgetPasswordTap();
  void onSignInTap();
  void onGoToSignUp();
}

@RoutePage()
class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInPage();
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    implements SignInViewCallBacks {
  late final AuthCubit authCubit = context.read();

  final _formKey = GlobalKey<FormState>();

  bool isObsecurePassword = true;

  @override
  void onShowPassword() =>
      setState(() => isObsecurePassword = !isObsecurePassword);

  @override
  void onForgetPasswordTap() {
    //context.router.push(const ForgetPasswordRoute());
  }

  @override
  void onGoToSignUp() {
    context.router.replace(const SignUpRoute());
  }

  @override
  void onSignInTap() {
    if (_formKey.currentState!.validate()) {
      authCubit.signIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildImage(),
              _buildTitle(),
              const SizedBox(height: 40),
              _buildEmailTextField(),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildPasswordTextField(),
                  _buildForgetPasswordButton(),
                ],
              ),
              const SizedBox(height: 20),
              _buildMainActionButton(),
              const SizedBox(height: 20),
              _buildOrText(),
              // const SizedBox(height: 20),
              // _buildAnotherLoginTypes(),
              const SizedBox(height: 20),
              _buildGoSignUp(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
    // return MainAuthTile(
    //   child: Form(
    //     key: _formKey,
    //     child: Column(
    //       spacing: 5,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         const SizedBox(height: 20),
    //         _buildImage(),
    //         _buildTitle(),
    //         const SizedBox(height: 40),
    //         _buildEmailTextField(),
    //         const SizedBox(height: 5),
    //         _buildPasswordTextField(),
    //         const SizedBox(height: 20),
    //         _buildMainActionButton(),
    //         _buildForgetPasswordButton(),
    //         const SizedBox(height: 20),
    //         //_buildGoSignUp(),
    //         const SizedBox(height: 60),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildImage() {
    return Image.asset(AppConstants.appLogo, width: 150, height: 150);
  }

  Widget _buildTitle() {
    return Text(
      "sign_in".tr(),
      style: const TextStyle(
        fontSize: 24,
        color: AppColors.blackShade2,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEmailTextField() {
    return MainTextField(
      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.black),
      hintText: "email".tr(),
      onChanged: authCubit.setEmail,
      textInputType: TextInputType.emailAddress,
      validator: (val) => Utils.validateInput(val, InputTextType.none),
    );
  }

  Widget _buildPasswordTextField() {
    return MainTextField(
      obscureText: isObsecurePassword,
      hintText: "password".tr(),
      onChanged: authCubit.setPassword,
      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.black),
      validator: (val) => Utils.validateInput(val, InputTextType.password),
      maxLines: 1,
      suffixIcon: IconButton(
        icon: Icon(
          isObsecurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.black,
        ),
        onPressed: onShowPassword,
      ),
    );
  }

  Widget _buildMainActionButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is SignInState,
      listener: (context, state) {
        if (state is SignInSuccess) {
          MainSnackBar.showSuccessMessage(context, state.message);
        } else if (state is SignInFail) {
          // if (state.error == "يجب عليك تأكيد حسابك") {
          //   context.router.push(
          //     VerifyRoute(isForget: false, email: authCubit.emailView ?? ""),
          //   );
          // }
          MainSnackBar.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        // return MainActionButton(
        //   onPressed: onSignInTap,
        //   text: "sign_in".tr(),
        //   isLoading: state is SignInLoading,
        // );
        return Padding(
          padding: AppConstants.paddingH40,
          child: MainActionButton(
            padding: AppConstants.padding18,
            onPressed: onSignInTap,
            text: "sign_in".tr(),
            isLoading: state is SignInLoading,
          ),
        );
      },
    );
  }

  Widget _buildForgetPasswordButton() {
    return TextButton(
      onPressed: onForgetPasswordTap,
      child: Text(
        "نسيت كلمة المرور؟",
        style: TextStyle(color: AppColors.mainColor, fontSize: 14),
      ),
    );
  }

  Widget _buildOrText() {
    return Text(
      "or".tr(),
      style: const TextStyle(
        color: Color(0xFF1E1E1E),
        fontSize: 14,
        fontFamily: "Alkatra",
      ),
    );
  }

  // Widget _buildAnotherLoginTypes() {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     spacing: 20,
  //     children: LoginAnotherWayEnum.values.map((way) {
  //       return SvgPicture.asset(way.icon);
  //     }).toList(),
  //   );
  // }

  Widget _buildGoSignUp() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("not_have_account".tr()),
          GestureDetector(
            onTap: onGoToSignUp,
            child: Text(
              "sign_up".tr(),
              style: TextStyle(color: AppColors.mainColor),
            ),
          ),
        ],
      ),
    );
  }
}
