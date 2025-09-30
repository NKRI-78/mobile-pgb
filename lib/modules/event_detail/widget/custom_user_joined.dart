import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../misc/text_style.dart';
import '../../../repositories/event_repository/models/event_detail_model.dart';

class CustomUserJoinedList extends StatelessWidget {
  final List<UserJoins> users;

  const CustomUserJoinedList({super.key, required this.users});

  String _formatJoinDate(String? date) {
    if (date == null) return "-";
    try {
      final parsed = DateTime.parse(date).toLocal();
      return DateFormat("dd MMM yyyy", "id").format(parsed);
    } catch (e) {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text("Belum ada peserta yang bergabung"));
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final join = users[index];
          final profile = join.user?.profile;
          final avatar = profile?.avatarLink;
          final name = profile?.fullname ?? join.user?.email ?? "User";

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: avatar != null ? NetworkImage(avatar) : null,
              child: avatar == null ? const Icon(Icons.person) : null,
            ),
            title: Text(
              name,
              style: AppTextStyles.textStyleBold.copyWith(
                fontSize: 13,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bergabung pada ${_formatJoinDate(join.createdAt?.toString())}",
                  style: AppTextStyles.textStyleNormal.copyWith(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
