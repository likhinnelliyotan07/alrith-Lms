import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

    return dio;
  }

  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}

