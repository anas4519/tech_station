import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/sign_in_with_email.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up_with_email.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/devices/data/datasources/device_remote_data_source.dart';
import 'features/devices/data/repositories/device_repository_impl.dart';
import 'features/devices/domain/repositories/device_repository.dart';
import 'features/devices/domain/usecases/get_all_devices.dart';
import 'features/devices/domain/usecases/get_device_by_id.dart';
import 'features/devices/domain/usecases/get_devices_by_category.dart';
import 'features/devices/domain/usecases/search_devices.dart';
import 'features/devices/presentation/bloc/device_list_bloc.dart';
import 'features/account/presentation/bloc/theme_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = Supabase.instance.client;

  // ── Auth ──
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: supabase),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignUpWithEmail(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      signInWithEmail: sl(),
      signUpWithEmail: sl(),
      signInWithGoogle: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      authRepository: sl(),
    ),
  );

  // ── Devices ──
  // Data Sources
  sl.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(supabaseClient: supabase),
  );

  // Repositories
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllDevices(sl()));
  sl.registerLazySingleton(() => GetDeviceById(sl()));
  sl.registerLazySingleton(() => GetDevicesByCategory(sl()));
  sl.registerLazySingleton(() => SearchDevices(sl()));

  // BLoC
  sl.registerFactory(
    () => DeviceListBloc(
      getAllDevices: sl(),
      getDevicesByCategory: sl(),
      searchDevices: sl(),
    ),
  );

  // ── Theme ──
  sl.registerLazySingleton(() => ThemeBloc());
}
