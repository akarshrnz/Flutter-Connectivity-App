

import 'package:flutter_connectivity_app/core/utils/data_state.dart';
import 'package:flutter_connectivity_app/features/connection/data/data_source/connection_service.dart';
import 'package:flutter_connectivity_app/features/connection/domain/repository/connection_repository.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionServices _connectionServices;

  ConnectionRepositoryImpl(this._connectionServices);

  @override
  Future<DataState<bool>> initConnectionService() {
    return _connectionServices.initConnectionService();
  }

  @override
  Future<DataState<bool>> startConnectionService() {
    return _connectionServices.startConnectionService();
  }

  @override
  Future<DataState<bool>> stopConnectionService() {
    return _connectionServices.stopConnectionService();
  }


  
}
