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
      : super(SubscribtionsState(<String>{}, SubscribtionsStatus.initial)) {
    loadExistingSubscribtions();
  }

  Future<void> loadExistingSubscribtions() async {
    emit(SubscribtionsState(
      state.subscribtions,
      SubscribtionsStatus.loading,
    ));
    final pendingNotificationRequests =
        await notificationsRepository.getPendingNotifications();
    emit(SubscribtionsState(
      pendingNotificationRequests,
      SubscribtionsStatus.loaded,
    ));
  }

  Future<void> toggleSubscribtion(Launch launch) async {
    try {
      emit(SubscribtionsState(
        state.subscribtions,
        SubscribtionsStatus.loading,
      ));
      final updatedSubs = Set<String>.from(state.subscribtions);
      if (updatedSubs.contains(launch.id)) {
        updatedSubs.remove(launch.id);
        notificationsRepository.cancelNotification(launch.id);
      } else {
        notificationsRepository.scheduleNotification(
          id: launch.id,
          title: launch.name,
          body: 'SpaceX will launch their rocket soon.',
          launchTimeUTC: launch.launchTimeUTC,
        );
        updatedSubs.add(launch.id);
      }
      notificationsRepository.getPendingNotifications();
      emit(SubscribtionsState(updatedSubs, SubscribtionsStatus.loaded));
    } on Failure {
      emit(SubscribtionsState(state.subscribtions, SubscribtionsStatus.error));
    }
  }
}
