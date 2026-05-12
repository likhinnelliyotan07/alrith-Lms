import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class AppNotification with _$AppNotification {
  factory AppNotification({
    required String id,
    required String userId,
    required String title,
    required String message,
    required DateTime createdAt,
    @Default(false) bool isRead,
    String? type,
  }) = _$AppNotificationImpl;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
}
