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
export 'constants/app_text_styles.dart';
export 'constants/app_assets.dart';
export 'strings/app_strings.dart';
export 'theme/theme_cubit.dart';
export 'widgets/shared_scaffold.dart';
export 'widgets/glass_card.dart';
export 'widgets/premium_login_view.dart';
export 'widgets/premium_signup_view.dart';
export 'widgets/neumorphic_container.dart';
export 'widgets/animated_dashboard_card.dart';
export 'widgets/white_label_onboarding_view.dart';
export 'widgets/premium_splash_view.dart';
export 'widgets/app_button.dart';
export 'widgets/app_text_field.dart';
export 'widgets/app_shimmer.dart';
export 'white_label/app_config.dart';
export 'white_label/white_label_controller.dart';
export 'white_label/white_label_registry.dart';
export 'models/profile.dart';
export 'models/course.dart';
export 'models/batch.dart';
export 'models/subject.dart';
export 'models/schedule.dart';
export 'models/notification.dart';
export 'models/invoice.dart';
export 'models/coupon.dart';
export 'models/audit_log.dart';
export 'repositories/admin_repository.dart';
export 'repositories/finance_repository.dart';
export 'repositories/parent_repository.dart';
export 'repositories/communication_repository.dart';
export 'services/auth_repository.dart';
export 'services/biometric_service.dart';
export 'services/invoice_service.dart';
export 'theme/app_theme.dart';
export 'auth/bloc/auth_bloc.dart';


export 'auth/bloc/auth_event.dart';
export 'auth/bloc/auth_state.dart';






class ArlithCore {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Hive
    await Hive.initFlutter();
    
    // Load .env
    try {
      debugPrint('CORE: Loading .env from assets/.env...');
      await dotenv.load(fileName: "assets/.env");
      debugPrint('CORE: .env loaded successfully');
    } catch (e) {
      debugPrint('CORE: Error loading .env: $e');
      // If it fails, maybe try the root one as fallback or just rethrow
      try {
        debugPrint('CORE: Attempting fallback to .env...');
        await dotenv.load(fileName: ".env");
        debugPrint('CORE: .env loaded from root');
      } catch (e2) {
        debugPrint('CORE: Fallback failed: $e2');
        rethrow;
      }
    }
    
    // Setup DI
    configureDependencies();
    
    // Initialize Supabase
    await getIt<SupabaseService>().initialize();

    // Set default white label config
    getIt<WhiteLabelController>().setTenantConfig(WhiteLabelRegistry.arlithDefault);
  }
}

