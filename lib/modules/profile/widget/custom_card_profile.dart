part of '../view/profile_page.dart';

final GlobalKey _ktaKey = GlobalKey();

enum CardSide { front, back }

class CustomCardProfile extends StatefulWidget {
  final String noKta;
  final String nama;
  final String tempatTglLahir;
  final String agama;
  final String alamat;
  final String rtRw;
  final String kelurahan;
  final String kecamatan;
  final String fotoPath;
  final String createAt;
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
    required this.rtRw,
    required this.kelurahan,
    required this.kecamatan,
    required this.createAt,
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
    final imageHeight = isSmall ? 70.0 : 75.0;

    return Card(
      color: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width * 0.55,
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
                  Positioned.fill(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 60, left: 15, right: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: imageWidth,
                                height: imageHeight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  image: DecorationImage(
                                    image: widget.fotoPath.startsWith('http')
                                        ? NetworkImage(widget.fotoPath)
                                        : AssetImage(widget.fotoPath)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Reg.Date:',
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  fontSize: 6,
                                  color: AppColors.greyColor,
                                ),
                              ),
                              Text(
                                DateHelper.parseDate(widget.createAt),
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  fontSize: 6,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.noKta,
                                  style: AppTextStyles.textStyleBold.copyWith(
                                    color: AppColors.blackColor,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  widget.nama,
                                  style: AppTextStyles.textStyleBold.copyWith(
                                    color: AppColors.blackColor,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.tempatTglLahir,
                                  style: AppTextStyles.textStyleNormal.copyWith(
                                    color: AppColors.greyColor,
                                    fontSize: 8,
                                  ),
                                ),
                                Text(
                                  widget.alamat,
                                  style: AppTextStyles.textStyleNormal.copyWith(
                                    color: AppColors.greyColor,
                                    fontSize: 8,
                                  ),
                                ),
                                Text(
                                  widget.rtRw,
                                  style: AppTextStyles.textStyleNormal.copyWith(
                                    color: AppColors.greyColor,
                                    fontSize: 8,
                                  ),
                                ),
                                Text(
                                  widget.kelurahan,
                                  style: AppTextStyles.textStyleNormal.copyWith(
                                    color: AppColors.greyColor,
                                    fontSize: 8,
                                  ),
                                ),
                                Text(
                                  widget.kecamatan,
                                  style: AppTextStyles.textStyleNormal.copyWith(
                                    color: AppColors.greyColor,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: BarcodeWidget(
                      color: AppColors.buttonBlueColor,
                      barcode: Barcode.qrCode(),
                      data: widget.noKta,
                      width: 50,
                      height: 50,
                      drawText: false,
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
