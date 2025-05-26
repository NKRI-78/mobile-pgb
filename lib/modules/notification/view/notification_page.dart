import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/text_style.dart';
import '../../app/bloc/app_bloc.dart';
import '../cubit/notification_cubit.dart';
import '../widget/notification_list.dart';
import '../widget/notification_list_ppob.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<NotificationCubit>()..fetchNotification(),
      child: NotificationView(),
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        int unreadPPOB =
            state.inboxNotif.where((n) => n.isRead == false).length;
        int unreadSOS = state.notif
            .where((n) => n.type == "SOS" && n.readAt == null)
            .length;
        int unreadPayment = state.notif
            .where((n) => n.type.contains("PAYMENT") && n.readAt == null)
            .length;
        int unreadOther = state.notif
            .where((n) => ["BROADCAST"].contains(n.type) && n.readAt == null)
            .length;

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text(
                'Notification',
                style: AppTextStyles.textStyleBold,
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.done_all_rounded,
                    color: AppColors.secondaryColor,
                  ),
                  onPressed: () {
                    _showReadAllDialog(context);
                  },
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.secondaryColor,
                labelColor: AppColors.secondaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  _buildTabWithBadge("SOS", unreadSOS),
                  _buildTabWithBadge("TRANSAKSI", unreadPayment),
                  _buildTabWithBadge("PULSA DAN TAGIHAN", unreadPPOB),
                  _buildTabWithBadge("OTHER", unreadOther),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                NotificationList(category: "SOS"),
                NotificationList(category: "PAYMENT"),
                NotificationListPpob(),
                NotificationList(category: "OTHER"),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReadAllDialog(BuildContext context) {
    final notificationCubit = context.read<NotificationCubit>();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => BlocProvider.value(
        value: notificationCubit,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.secondaryColor,
                        Color(0xFF005FA3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(3, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tandai semua dibaca?',
                        style: AppTextStyles.textStyleBold.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Apakah kamu yakin ingin menandai semua notifikasi sebagai telah dibaca?',
                        style: AppTextStyles.textStyleNormal.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.redColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Batal',
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.greenColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Future.delayed(Duration.zero, () {
                                  final userId = getIt<AppBloc>()
                                      .state
                                      .profile
                                      ?.id
                                      .toString();
                                  if (userId != null) {
                                    notificationCubit.readAllNotif();
                                    notificationCubit.readAllNotifPpob(userId);
                                  }
                                });
                              },
                              child: Text(
                                'Yakin',
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: -70,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/done.png',
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabWithBadge(String title, int unreadCount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Tab(text: title),
        if (unreadCount > 0)
          Positioned(
            right: -15,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 10,
                minHeight: 10,
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
