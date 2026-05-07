library core;

import 'package:core/white_label/white_label_controller.dart';
import 'package:core/white_label/white_label_registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'di/injection.dart';
import 'services/supabase_service.dart';


export 'constants/app_colors.dart';
export 'constants/app_gradients.dart';
export 'constants/app_constants.dart';
export 'strings/app_strings.dart';
export 'theme/theme_cubit.dart';
export 'widgets/shared_scaffold.dart';
export 'widgets/glass_card.dart';
export 'widgets/premium_login_view.dart';
export 'white_label/app_config.dart';
export 'white_label/white_label_controller.dart';
export 'white_label/white_label_registry.dart';




class ArlithCore {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Hive
    await Hive.initFlutter();
    
    // Load .env

    await dotenv.load(fileName: ".env");
    
    // Setup DI
    configureDependencies();
    
    // Initialize Supabase
    await getIt<SupabaseService>().initialize();

    // Set default white label config
    getIt<WhiteLabelController>().setTenantConfig(WhiteLabelRegistry.arlithDefault);
  }
}

