// import 'package:auto_route/auto_route.dart';
// import 'package:easy_localization/easy_localization.dart' as t;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:green_mind/features/auth/cubit/auth_cubit.dart';
// import 'package:green_mind/global/router/app_router.gr.dart';
// import 'package:green_mind/global/utils/app_colors.dart';
// import 'package:green_mind/global/utils/constants.dart';
// import 'package:green_mind/global/utils/utils.dart';
// import 'package:green_mind/global/widgets/main_action_button.dart';
// import 'package:green_mind/global/widgets/main_snack_bar.dart';
// import 'package:green_mind/global/widgets/main_text_field.dart';

// abstract class ForgetPasswordViewCallBacks {
//   void onGoToSignUp();
//   void onForgetPasswordTap();
// }

// @RoutePage()
// class ForgetPasswordView extends StatelessWidget {
//   const ForgetPasswordView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const ForgetPasswordPage();
//   }
// }

// class ForgetPasswordPage extends StatefulWidget {
//   const ForgetPasswordPage({super.key});

//   @override
//   State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
// }

// class _ForgetPasswordPageState extends State<ForgetPasswordPage>
//     implements ForgetPasswordViewCallBacks {
//   late final AuthCubit authCubit = context.read();

//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();

//   @override
//   void onForgetPasswordTap() {
//     if (_formKey.currentState!.validate()) {
//       authCubit.sendCode(isForget: true, email: emailController.text);
//     }
//   }

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
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: AppConstants.padding30,
//         child: Form(
//           key: _formKey,
//           child: Column(
//             spacing: 5,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 40),
//               _buildImage(),
//               _buildTitle(),
//               const SizedBox(height: 40),
//               _buildEmailTextField(),
//               const SizedBox(height: 5),
//               const SizedBox(height: 20),
//               _buildMainActionButton(),
//               const SizedBox(height: 20),
//               _buildGoSignUp(),
//               const SizedBox(height: 60),
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
//     //         _buildBackButton(),
//     //         const SizedBox(height: 100),
//     //         _buildTitle(),
//     //         const SizedBox(height: 50),
//     //         _buildEmailTextField(),
//     //         const SizedBox(height: 20),
//     //         _buildMainActionButton(),
//     //         const SizedBox(height: 150),
//     //         //_buildGoSignUp(),
//     //         const SizedBox(height: 50),
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }

//   Widget _buildImage() {
//     return Image.asset(AppConstants.appLogo, width: 150, height: 150);
//   }

//   // Widget _buildBackButton() {
//   //   return Row(
//   //     children: [
//   //       IconButton(
//   //         onPressed: () => context.router.pop(context),
//   //         icon: const Icon(
//   //           Icons.arrow_back_outlined,
//   //           size: 30,
//   //           color: AppColors.blackShade,
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   Widget _buildTitle() {
//     return Text(
//       // "forget_password".tr(),
//       "reset_password".tr(),
//       style: const TextStyle(
//         fontSize: 24,
//         color: AppColors.blackShade2,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }

//   Widget _buildEmailTextField() {
//     return MainTextField(
//       controller: emailController,
//       prefixIcon: const Icon(Icons.email_outlined, color: AppColors.black),
//       hintText: "email".tr(),
//       onChanged: authCubit.setEmail,
//       textInputType: TextInputType.emailAddress,
//       validator: (val) => Utils.validateInput(val, InputTextType.email),
//     );
//   }

//   Widget _buildMainActionButton() {
//     return BlocConsumer<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state is ResendCodeSuccess) {
//           context.router.push(
//             VerifyRoute(isForget: true, email: authCubit.emailView ?? ""),
//           );
//           MainSnackBar.showSuccessMessage(context, state.message);
//         } else if (state is SignInFail) {
//           MainSnackBar.showErrorMessage(context, state.error);
//         }
//       },
//       builder: (context, state) {
//         // return MainActionButton(
//         //   onPressed: onForgetPasswordTap,
//         //   text: "send_code".tr(),
//         //   isLoading: state is SignInLoading,
//         // );
//         return Padding(
//           padding: AppConstants.paddingH40,
//           child: MainActionButton(
//             padding: AppConstants.padding18,
//             onPressed: onForgetPasswordTap,
//             text: "send_code".tr(),
//             isLoading: state is SignInLoading,
//           ),
//         );
//       },
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
//             style: TextStyle(color: context.cs.primary),
//           ),
//         ),
//       ],
//     );
//   }
// }
