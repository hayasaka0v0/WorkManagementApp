import 'package:get_it/get_it.dart';
import 'package:learning/core/network/supabase_client.dart';
import 'package:learning/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:learning/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:learning/features/auth/domain/repositories/auth_repository.dart';
import 'package:learning/features/auth/domain/usecases/get_current_user.dart';
import 'package:learning/features/auth/domain/usecases/login.dart';
import 'package:learning/features/auth/domain/usecases/logout.dart';
import 'package:learning/features/auth/domain/usecases/signup.dart';
import 'package:learning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:learning/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:learning/features/tasks/domain/repositories/task_repository.dart';
import 'package:learning/features/tasks/domain/usecases/create_task.dart';
import 'package:learning/features/tasks/domain/usecases/delete_task.dart';
import 'package:learning/features/tasks/domain/usecases/get_tasks.dart';
import 'package:learning/features/tasks/domain/usecases/update_task.dart';
import 'package:learning/features/tasks/presentation/bloc/task_bloc.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // Core
  // Supabase client is initialized separately in main.dart

  // ========== Auth Feature ==========
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(SupabaseClientManager.client),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // BLoC
  sl.registerLazySingleton(
    () =>
        AuthBloc(login: sl(), signup: sl(), logout: sl(), getCurrentUser: sl()),
  );

  // ========== Task Feature ==========
  // Data sources
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(SupabaseClientManager.client),
  );

  // Repositories
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));

  // BLoC
  sl.registerFactory(
    () => TaskBloc(
      getTasks: sl(),
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
    ),
  );
}
