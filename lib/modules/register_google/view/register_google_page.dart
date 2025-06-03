// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mobile_pgb/modules/register_google/cubit/register_google_cubit.dart';

// class RegisterGooglePage extends StatelessWidget {
//   const RegisterGooglePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => RegisterGoogleCubit()..loginWithGoogle(context),
//       child: RegisterGoogleView(),
//     );
//   }
// }

// class RegisterGoogleView extends StatelessWidget {
//   const RegisterGoogleView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RegisterGoogleCubit, RegisterGoogleState>(
//       builder: (context, state) {
//         return Scaffold();
//       },
//     );
//   }
// }
