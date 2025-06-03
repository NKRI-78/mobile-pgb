// import 'dart:convert';

// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:http/http.dart' as ht;

// part 'register_google_state.dart';

// class RegisterGoogleCubit extends Cubit<RegisterGoogleState> {
//   RegisterGoogleCubit() : super(const RegisterGoogleState());

//   Future<void> loginWithGoogle(BuildContext context) async {
//     try {
//       final googleUser = await GoogleSignIn().signIn();
//       final googleAuth = await googleUser?.authentication;

//       if (googleAuth?.accessToken == null) {
//         throw Exception("Access Token is null");
//       }

//       final accessToken = googleAuth!.accessToken;

//       print("Access Token: $accessToken");

//       final response = await ht.post(
//         Uri.parse("http://157.245.193.49:9985/api/v1/auth/signinWithGoogle"),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'token': accessToken,
//         }),
//       );

//       print("✅ API response: ${response.body}");

//       // if (response.statusCode == 200) {
//       //   HomeRoute().go(context);
//       // } else {
//       //   RegisterKtpRoute().go(context);
//       // }
//     } catch (e) {
//       print("❌ Login Google error: $e");
//     }
//   }
// }
