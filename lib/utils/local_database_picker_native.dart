import 'package:file_picker/file_picker.dart';

class LocalDatabasePicker {
  static const bool isSupported = true;

  static Future<String?> chooseFolder() {
    return FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Choose Arcanus Ledger Data Folder',
    );
  }

  static Future<String?> chooseDatabase() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Choose Arcanus Ledger Database',
      type: FileType.custom,
      allowedExtensions: const ['sqlite', 'db'],
    );

    return result?.files.single.path;
  }
}
