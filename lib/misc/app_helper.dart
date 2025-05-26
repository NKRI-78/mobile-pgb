// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mobile_pgb/misc/navigation.dart';
// import 'package:mobile_pgb/modules/app/bloc/app_bloc.dart';
// import 'package:mobile_pgb/modules/register_akun/model/extrack_ktp_model.dart';
// import 'package:mobile_pgb/router/builder.dart';

// void handleAppState(
//   BuildContext context,
//   VoidCallback action, {
//   String? email,
//   bool? isLogin,
//   required ExtrackKtpModel ktpModel,
// }) {
//   final appState = context.read<AppBloc>().state;
//   final user = appState.user;

//   if (user == null) {
//     // WelcomeRoute().push(context);
//   } else if (user.emailVerified == null) {
//     RegisterOtpRoute(
//       $extra: ktpModel,
//       email: email ?? user.email ?? '',
//       isLogin: appState.isLoggedIn,
//     ).push(context);
//   } else {
//     action.call();
//   }
// }
