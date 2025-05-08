import 'dart:io';

void main() {
  final dir = Directory('lib'); // change if needed
  final dartFiles = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));

  for (var file in dartFiles) {
    final lines = file.readAsLinesSync();
    final fixedLines = <String>[];
    final movedImports = <String>[];

    int insertIndex = 0;
    bool insideImport = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();

      // Detect if this line is a misplaced import
      if (trimmed.startsWith('import ') && !trimmed.endsWith(';')) {
        insideImport = true;
      }

      if (insideImport) {
        // Collect multiline import
        movedImports.add(line);
        if (trimmed.endsWith(';')) {
          insideImport = false;
        }
        continue;
      } else if (trimmed.startsWith('import ')) {
        // Single-line import inside class/function
        movedImports.add(line);
        continue;
      }

      fixedLines.add(line);
    }

    if (movedImports.isNotEmpty) {
      print('Fixing imports in: ${file.path}');

      // Insert after any library declaration
      int libLineIndex = fixedLines.indexWhere((l) => l.trim().startsWith('library '));
      insertIndex = libLineIndex >= 0 ? libLineIndex + 1 : 0;

      fixedLines.insertAll(insertIndex, [...movedImports, '']);
      file.writeAsStringSync(fixedLines.join('\n'));
    }
  }
}