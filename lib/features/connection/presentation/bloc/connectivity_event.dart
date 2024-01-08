part of 'connectivity_bloc.dart';

@immutable
sealed class ConnectivityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConnectivityInitEvent extends ConnectivityEvent {
  @override
  List<Object> get props => [];
}

class ConnectivityStartEvent extends ConnectivityEvent {
  @override
  List<Object> get props => [];
}

class ConnectivityStopEvent extends ConnectivityEvent {
  @override
  List<Object> get props => [];
}
