import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class CustomFieldListrikSection extends StatefulWidget {
  final TextEditingController controller;

  const CustomFieldListrikSection({
    super.key,
    required this.controller,
  });

  @override
  State<CustomFieldListrikSection> createState() =>
      _CustomFieldListrikSectionState();
}

class _CustomFieldListrikSectionState extends State<CustomFieldListrikSection> {
  Timer? _debounce;
  String? _errorMessage;

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
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final text = widget.controller.text.trim();

      if (text.isEmpty) {
        setState(() => _errorMessage = null);
        return;
      }

      if (text.length < 11) {
        setState(() => _errorMessage = "Nomor minimal 11 digit");
      } else if (text.length > 12) {
        setState(() => _errorMessage = "Nomor maksimal 12 digit");
      } else {
        if (_errorMessage != null) {
          setState(() => _errorMessage = null);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Theme(
                  data: ThemeData(
                    textSelectionTheme: const TextSelectionThemeData(
                      selectionHandleColor: Colors.transparent,
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    cursorColor: AppColors.secondaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          "Masukkan nomor meteran / ID Pelanggan (11–12 digit)",
                      hintStyle: AppTextStyles.textStyleNormal,
                      isDense: true,
                    ),
                  ),
                ),
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
