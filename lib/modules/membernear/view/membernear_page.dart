import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../misc/theme.dart';
import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/modal.dart';
import '../bloc/membernear_bloc.dart';
import '../../../widgets/image/image_avatar.dart';
import '../../../widgets/pages/loading_page.dart';

import '../../../misc/text_style.dart';

part '../widgets/_maps.dart';
part '../widgets/_list_user.dart';
part '../widgets/_membernear_header.dart';
part '../widgets/_membernear_botton_header.dart';
part '../widgets/_empt_page_location.dart';

class MemberNearPage extends StatelessWidget {
  const MemberNearPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: getIt<MemberNearBloc>(), child: const MemberNearView());
  }
}

class MemberNearView extends StatelessWidget {
  const MemberNearView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body:
          BlocBuilder<MemberNearBloc, MemberNearState>(builder: (context, st) {
        debugPrint("view Grap Lat: ${st.latitude}");
        debugPrint("view Grap Long: ${st.longitude}");
        debugPrint("view Grap Data: ${jsonEncode(st.memberNearData?.length)}");
        return CustomScrollView(
          physics: ScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Stack(
                fit: StackFit.loose,
                clipBehavior: Clip.none,
                children: [
                  _Maps(
                    latitude: st.latitude,
                    longitude: st.longitude,
                    markers: st.markers ?? const [],
                  ),
                  const Align(
                      alignment: Alignment.bottomCenter, child: _ListUser()),
                  const Align(
                      alignment: Alignment.topCenter,
                      child: _MemberNearHeader()),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: _MemberNearBottonHeader()),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
