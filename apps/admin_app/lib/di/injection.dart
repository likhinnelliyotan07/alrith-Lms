import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:core/di/injection.dart' as core_di;
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureAppDependencies() {
  getIt.init();
}

