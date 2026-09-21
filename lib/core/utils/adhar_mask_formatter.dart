import 'package:flutter/services.dart';

class AadhaarMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    final masked = digits.length <= 4
        ? digits
        : 'XXXX XXXX ${digits.substring(digits.length - 4)}';

    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }
}
