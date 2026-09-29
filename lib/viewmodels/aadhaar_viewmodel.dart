import 'dart:io';
import 'package:flutter/foundation.dart';

class AadhaarViewModel extends ChangeNotifier {
  String _aadhaar = '';
  File? _frontImage;
  File? _backImage;

  String get aadhaar => _aadhaar;
  File? get frontImage => _frontImage;
  File? get backImage => _backImage;

  bool get isAadhaarValid => _aadhaar.length == 12;
  bool get isFrontUploaded => _frontImage != null;
  bool get isBackUploaded => _backImage != null;
  bool get canContinue => isAadhaarValid && isFrontUploaded && isBackUploaded;

  String get maskedAadhaar {
    if (_aadhaar.length < 12) return _aadhaar;
    return 'XXXX XXXX ${_aadhaar.substring(8)}';
  }

  void setAadhaar(String value) {
    _aadhaar = value;
    notifyListeners();
  }

  void setFrontImage(File file) {
    _frontImage = file;
    notifyListeners();
  }

  void setBackImage(File file) {
    _backImage = file;
    notifyListeners();
  }

  void reset() {
    _aadhaar = '';
    _frontImage = null;
    _backImage = null;
    notifyListeners();
  }
}