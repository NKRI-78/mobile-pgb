import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/injections.dart';
import 'package:mobile_pgb/misc/modal.dart';
import 'package:mobile_pgb/modules/membernear/bloc/membernear_bloc.dart';
import 'package:mobile_pgb/widgets/image/image_avatar.dart';
import 'package:mobile_pgb/widgets/pages/empty_page.dart';
import 'package:mobile_pgb/widgets/pages/loading_page.dart';

part '../widgets/_maps.dart';
part '../widgets/_list_user.dart';
part '../widgets/_membernear_header.dart';
part '../widgets/_membernear_botton_header.dart';

class MemberNearPage extends StatelessWidget {
  const MemberNearPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<MemberNearBloc>(),
      child: const MemberNearView()
    );
  }
}

class MemberNearView extends StatelessWidget {
  const MemberNearView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: BlocBuilder<MemberNearBloc, MemberNearState>(
        builder: (context, st) {
          debugPrint("view Grap Lat: ${st.latitude}");
          debugPrint("view Grap Long: ${st.longitude}");
          return CustomScrollView(
            physics: ScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Stack(
                  fit: StackFit.loose,
                  clipBehavior: Clip.none,
                  children: [
                    _Maps(latitude: st.latitude, longitude: st.longitude, markers: st.markers ?? const [],),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: _ListUser()
                    ),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: _MemberNearHeader()
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: _MemberNearBottonHeader()
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}