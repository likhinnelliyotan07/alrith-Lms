import 'package:flutter/material.dart';
import 'app_config.dart';

class WhiteLabelRegistry {
  const WhiteLabelRegistry._();

  // Default tenant configuration (Arlith)
  static const AppConfig arlithDefault = AppConfig(
    tenantId: 'arlith-default',
    appName: 'Arlith LMS',
    logoAsset: 'assets/logos/arlith_logo.png',
    primaryColorHex: '#6366F1',
    secondaryColorHex: '#06B6D4',
    fontFamily: 'Inter',
    useGradients: true,
  );

  // Demo tenant configuration
  static const AppConfig oceanAcademy = AppConfig(
    tenantId: 'ocean-academy',
    appName: 'Ocean Academy',
    logoAsset: 'assets/logos/ocean_logo.png',
    primaryColorHex: '#0EA5E9',
    secondaryColorHex: '#10B981',
    fontFamily: 'Outfit',
    useGradients: true,
  );

  static AppConfig? getConfig(String tenantId) {
    if (tenantId == 'arlith-default') {
      return arlithDefault;
    } else if (tenantId == 'ocean-academy') {
      return oceanAcademy;
    }
    return null;
  }
}
