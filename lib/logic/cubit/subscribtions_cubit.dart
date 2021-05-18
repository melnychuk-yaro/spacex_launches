import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/launch.dart';
import '../../data/repositories/notifications_repository.dart';
import '../services/failure.dart';
part 'subscribtions_state.dart';

class SubscribtionsCubit extends Cubit<SubscribtionsState> {
  final NotificationsRepository notificationsRepository;

  SubscribtionsCubit(this.notificationsRepository)
      : super(SubscribtionsState(<String>{}, SubscribtionsStatus.initial));

  void toggleSubscription(Launch launch) async {
    try {
      emit(
          SubscribtionsState(state.subscribtions, SubscribtionsStatus.loading));
      notificationsRepository.scheduleNotification(
          title: launch.name,
          body: 'SpaceX will launch their rocket soon.',
          launchTimeUTC: launch.launchTimeUTC);
      final updatedSubs = Set<String>.from(state.subscribtions);
      updatedSubs.contains(launch.id)
          ? updatedSubs.remove(launch.id)
          : updatedSubs.add(launch.id);
      emit(SubscribtionsState(updatedSubs, SubscribtionsStatus.loaded));
    } on Failure {
      rethrow;
    }
  }
}
