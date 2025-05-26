part of '../view/profile_page.dart';

final GlobalKey _ktaKey = GlobalKey();

enum CardSide { front, back }

class CustomCardProfile extends StatefulWidget {
  final String noKta;
  final String nama;
  final String tempatTglLahir;
  final String agama;
  final String alamat;
  final String fotoPath;
  final bool isForExport;
  final CardSide cardSide;
  final ValueChanged<CardSide> onCardSideChanged;

  const CustomCardProfile({
    super.key,
    required this.noKta,
    required this.nama,
    required this.tempatTglLahir,
    required this.agama,
    required this.alamat,
    required this.fotoPath,
    required this.cardSide,
    required this.onCardSideChanged,
    this.isForExport = false,
  });

  @override
  State<CustomCardProfile> createState() => _CustomCardProfileState();
}

class _CustomCardProfileState extends State<CustomCardProfile> {
  late CardSide _cardSide;

  @override
  void initState() {
    super.initState();
    _cardSide = widget.cardSide;
  }

  void _toggleCardSide(CardSide side) {
    setState(() {
      _cardSide = side;
    });
    widget.onCardSideChanged(side);
  }

  @override
  Widget build(BuildContext context) {
    final isFront = _cardSide == CardSide.front;

    return Column(
      children: [
        if (!widget.isForExport)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CardSideButton(
                text: 'Tampak Depan',
                isSelected: isFront,
                onTap: () => _toggleCardSide(CardSide.front),
              ),
              const SizedBox(width: 8),
              _CardSideButton(
                text: 'Tampak Belakang',
                isSelected: !isFront,
                onTap: () => _toggleCardSide(CardSide.back),
              ),
            ],
          ),
        const SizedBox(height: 12),
        // Hanya bagian kartu yang dibungkus RepaintBoundary saat export
        RepaintBoundary(
          key: widget.isForExport ? _ktaKey : _ktaKey, // bisa disederhanakan
          child: _buildCardOnly(isFront),
        ),
      ],
    );
  }

  Widget _buildCardOnly(bool isFront) {
    final isSmall = MediaQuery.of(context).size.width < 350;
    final imageWidth = isSmall ? 65.0 : 70.0;
    final imageHeight = isSmall ? 80.0 : 90.0;

    return Card(
      color: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isFront
                ? 'assets/images/card.png'
                : 'assets/images/card_back.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: isFront
            ? Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 60),
                          width: imageWidth,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: widget.fotoPath.startsWith('http')
                                  ? NetworkImage(widget.fotoPath)
                                  : AssetImage(widget.fotoPath)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InfoLine(
                                    label: 'No. KTA               ',
                                    value: widget.noKta),
                                InfoLine(
                                    label: 'Nama                   ',
                                    value: widget.nama),
                                InfoLine(
                                    label: 'Tempat/Tgl Lahir',
                                    value: widget.tempatTglLahir),
                                InfoLine(
                                    label: 'Agama                 ',
                                    value: widget.agama),
                                InfoLine(
                                    label: 'Alamat                 ',
                                    value: widget.alamat),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 2),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: BarcodeWidget(
                          barcode: Barcode.qrCode(),
                          data: widget.noKta,
                          width: 40,
                          height: 40,
                          drawText: false,
                          backgroundColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

class _CardSideButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _CardSideButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: isSelected
            ? AppColors.secondaryColor
            : AppColors.greyColor.withValues(alpha: 0.8),
        foregroundColor:
            isSelected ? AppColors.whiteColor : AppColors.blackColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: AppTextStyles.textStyleNormal.copyWith(
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}

class InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const InfoLine({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            '$label :',
            style: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.blackColor,
              fontSize: 7,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.blackColor,
              fontSize: 7,
            ),
          ),
        ),
      ],
    );
  }
}
