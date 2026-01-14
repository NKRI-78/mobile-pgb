import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../widgets/header/header_section.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';
import '../cubit/need_riview_cubit.dart';
import '../widgets/list_riview.dart';

class NeedRiviewPage extends StatelessWidget {
  const NeedRiviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NeedRiviewCubit>.value(
      value: getIt<NeedRiviewCubit>()..getNeedRiview(),
      child: const NeedRiviewView(),
    );
  }
}

class NeedRiviewView extends StatelessWidget {
  const NeedRiviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NeedRiviewCubit, NeedRiviewState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: CustomScrollView(
            slivers: [
              const HeaderSection(titleHeader: "Beri Penilaian"),
              SliverList(
                  delegate: SliverChildListDelegate([
                state.loading
                    ? const CustomLoadingPage()
                    : state.needRiviewModel.isEmpty
                        ? const EmptyPage(
                            msg: "Belum ada produk yang harus dinilai")
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.needRiviewModel.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.blackColor
                                                .withValues(alpha: 0.2))),
                                    child: ListRiview(
                                        e: state.needRiviewModel[index]));
                              },
                            ),
                          ),
              ])),
            ],
          ),
        );
      },
    );
  }
}
