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

  bool hasTracker = false;
  bool isHasTrackerChanged = false;

  @override
  void initState() {
    super.initState();
  }

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
              _buildNameTextField(),
              const SizedBox(height: 5),
              _buildEmailTextField(),
              const SizedBox(height: 5),
              _buildPasswordTextField(),
              const SizedBox(height: 20),
              _buildMainActionButton(),
              const SizedBox(height: 20),
              _buildOrText(),
              // const SizedBox(height: 20),
              // _buildAnotherLoginTypes(),
              const SizedBox(height: 20),
              _buildGoSignIn(),
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
    //         _buildHeader(),
    //         const SizedBox(height: 20),
    //         _buildNameTextField(),
    //         const SizedBox(height: 5),
    //         _buildEmailTextField(),
    //         const SizedBox(height: 5),
    //         _buildPasswordTextField(),
    //         const SizedBox(height: 25),
    //         _buildMainActionButton(),
    //         _buildDivider(),
    //         _buildOrWithGoogleText(),
    //         const SizedBox(height: 10),
    //         _buildSignInWithGoogleButton(),
    //         const SizedBox(height: 40),
    //       ],
    //     ),
    //   ),
    // );
  }

  // Widget _buildHeader() {
  //   return Row(
  //     children: [
  //       IconButton(
  //         onPressed: () => context.router.pop(context),
  //         icon: const Icon(
  //           Icons.arrow_back_outlined,
  //           size: 30,
  //           color: AppColors.blackShade,
  //         ),
  //       ),
  //       const Spacer(),
  //       _buildTitle(),
  //       const Spacer(),
  //       const SizedBox(width: 40),
  //     ],
  //   );
  // }

  Widget _buildTitle() {
    return Text(
      "sign_up".tr(),
      style: const TextStyle(
        fontSize: 24,
        color: AppColors.blackShade2,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(AppConstants.appLogo, width: 150, height: 150);
  }

  Widget _buildNameTextField() {
    return MainTextField(
      prefixIcon: const Icon(Icons.person_outline, color: AppColors.black),
      hintText: "username".tr(),
      onChanged: authCubit.setName,
      validator: (val) => Utils.validateInput(val, InputTextType.none),
    );
  }

  Widget _buildEmailTextField() {
    return MainTextField(
      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.black),
      hintText: "email".tr(),
      onChanged: authCubit.setEmailSignUp,
      textInputType: TextInputType.emailAddress,
      validator: (val) => Utils.validateInput(val, InputTextType.email),
    );
  }

  Widget _buildPasswordTextField() {
    return MainTextField(
      obscureText: isObsecurePassword,
      hintText: "password".tr(),
      onChanged: authCubit.setPasswordSignUp,
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
        // return MainActionButton(
        //   onPressed: onSignUpTap,
        //   text: "sign_up".tr(),
        //   isLoading: state is SignInLoading,
        // );
      },
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

  Widget _buildGoSignIn() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "already_have_account".tr(),
            style: const TextStyle(color: AppColors.black),
          ),
          GestureDetector(
            onTap: onGoToSignIn,
            child: Text(
              "sign_in".tr(),
              style: TextStyle(color: AppColors.mainColor),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildDivider() => const Divider(height: 80, color: AppColors.black);

  // Widget _buildOrWithGoogleText() {
  //   return Text(
  //     "or_with_google".tr(),
  //     style: const TextStyle(color: AppColors.black, fontSize: 20),
  //     textAlign: TextAlign.center,
  //   );
  // }

  // Widget _buildSignInWithGoogleButton() {
  //   return Padding(
  //     padding: AppConstants.paddingH20,
  //     child: MainActionButton(onPressed: () {}, text: "GOOGLE".tr()),
  //   );
  // }
}
