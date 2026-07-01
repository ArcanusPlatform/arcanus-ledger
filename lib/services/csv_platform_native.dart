import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../utils/storage_paths.dart';

class CsvPlatform {
  /// Export CSV into the portable app export directory.
  static Future<void> downloadFile(String filename, String content) async {
    try {
      final file = File(StoragePaths.exportFile(filename));
      await file.writeAsString(content, flush: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Import CSV with native file picker dialog
  static Future<String?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        dialogTitle: 'Select CSV File to Import',
        withData: false,
        withReadStream: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        return await file.readAsString();
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
