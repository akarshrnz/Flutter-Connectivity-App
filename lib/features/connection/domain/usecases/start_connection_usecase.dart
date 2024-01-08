

import 'package:flutter_connectivity_app/core/utils/data_state.dart';
import 'package:flutter_connectivity_app/core/utils/usecase.dart';
import 'package:flutter_connectivity_app/features/connection/domain/repository/connection_repository.dart';

class StartConnectionUsecase extends UseCase<DataState<bool>, NoParams> {
  final ConnectionRepository _connectionRepository;

  StartConnectionUsecase(this._connectionRepository);
  @override
  Future<DataState<bool>> call(NoParams  param) {
    return _connectionRepository.startConnectionService();
  }
  
}
