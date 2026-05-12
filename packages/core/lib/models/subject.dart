import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject.freezed.dart';
part 'subject.g.dart';

@freezed
abstract class Subject with _$Subject {
  factory Subject({
    required String id,
    required String courseId,
    required String title,
    String? description,
    @Default([]) List<Module> modules,
  }) = _$SubjectImpl;

  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);
}

@freezed
abstract class Module with _$Module {
  factory Module({
    required String id,
    required String subjectId,
    required String title,
    @Default([]) List<ContentItem> contents,
  }) = _$ModuleImpl;

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);
}

enum ContentType { video, pdf, note, assignment, quiz, exam }

@freezed
abstract class ContentItem with _$ContentItem {
  factory ContentItem({
    required String id,
    required String moduleId,
    required String title,
    required ContentType type,
    String? url,
    String? description,
    @Default(false) bool isLocked,
    @Default(0) int durationMinutes, // for videos
    String? fileName, // for PDFs/Notes
  }) = _$ContentItemImpl;

  factory ContentItem.fromJson(Map<String, dynamic> json) => _$ContentItemFromJson(json);
}
