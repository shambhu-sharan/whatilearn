import 'dart:io';
import 'package:path/path.dart' as p;

final projectDir = Directory('lib/apps/data/');

void main() {
  final allDartFiles = projectDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  final classMap = <String, String>{};

  // Step 1: Build a map of class names to file paths
  for (var file in allDartFiles) {
    final content = file.readAsStringSync();
    final classMatches = RegExp(r'class\s+(\w+)').allMatches(content);
    for (var match in classMatches) {
      classMap[match.group(1)!] = file.path;
    }
  }

  // Step 2: Add missing imports
  for (var file in allDartFiles) {
    final path = file.path;
    final lines = file.readAsLinesSync();
    final fullText = lines.join('\n');

    final existingImports = lines
        .where((line) => line.trimLeft().startsWith("import "))
        .toSet();

    final definedClasses = RegExp(r'class\s+(\w+)').allMatches(fullText).map((m) => m.group(1)!);
    final usedClasses = RegExp(r'\b([A-Z][A-Za-z0-9_]*)\b').allMatches(fullText).map((m) => m.group(1)!);

    final undefinedUsedClasses = usedClasses.toSet()
      ..removeAll(definedClasses);

    final missingImports = <String>{};

    for (var className in undefinedUsedClasses) {
      if (classMap.containsKey(className) && classMap[className] != path) {
        final importPath = classMap[className]!;
        final relative = p.relative(importPath, from: p.dirname(path)).replaceAll(r'\', '/');
        final importStatement = "import '$relative';";
        if (!existingImports.contains(importStatement)) {
          missingImports.add(importStatement);
        }
      }
    }

    if (missingImports.isNotEmpty) {
      print('Fixing imports in $path');

      // Find where to insert imports
      int insertIndex = 0;
      if (lines.isNotEmpty && lines.first.trimLeft().startsWith('library ')) {
        insertIndex = 1;
      }

      final newLines = [
        ...lines.sublist(0, insertIndex),
        ...missingImports,
        ...lines.sublist(insertIndex),
      ];

      file.writeAsStringSync(newLines.join('\n'));
    }
  }
}


/*
void main() async {
  final allDartFiles = projectDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  final classMap = <String, String>{};

  // Step 1: Index all classes and their paths
  for (var file in allDartFiles) {
    final content = file.readAsStringSync();
    final matches = RegExp(r'class\s+(\w+)').allMatches(content);
    for (final match in matches) {
      final className = match.group(1)!;
      classMap[className] = file.path;
    }
  }

  // Step 2: Process each Dart file to find missing imports
  for (var file in allDartFiles) {
    final content = file.readAsLinesSync();
    final imports = content.where((line) => line.trim().startsWith('import')).toList();
    final importSet = imports.map((line) => line.trim()).toSet();

    final usedClasses = RegExp(r'\b([A-Z][A-Za-z0-9_]*)\b')
        .allMatches(content.join('\n'))
        .map((m) => m.group(1)!)
        .toSet();

    final existingDefinedClasses = RegExp(r'class\s+([A-Z][A-Za-z0-9_]*)')
        .allMatches(content.join('\n'))
        .map((m) => m.group(1)!)
        .toSet();

    final filePath = file.path;
    final missingClasses = usedClasses
        .difference(existingDefinedClasses)
        .where((c) => classMap.containsKey(c) && classMap[c] != filePath)
        .toSet();

    final missingImports = <String>{};

    for (final className in missingClasses) {
      final importPath = classMap[className]!;
      final relativeImport = p.relative(importPath, from: p.dirname(filePath));
      final importStatement = "import '${relativeImport.replaceAll(r'\', '/')}';";
      if (!importSet.contains(importStatement)) {
        missingImports.add(importStatement);
      }
    }

    if (missingImports.isNotEmpty) {
      print('Fixing imports in ${file.path}');

      // Insert after existing imports or at the top
      int insertIndex = content.indexWhere((line) => line.trim().startsWith('import'));
      if (insertIndex == -1) insertIndex = 0;

      final newContent = [
        ...content.sublist(0, insertIndex + 1),
        ...missingImports,
        ...content.sublist(insertIndex + 1)
      ];

      file.writeAsStringSync(newContent.join('\n'));
    }
  }
}*/