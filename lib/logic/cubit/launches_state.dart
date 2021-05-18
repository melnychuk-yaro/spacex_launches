part of 'launches_cubit.dart';

@immutable
abstract class LaunchesState extends Equatable {}

class LaunchesInitial extends LaunchesState {
  @override
  List<Object> get props => [];
}

class LaunchesLoading extends LaunchesState {
  @override
  List<Object> get props => [];
}

class LaunchesLoaded extends LaunchesState {
  final List<Launch> launches;

  LaunchesLoaded(this.launches);

  @override
  List<Object> get props => [launches];
}

class LaunchesError extends LaunchesState {
  final String error;

  LaunchesError(this.error);

  @override
  List<Object> get props => [error];
}
