import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../misc/colors.dart';

class CustomLoadingPage extends StatelessWidget {
  final Color color;

  const CustomLoadingPage({
    super.key,
    this.color = AppColors.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitWave(
            color: color,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
