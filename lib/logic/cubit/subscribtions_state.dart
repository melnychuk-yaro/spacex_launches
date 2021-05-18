part of 'subscribtions_cubit.dart';

enum SubscribtionsStatus { initial, loading, loaded, error }

@immutable
class SubscribtionsState extends Equatable {
  final List<String> subscribtions;
  final SubscribtionsStatus status;

  SubscribtionsState(this.subscribtions, this.status);

  @override
  List<Object> get props => [subscribtions];
}
