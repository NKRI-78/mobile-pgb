part of '../view/profile_page.dart';

class CustomDataProfile extends StatelessWidget {
  final String nama;
  final String email;
  final String noTlp;

  const CustomDataProfile({
    super.key,
    required this.nama,
    required this.email,
    required this.noTlp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _InfoTile(label: 'Nama  :', value: nama),
          const Divider(
            color: AppColors.primaryColor,
          ),
          _InfoTile(label: 'Email   :', value: email),
          const Divider(
            color: AppColors.primaryColor,
          ),
          _InfoTile(label: 'No Tlp :', value: noTlp),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(label, style: AppTextStyles.textStyleNormal),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: AppTextStyles.textStyleNormal),
        ),
      ],
    );
  }
}
