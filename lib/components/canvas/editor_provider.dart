import 'package:flutter/material.dart';
import 'package:saber/data/editor/editor_core_info.dart';

/// May be good for performance later on, but I don't have time to finish it rn
class EditorProvider extends InheritedModel<_EditorCoreInfoAspect> {
  const EditorProvider({
    super.key,
    required this.coreInfo,
    required super.child,
  });

  final EditorCoreInfo coreInfo;

  static EditorCoreInfo? maybeOf(BuildContext context) => _maybeOf(context);
  static EditorCoreInfo of(BuildContext context) => _maybeOf(context)!;

  static EditorCoreInfo? _maybeOf(
    BuildContext context, {
    _EditorCoreInfoAspect? aspect,
  }) =>
      InheritedModel.inheritFrom<EditorProvider>(context, aspect: aspect)
          ?.coreInfo;

  static bool readOnlyOf(BuildContext context) =>
      _maybeOf(context, aspect: _EditorCoreInfoAspect.readOnly)!.readOnly;
  static String filePathOf(BuildContext context) =>
      _maybeOf(context, aspect: _EditorCoreInfoAspect.filePath)!.filePath;
  static String fileNameOf(BuildContext context) =>
      _maybeOf(context, aspect: _EditorCoreInfoAspect.fileName)!.fileName;

  @override
  bool updateShouldNotify(EditorProvider oldWidget) =>
      coreInfo != oldWidget.coreInfo;

  @override
  bool updateShouldNotifyDependent(
      EditorProvider oldWidget, Set<Object> dependencies) {
    final oldCoreInfo = oldWidget.coreInfo;
    return dependencies.any(
      (dependency) =>
          dependency is _EditorCoreInfoAspect &&
          switch (dependency) {
            _EditorCoreInfoAspect.readOnly =>
              coreInfo.readOnly != oldCoreInfo.readOnly,
            _EditorCoreInfoAspect.filePath ||
            _EditorCoreInfoAspect.fileName =>
              coreInfo.filePath != oldCoreInfo.filePath,
          },
    );
  }
}

enum _EditorCoreInfoAspect {
  readOnly,
  filePath,
  fileName,
}
