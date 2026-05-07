import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required String tenantId,
    required String appName,
    required String logoAsset,
    required String primaryColorHex,
    required String secondaryColorHex,
    String? fontFamily,
    @Default(true) bool useGradients,
    @Default(false) bool isMaintenanceMode,
    Map<String, dynamic>? customMetadata,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

}

extension AppConfigX on AppConfig {
  Color get primaryColor => Color(int.parse(primaryColorHex.replaceFirst('#', '0xFF')));
  Color get secondaryColor => Color(int.parse(secondaryColorHex.replaceFirst('#', '0xFF')));
}
