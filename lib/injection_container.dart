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
import 'features/devices/domain/usecases/get_categories.dart';
import 'features/devices/domain/usecases/get_device_by_id.dart';
import 'features/devices/domain/usecases/get_devices_by_category.dart';
import 'features/devices/domain/usecases/search_devices.dart';
import 'features/devices/domain/usecases/upload_camera_sample.dart';
import 'features/devices/presentation/bloc/device_list_bloc.dart';
import 'features/account/presentation/bloc/theme_bloc.dart';
import 'features/comments/data/datasources/comment_remote_data_source.dart';
import 'features/comments/data/repositories/comment_repository_impl.dart';
import 'features/comments/domain/repositories/comment_repository.dart';
import 'features/comments/domain/usecases/get_comments.dart';
import 'features/comments/domain/usecases/add_comment.dart';
import 'features/comments/domain/usecases/toggle_vote.dart';
import 'features/comments/domain/usecases/mark_as_answered.dart';
import 'features/comments/domain/usecases/delete_comment.dart';
import 'features/comments/presentation/bloc/comments_bloc.dart';

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
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => UploadCameraSample(sl()));

  // BLoC
  sl.registerFactory(
    () => DeviceListBloc(
      getAllDevices: sl(),
      getDevicesByCategory: sl(),
      searchDevices: sl(),
      getCategories: sl(),
    ),
  );

  // ── Comments ──
  // Data Sources
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(supabaseClient: supabase),
  );

  // Repositories
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetComments(sl()));
  sl.registerLazySingleton(() => AddComment(sl()));
  sl.registerLazySingleton(() => ToggleVote(sl()));
  sl.registerLazySingleton(() => MarkAsAnswered(sl()));
  sl.registerLazySingleton(() => DeleteComment(sl()));

  // BLoC
  sl.registerFactory(
    () => CommentsBloc(
      getComments: sl(),
      addComment: sl(),
      toggleVote: sl(),
      markAsAnswered: sl(),
      deleteComment: sl(),
    ),
  );

  // ── Theme ──
  sl.registerLazySingleton(() => ThemeBloc());
}
