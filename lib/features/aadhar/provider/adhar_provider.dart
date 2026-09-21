import 'dart:io';
import 'package:flutter/foundation.dart';

class AadhaarProvider extends ChangeNotifier {
  String _aadhaar = '';
  File? _frontImage;
  File? _backImage;

  // Getters
  String get aadhaar => _aadhaar;
  File? get frontImage => _frontImage;
  File? get backImage => _backImage;

  bool get isAadhaarValid => _aadhaar.length == 12;
  bool get isFrontUploaded => _frontImage != null;
  bool get isBackUploaded => _backImage != null;

  bool get canContinue => isAadhaarValid && isFrontUploaded && isBackUploaded;

  // ✅ ADD THIS GETTER
  String get maskedAadhaar {
    if (_aadhaar.length < 12) return _aadhaar;
    return "XXXX XXXX ${_aadhaar.substring(8)}";
  }

  // Set Aadhaar (raw digits only)
  void setAadhaar(String value) {
    _aadhaar = value;

    debugPrint("AADHAAR: $_aadhaar");
    debugPrint("AADHAAR VALID: $isAadhaarValid");

    notifyListeners();
  }

  // Set front image
  void setFrontImage(File file) {
    _frontImage = file;

    debugPrint("FRONT IMAGE SELECTED: ${file.path}");
    debugPrint("CAN CONTINUE: $canContinue");

    notifyListeners();
  }

  // Set back image
  void setBackImage(File file) {
    _backImage = file;

    debugPrint("BACK IMAGE SELECTED: ${file.path}");
    debugPrint("CAN CONTINUE: $canContinue");

    notifyListeners();
  }
}
