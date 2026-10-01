import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File> compressForUpload(File input) async {
  try {
    final name = input.path.toLowerCase();
    if (name.endsWith('.pdf')) {
      debugPrint('[IMG] PDF — skipping compression');
      return input;
    }

    final originalSize = await input.length();
    if (originalSize < 500 * 1024) {
      debugPrint(
        '[IMG] already small (${originalSize ~/ 1024} KB) — skipping',
      );
      return input;
    }

    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      input.absolute.path,
      targetPath,
      minWidth: 1600,
      minHeight: 1600,
      quality: 75,
      format: CompressFormat.jpeg,
    );

    if (result == null) {
      debugPrint('[IMG] compress returned null — using original');
      return input;
    }

    final out = File(result.path);
    final newSize = await out.length();
    debugPrint(
      '[IMG] compressed ${originalSize ~/ 1024} KB → '
      '${newSize ~/ 1024} KB',
    );
    return out;
  } catch (e) {
    debugPrint('[IMG] compression failed: $e — using original');
    return input;
  }
}