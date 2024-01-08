

import 'package:flutter_connectivity_app/core/utils/data_state.dart';
import 'package:flutter_connectivity_app/core/utils/usecase.dart';
import 'package:flutter_connectivity_app/features/connection/domain/repository/connection_repository.dart';

class InitConnectionUsecase extends UseCase<DataState<bool>, NoParams> {
  final ConnectionRepository _connectionRepository;

  InitConnectionUsecase(this._connectionRepository);
  @override
  Future<DataState<bool>> call(NoParams param) {
    return _connectionRepository.initConnectionService();
  }
  
}
