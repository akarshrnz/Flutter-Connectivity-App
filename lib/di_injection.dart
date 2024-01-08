import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_connectivity_app/features/connection/data/data_source/connection_service.dart';
import 'package:flutter_connectivity_app/features/connection/data/respository/connection_repo_impl.dart';
import 'package:flutter_connectivity_app/features/connection/domain/repository/connection_repository.dart';
import 'package:flutter_connectivity_app/features/connection/domain/usecases/init_connection_usecase.dart';
import 'package:flutter_connectivity_app/features/connection/domain/usecases/start_connection_usecase.dart';
import 'package:flutter_connectivity_app/features/connection/domain/usecases/stop_connection_usecase.dart';
import 'package:flutter_connectivity_app/features/connection/presentation/bloc/connectivity_bloc.dart';
import 'package:get_it/get_it.dart';


GetIt locator = GetIt.instance;
Future<void> initializeDependency() async {
   


  locator.registerSingleton<FlutterBackgroundService>(FlutterBackgroundService());

  locator.registerSingleton<ConnectionServices>(
      ConnectionServicesImpl(locator.call(),));
  locator.registerSingleton<ConnectionRepository>(
      ConnectionRepositoryImpl(locator.call()));
  locator.registerSingleton<InitConnectionUsecase>(
      InitConnectionUsecase(locator.call()));
  locator.registerSingleton<StartConnectionUsecase>(
      StartConnectionUsecase(locator.call()));
  locator.registerSingleton<StopConnectionUsecase>(
      StopConnectionUsecase(locator.call()));
  locator.registerFactory(
      () => ConnectivityBloc(locator.call(), locator.call(), locator.call()));
}
