import 'package:flutter_connectivity_app/core/utils/data_state.dart';

abstract class ConnectionRepository {
  Future<DataState<bool>> initConnectionService();
  Future<DataState<bool>> startConnectionService();
  Future<DataState<bool>> stopConnectionService();
}
