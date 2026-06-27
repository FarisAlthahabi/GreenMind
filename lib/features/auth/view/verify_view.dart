// import 'package:auto_route/auto_route.dart';
// import 'package:easy_localization/easy_localization.dart' as t;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:green_mind/features/auth/cubit/auth_cubit.dart';
// import 'package:green_mind/global/router/app_router.gr.dart';
// import 'package:green_mind/global/theme/theme_x.dart';
// import 'package:green_mind/global/utils/app_colors.dart';
// import 'package:green_mind/global/utils/constants.dart';
// import 'package:green_mind/global/widgets/loading_indicator.dart';
// import 'package:green_mind/global/widgets/main_action_button.dart';
// import 'package:green_mind/global/widgets/main_snack_bar.dart';

// abstract class VerifyViewCallBacks {
//   void onGoToSignIn();
//   void onVerifyTap();
//   void onResendTap();
// }

// @RoutePage()
// class VerifyView extends StatelessWidget {
//   const VerifyView({super.key, required this.isForget, required this.email});
//   final bool isForget;
//   final String email;

//   @override
//   Widget build(BuildContext context) {
//     return VerifyPage(isForget: isForget, email: email);
//   }
// }

// class VerifyPage extends StatefulWidget {
//   const VerifyPage({super.key, required this.isForget, required this.email});
//   final bool isForget;
//   final String email;

//   @override
//   State<VerifyPage> createState() => _VerifyPageState();
// }

// class _VerifyPageState extends State<VerifyPage>
//     implements VerifyViewCallBacks {
//   late final AuthCubit authCubit = context.read();

//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
//   final _controllers = List.generate(6, (_) => TextEditingController());

//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     for (final controller in _controllers) {
//       controller.dispose();
//     }
//     for (final node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   void onResendTap() => authCubit.sendCode(email: widget.email);

//   @override
//   void onVerifyTap() {
//     if (_formKey.currentState!.validate()) {
//       String code = _controllers.map((c) => c.text).join();
//       authCubit.verify(code, isForget: widget.isForget);
//       // if (widget.isForget) {
//       //   authCubit.verifyForget(code);
//       // } else {
//       //   authCubit.verify(code);
//       // }
//     }
//   }

//   @override
//   void onGoToSignIn() {
//     final route = widget.isForget ? const SignUpRoute() : const SignInRoute();
//     context.router.pushAndPopUntil(route, predicate: (route) => false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: AppConstants.padding16,
//           child: Column(
//             spacing: 5,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 60),
//               _buildImage(),
//               const SizedBox(height: 20),
//               _buildTitle(),
//               const SizedBox(height: 20),
//               _buildSubtitle(),
//               const SizedBox(height: 40),
//               _buildOtpFields(),
//               const SizedBox(height: 40),
//               _buildMainActionButton(),
//               _buildResend(),
//               const SizedBox(height: 50),
//               _buildGoSignIn(),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//     // return MainAuthTile(
//     //   child: Column(
//     //     spacing: 5,
//     //     crossAxisAlignment: CrossAxisAlignment.center,
//     //     children: [
//     //       const SizedBox(height: 60),
//     //       _buildImage(),
//     //       const SizedBox(height: 20),
//     //       _buildTitle(),
//     //       const SizedBox(height: 20),
//     //       _buildSubtitle(),
//     //       const SizedBox(height: 40),
//     //       _buildOtpFields(),
//     //       const SizedBox(height: 40),
//     //       _buildMainActionButton(),
//     //       _buildResend(),
//     //       const SizedBox(height: 50),
//     //       //_buildGoSignIn(),
//     //       const SizedBox(height: 20),
//     //     ],
//     //   ),
//     // );
//   }

//   Widget _buildImage() {
//     return SvgPicture.asset(
//       "assets/images/auth_email.svg",
//       width: 70,
//       height: 70,
//     );
//   }

//   Widget _buildTitle() {
//     return Text(
//       "verify_email".tr(),
//       style: const TextStyle(fontSize: 24, color: AppColors.black),
//       textAlign: TextAlign.center,
//     );
//   }

//   Widget _buildSubtitle() {
//     return Text(
//       t.tr('verify_subtitle', args: [widget.email]),
//       textAlign: TextAlign.center,
//       style: const TextStyle(fontSize: 14, color: AppColors.black),
//     );
//   }

//   Widget _buildOtpFields() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Directionality(
//         textDirection: TextDirection.ltr,
//         child: Form(
//           key: _formKey,
//           child: Row(
//             spacing: 5,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(6, (index) {
//               return Container(
//                 width: 40,
//                 height: 40,
//                 margin: const EdgeInsets.symmetric(horizontal: 2),
//                 child: TextFormField(
//                   controller: _controllers[index],
//                   focusNode: _focusNodes[index],
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.center,
//                   textAlignVertical: TextAlignVertical.center,
//                   maxLength: 1,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   style: const TextStyle(fontSize: 18),
//                   decoration: InputDecoration(
//                     counterText: "",
//                     contentPadding: const EdgeInsets.all(0),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     fillColor: AppColors.whiteShade,
//                     filled: true,
//                   ),
//                   validator: (val) =>
//                       val == null || val.trim().isEmpty ? "" : null,
//                   onChanged: (value) {
//                     if (value.isNotEmpty && index < 5) {
//                       _focusNodes[index + 1].requestFocus();
//                     } else if (value.isEmpty && index > 0) {
//                       _focusNodes[index - 1].requestFocus();
//                     }
//                   },
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMainActionButton() {
//     return Padding(
//       padding: AppConstants.padding12,
//       child: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state is VerifySuccess) {
//             MainSnackBar.showSuccessMessage(context, state.message);
//             if (widget.isForget) {
//               context.router.push(const ResetPasswordRoute());
//             }
//           } else if (state is SignInFail) {
//             MainSnackBar.showErrorMessage(context, state.error);
//           }
//         },
//         builder: (context, state) {
//           return MainActionButton(
//             onPressed: onVerifyTap,
//             text: "verify".tr(),
//             isLoading: state is SignInLoading,
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildResend() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "didnt_receive_code".tr(),
//           style: const TextStyle(color: AppColors.black),
//         ),
//         BlocConsumer<AuthCubit, AuthState>(
//           listener: (context, state) {
//             if (state is ResendCodeSuccess) {
//               MainSnackBar.showSuccessMessage(context, state.message);
//             } else if (state is SignInFail) {
//               MainSnackBar.showErrorMessage(context, state.error);
//             }
//           },
//           builder: (context, state) {
//             final isLoading = state is SignInLoading;
//             Widget child = Text(
//               "resend".tr(),
//               style: TextStyle(color: context.cs.primary),
//             );
//             return GestureDetector(
//               onTap: isLoading ? () {} : onResendTap,
//               child: isLoading ? const LoadingIndicator() : child,
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildGoSignIn() {
//     final text1 = widget.isForget
//         ? "not_have_account".tr()
//         : "already_have_account".tr();
//     final text2 = widget.isForget ? "sign_up".tr() : "sign_in".tr();
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(text1, style: const TextStyle(color: AppColors.black)),
//           GestureDetector(
//             onTap: onGoToSignIn,
//             child: Text(text2, style: TextStyle(color: context.cs.primary)),
//           ),
//         ],
//       ),
//     );
//   }
// }
