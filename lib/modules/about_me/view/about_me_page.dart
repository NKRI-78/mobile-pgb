import 'package:flutter/material.dart';
import '../../../misc/colors.dart';
import '../../../misc/helper.dart';
import '../../../misc/text_style.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'About Me',
          style: AppTextStyles.textStyleBold.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Logo
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logo.png',
                height: 120,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              "Partai Gema Bangsa mencakup nilai, tujuan, dan cita-cita sebagai landasan perjuangan untuk memperjuangkan aspirasi rakyat. Partai ini memiliki karakter sebagai partai nasional yang modern, terbuka, berwawasan kebangsaan, dan berbasis pada kekuatan rakyat dengan orientasi pada kemandirian bangsa.",
              style: AppTextStyles.textStyleNormal.copyWith(
                color: AppColors.greyColor,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Contact Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hubungi Kami",
                      style: AppTextStyles.textStyleBold.copyWith(
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      icon: Icons.phone,
                      color: AppColors.greenColor,
                      title: "0812-2834-4065",
                      onTap: () {
                        Helper.openFixedWhatsApp(context);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      icon: Icons.email,
                      color: AppColors.tertiaryColor,
                      title: "partaigemabangsa@gmail.com",
                      onTap: () {
                        Helper.sendEmail(
                          toEmail: "partaigemabangsa@gmail.com",
                          subject: "Informasi Gema Bangsa",
                          body: "Halo DPP Gema Bangsa, saya ingin bertanya...",
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      icon: Icons.location_on,
                      color: AppColors.redColor,
                      title:
                          "Jl. Hang Jebat IV blok IV No. 3,\nGunung, Kebayoran Baru,\nJakarta Selatan 12120",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color color,
    required String title,
    VoidCallback? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: onTap != null
              ? GestureDetector(
                  onTap: onTap,
                  child: Text(
                    title,
                    style: AppTextStyles.textStyleNormal.copyWith(
                      fontSize: 14,
                      color: color,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(
                  title,
                  style: AppTextStyles.textStyleNormal.copyWith(fontSize: 14),
                ),
        ),
      ],
    );
  }
}
