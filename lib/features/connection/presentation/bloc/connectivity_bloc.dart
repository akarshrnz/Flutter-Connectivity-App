import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_connectivity_app/core/utils/app_constant_widgets.dart';
import 'package:flutter_connectivity_app/core/utils/data_state.dart';
import 'package:flutter_connectivity_app/core/utils/string_constants.dart';
import 'package:flutter_connectivity_app/core/utils/usecase.dart';
import 'package:flutter_connectivity_app/features/connection/domain/usecases/init_connection_usecase.dart';
import 'package:flutter_connectivity_app/features/connection/domain/usecases/start_connection_usecase.dart';
import 'package:flutter_connectivity_app/features/connection/domain/usecases/stop_connection_usecase.dart';
import 'package:meta/meta.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final InitConnectionUsecase _initConnectionUsecase;
  final StartConnectionUsecase _startConnectionUsecase;
  final StopConnectionUsecase _stopConnectionUsecase;

  ConnectivityBloc(this._initConnectionUsecase, this._startConnectionUsecase,
      this._stopConnectionUsecase)
      : super(ConnectivityInitial()) {
    on<ConnectivityInitEvent>(_initBackgroundService);
    on<ConnectivityStartEvent>(_startBackgroundService);
    on<ConnectivityStopEvent>(_stopBackgroundService);
  }

  FutureOr<void> _initBackgroundService(
      ConnectivityInitEvent event, Emitter<ConnectivityState> emit) async {
    var res = await _initConnectionUsecase.call(NoParams());
    if (res is DataSuccess) {
    } else {
      AppConstWidget.toastMsg(
          msg: StringConstants.somethingWentWrong, backgroundColor: Colors.red);
    }
  }

  FutureOr<void> _startBackgroundService(
      ConnectivityStartEvent event, Emitter<ConnectivityState> emit) async {
    var res = await _startConnectionUsecase.call(NoParams());
    if (res is DataSuccess) {
      AppConstWidget.toastMsg(
          msg: StringConstants.serviceStartedMessage,
          backgroundColor: Colors.green);
    }
  }

  FutureOr<void> _stopBackgroundService(
      ConnectivityStopEvent event, Emitter<ConnectivityState> emit) async {
    var res = await _stopConnectionUsecase.call(NoParams());
    if (res is DataSuccess) {
      AppConstWidget.toastMsg(
          msg: StringConstants.serviceStoppedMessage,
          backgroundColor: Colors.green);
    }
  }
}
