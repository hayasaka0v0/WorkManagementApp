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
import 'package:learning/features/company/data/datasources/company_remote_data_source.dart';
import 'package:learning/features/company/data/repositories/company_repository_impl.dart';
import 'package:learning/features/company/domain/repositories/company_repository.dart';
import 'package:learning/features/company/domain/usecases/create_company.dart';
import 'package:learning/features/company/domain/usecases/join_company.dart';
import 'package:learning/features/company/domain/usecases/get_company_by_id.dart';
import 'package:learning/features/company/domain/usecases/regenerate_invite_code.dart';
import 'package:learning/features/company/domain/usecases/leave_company.dart';
import 'package:learning/features/task/data/datasources/task_remote_data_source.dart';
import 'package:learning/features/task/data/repositories/task_repository_impl.dart';
import 'package:learning/features/task/domain/repositories/task_repository.dart';
import 'package:learning/features/task/domain/usecases/create_task.dart';
import 'package:learning/features/task/domain/usecases/delete_task.dart';
import 'package:learning/features/task/domain/usecases/get_tasks.dart';
import 'package:learning/features/task/domain/usecases/update_task.dart';
import 'package:learning/features/task/presentation/bloc/task_bloc.dart';

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
    () => AuthBloc(
      login: sl(),
      signup: sl(),
      logout: sl(),
      getCurrentUser: sl(),
      leaveCompany: sl(),
    ),
  );

  // ========== Company Feature ==========
  // Data sources
  sl.registerLazySingleton<CompanyRemoteDataSource>(
    () => CompanyRemoteDataSourceImpl(SupabaseClientManager.client),
  );

  // Repositories
  sl.registerLazySingleton<CompanyRepository>(
    () => CompanyRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateCompany(sl()));
  sl.registerLazySingleton(() => JoinCompany(sl()));
  sl.registerLazySingleton(() => GetCompanyById(sl()));
  sl.registerLazySingleton(() => RegenerateInviteCode(sl()));
  sl.registerLazySingleton(() => LeaveCompany(sl()));

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
