// import 'package:auto_route/auto_route.dart';
// import 'package:easy_localization/easy_localization.dart' as t;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:green_mind/features/auth/cubit/auth_cubit.dart';
// import 'package:green_mind/global/router/app_router.gr.dart';
// import 'package:green_mind/global/theme/theme_x.dart';
// //import 'package:green_mind/global/theme/theme_x.dart';
// import 'package:green_mind/global/utils/app_colors.dart';
// import 'package:green_mind/global/utils/constants.dart';
// import 'package:green_mind/global/utils/utils.dart';
// import 'package:green_mind/global/widgets/main_action_button.dart';
// import 'package:green_mind/global/widgets/main_snack_bar.dart';
// import 'package:green_mind/global/widgets/main_text_field.dart';

// abstract class ResetPasswordViewCallBacks {
//   void onGoToSignUp();
//   void onShowPassword();
//   void onResetPasswordTap();
// }

// @RoutePage()
// class ResetPasswordView extends StatelessWidget {
//   const ResetPasswordView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const ResetPasswordPage();
//   }
// }

// class ResetPasswordPage extends StatefulWidget {
//   const ResetPasswordPage({super.key});

//   @override
//   State<ResetPasswordPage> createState() => _ResetPasswordPageState();
// }

// class _ResetPasswordPageState extends State<ResetPasswordPage>
//     implements ResetPasswordViewCallBacks {
//   late final AuthCubit authCubit = context.read();

//   final _formKey = GlobalKey<FormState>();

//   bool isObsecurePassword = true;

//   @override
//   void onResetPasswordTap() {
//     if (_formKey.currentState!.validate()) {
//       authCubit.resetPassword();
//     }
//   }

//   @override
//   void onShowPassword() =>
//       setState(() => isObsecurePassword = !isObsecurePassword);

//   @override
//   void onGoToSignUp() {
//     context.router.pushAndPopUntil(
//       const SignUpRoute(),
//       predicate: (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: AppConstants.padding20,
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             spacing: 5,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 60),
//               _buildImage(),
//               const SizedBox(height: 20),
//               _buildTitle(),
//               const SizedBox(height: 50),
//               _buildPasswordTextField(),
//               const SizedBox(height: 5),
//               _buildConfirmPasswordTextField(),
//               const SizedBox(height: 25),
//               _buildMainActionButton(),
//               const SizedBox(height: 80),
//               _buildGoSignUp(),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//     // return MainAuthTile(
//     //   child: Form(
//     //     key: _formKey,
//     //     child: Column(
//     //       spacing: 5,
//     //       crossAxisAlignment: CrossAxisAlignment.center,
//     //       children: [
//     //         const SizedBox(height: 150),
//     //         _buildTitle(),
//     //         const SizedBox(height: 50),
//     //         _buildPasswordTextField(),
//     //         const SizedBox(height: 5),
//     //         _buildConfirmPasswordTextField(),
//     //         const SizedBox(height: 25),
//     //         _buildMainActionButton(),
//     //         const SizedBox(height: 80),
//     //         const SizedBox(height: 40),
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }

//   Widget _buildImage() {
//     return Image.asset(AppConstants.appLogo, width: 150, height: 150);
//   }

//   Widget _buildTitle() {
//     return Text(
//       "reset_password".tr(),
//       style: const TextStyle(fontSize: 24, color: AppColors.black),
//     );
//   }

//   Widget _buildPasswordTextField() {
//     return MainTextField(
//       obscureText: isObsecurePassword,
//       hintText: "password".tr(),
//       onChanged: authCubit.setPasswordReset,
//       prefixIcon: const Icon(Icons.lock_outline, color: AppColors.black),
//       validator: (val) => Utils.validateInput(val, InputTextType.password),
//       maxLines: 1,
//       suffixIcon: IconButton(
//         icon: Icon(
//           isObsecurePassword
//               ? Icons.visibility_outlined
//               : Icons.visibility_off_outlined,
//           color: AppColors.black,
//         ),
//         onPressed: onShowPassword,
//       ),
//     );
//   }

//   Widget _buildConfirmPasswordTextField() {
//     return MainTextField(
//       obscureText: isObsecurePassword,
//       hintText: "confirm_password".tr(),
//       onChanged: authCubit.setConfirmPasswordReset,
//       prefixIcon: const Icon(Icons.lock_outline, color: AppColors.black),
//       validator: (val) => Utils.validateInput(val, InputTextType.password),
//       maxLines: 1,
//       suffixIcon: IconButton(
//         icon: Icon(
//           isObsecurePassword
//               ? Icons.visibility_outlined
//               : Icons.visibility_off_outlined,
//           color: AppColors.black,
//         ),
//         onPressed: onShowPassword,
//       ),
//     );
//   }

//   Widget _buildMainActionButton() {
//     return Padding(
//       padding: AppConstants.paddingH20,
//       child: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state is ResetPasswordSuccess) {
//             context.router.pushAndPopUntil(
//               const SignInRoute(),
//               predicate: (route) => false,
//             );
//             MainSnackBar.showSuccessMessage(context, state.message);
//           } else if (state is SignInFail) {
//             MainSnackBar.showErrorMessage(context, state.error);
//           }
//         },
//         builder: (context, state) {
//           return MainActionButton(
//             onPressed: onResetPasswordTap,
//             text: "reset".tr(),
//             isLoading: state is SignInLoading,
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildGoSignUp() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text("not_have_account".tr()),
//         GestureDetector(
//           onTap: onGoToSignUp,
//           child: Text(
//             "sign_up".tr(),
//             style: TextStyle(
//               color: context.cs.primary,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
