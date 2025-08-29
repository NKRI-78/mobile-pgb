part of '../view/ppob_page.dart';

class CustomFieldSection extends StatefulWidget {
  final TextEditingController controller;
  final String? type;

  const CustomFieldSection({
    super.key,
    required this.controller,
    required this.type,
  });

  @override
  State<CustomFieldSection> createState() => _CustomFieldSectionState();
}

class _CustomFieldSectionState extends State<CustomFieldSection> {
  Timer? _debounce;
  String? lastPrefix;
  String? _errorMessage;
  String? _operatorIcon;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      String nomor = _normalizePhoneNumber(widget.controller.text.trim());

      if (nomor.length < 10) {
        if (_errorMessage != "Nomor minimal 10 digit") {
          setState(() {
            _errorMessage = "Nomor minimal 10 digit";
          });
        }
        return;
      } else {
        if (_errorMessage != null) {
          setState(() {
            _errorMessage = null;
          });
        }
      }

      if (widget.controller.text != nomor) {
        widget.controller.text = nomor;
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: nomor.length),
        );
      }

      String prefix = nomor.substring(0, 5);

      String? icon = _getOperatorIcon(prefix);
      if (icon != _operatorIcon) {
        setState(() {
          _operatorIcon = icon;
        });
      }

      if (prefix != lastPrefix) {
        lastPrefix = prefix;
        if (mounted) {
          print("Fetching Data untuk prefix: $prefix, type: ${widget.type}");
          context
              .read<PpobCubit>()
              .fetchPulsaData(prefix: prefix, type: widget.type ?? "PULSA");
        }
      } else {
        print("Prefix tidak berubah, tidak fetch ulang.");
      }
    });
  }

  String _normalizePhoneNumber(String number) {
    String cleanedNumber = number.replaceAll(RegExp(r'\D'), '');
    if (cleanedNumber.startsWith('0')) {
      return '62${cleanedNumber.substring(1)}';
    } else if (!cleanedNumber.startsWith('62')) {
      return '62$cleanedNumber';
    }
    return cleanedNumber;
  }

  String? _getOperatorIcon(String prefix) {
    if (prefix.startsWith("62811") ||
        prefix.startsWith("62812") ||
        prefix.startsWith("62813") ||
        prefix.startsWith("62821") ||
        prefix.startsWith("62822") ||
        prefix.startsWith("62823") ||
        prefix.startsWith("62851") ||
        prefix.startsWith("62852") ||
        prefix.startsWith("62853")) {
      return "assets/icons/telkomsel.png";
    }

    if (prefix.startsWith("62814") ||
        prefix.startsWith("62815") ||
        prefix.startsWith("62816") ||
        prefix.startsWith("62855") ||
        prefix.startsWith("62856") ||
        prefix.startsWith("62857") ||
        prefix.startsWith("62858")) {
      return "assets/icons/indosat.png";
    }

    if (prefix.startsWith("62817") ||
        prefix.startsWith("62818") ||
        prefix.startsWith("62819") ||
        prefix.startsWith("62859") ||
        prefix.startsWith("62877") ||
        prefix.startsWith("62878")) {
      return "assets/icons/xl.png";
    }

    if (prefix.startsWith("62831") ||
        prefix.startsWith("62832") ||
        prefix.startsWith("62833") ||
        prefix.startsWith("62838")) {
      return "assets/icons/axis.png";
    }

    if (prefix.startsWith("62895") ||
        prefix.startsWith("62896") ||
        prefix.startsWith("62897") ||
        prefix.startsWith("62898") ||
        prefix.startsWith("62899")) {
      return "assets/icons/tri.png";
    }

    if (prefix.startsWith("62881") ||
        prefix.startsWith("62882") ||
        prefix.startsWith("62883") ||
        prefix.startsWith("62884") ||
        prefix.startsWith("62885") ||
        prefix.startsWith("62886") ||
        prefix.startsWith("62887") ||
        prefix.startsWith("62888") ||
        prefix.startsWith("62889")) {
      return "assets/icons/smartfren.png";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          child: Row(
            children: [
              if (_operatorIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Image.asset(
                    _operatorIcon!,
                    width: 30,
                    height: 30,
                  ),
                ),
              Expanded(
                child: Theme(
                  data: ThemeData(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionHandleColor: Colors.transparent,
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13),
                    ],
                    cursorColor: AppColors.secondaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Masukkan Nomor",
                      hintStyle: AppTextStyles.textStyleNormal,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedNumber = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactListPpob()),
                  );

                  if (selectedNumber != null && selectedNumber is String) {
                    widget.controller.text = selectedNumber;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                ),
                child: Icon(Icons.contacts, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 10),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
