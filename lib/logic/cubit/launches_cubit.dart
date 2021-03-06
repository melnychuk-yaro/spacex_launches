import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/models/launch.dart';
import '../../data/repositories/launches_repository.dart';
import '../services/failure.dart';

part 'launches_state.dart';

class LaunchesCubit extends Cubit<LaunchesState> {
  final LaunchesRepository launchesRepo;
  LaunchesCubit(this.launchesRepo) : super(LaunchesInitial()) {
    loadLaunches();
  }

  void loadLaunches() async {
    try {
      emit(LaunchesLoading());
      final launches = await launchesRepo.loadLaunches();
      emit(LaunchesLoaded(launches));
    } on Failure {
      rethrow;
    }
  }
}
