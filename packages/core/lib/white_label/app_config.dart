import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
abstract class AppConfig with _$AppConfig {
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
  }) = _$AppConfigImpl;

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);
}

extension AppConfigX on AppConfig {
  Color get primaryColor => _hexToColor(primaryColorHex);
  Color get secondaryColor => _hexToColor(secondaryColorHex);

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}
