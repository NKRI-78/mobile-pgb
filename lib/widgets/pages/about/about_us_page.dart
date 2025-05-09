import 'package:flutter/material.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Tentang Partai',
          style: AppTextStyles.textStyleBold,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                color: AppColors.buttonBlueColor,
                child: Image.asset(
                  'assets/images/logo_transparant.png',
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '“Partai Gema Bangsa mencakup nilai, tujuan, dan cita-cita sebagai landasan perjuangan untuk memperjuangkan aspirasi rakyat. '
                'Partai ini memiliki karakter sebagai partai nasional yang modern, terbuka, berwawasan kebangsaan, dan berbasis pada kekuatan rakyat dengan orientasi pada kemandirian bangsa”',
                style: AppTextStyles.textStyleNormal.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'JATIDIRI PARTAI',
                  style: AppTextStyles.textStyleBold.copyWith(fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              _buildBulletPoint(
                'Identitas dan Karakter Partai. Jatidiri Partai Gema Bangsa mencakup nilai, tujuan, dan cita-cita sebagai landasan perjuangan untuk memperjuangkan aspirasi rakyat. '
                'Partai ini memiliki karakter sebagai partai nasional yang modern, terbuka, berwawasan kebangsaan, dan berbasis pada kekuatan rakyat dengan orientasi pada kemandirian bangsa.',
              ),
              SizedBox(height: 5),
              _buildBulletSubpoints(
                'Ciri Partai Modern.',
                [
                  'Dikelola secara profesional dengan manajemen efektif, transparansi, dan akuntabilitas.',
                  'Memanfaatkan teknologi digital dan media sosial untuk komunikasi publik.',
                  'Menjunjung keadilan, kesetaraan, dan demokrasi dalam kepemimpinan serta program partai.',
                ],
              ),
              SizedBox(height: 5),
              _buildBulletSubpoints(
                'Perpaduan Partai Kader dan Partai Massa.',
                [
                  'Sebagai partai kader, fokus pada rekrutmen selektif, pendidikan politik berkelanjutan, dan pembentukan kader berkualitas.',
                  'Sebagai partai massa, menghimpun anggota tanpa seleksi ketat dengan pembinaan komunitas untuk meningkatkan dukungan suara.',
                ],
              ),
              SizedBox(height: 5),
              _buildBulletPoint('Komitmen terhadap Nilai-Nilai dan Prinsip.\n'
                  'Menjunjung keadilan sebagai dasar persatuan bangsa, dengan memperjuangkan program pembangunan yang mempertimbangkan keadilan moral, prosedural, distributif, dan komutatif. Memelihara nilai-nilai luhur budaya bangsa seperti musyawarah, gotong royong, dan toleransi sebagai landasan pengambilan keputusan dan program partai.'),
              SizedBox(height: 5),
              _buildBulletPoint(
                'Berbasis Kekuatan Rakyat dan Kemandirian Bangsa. Menghimpun kekuatan rakyat untuk membangun bangsa dan negara, serta mengakomodasi kepentingan masyarakat yang beragam. '
                'Berorientasi pada trilogi kemandirian (individu, kelompok, dan bangsa) di berbagai bidang untuk memperkokoh persatuan, toleransi, dan kesejahteraan nasional.',
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("•  "),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.textStyleNormal.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletSubpoints(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBulletPoint(title),
        const SizedBox(height: 5),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('–  '),
                Expanded(
                  child: Text(
                    point,
                    style: AppTextStyles.textStyleNormal.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
