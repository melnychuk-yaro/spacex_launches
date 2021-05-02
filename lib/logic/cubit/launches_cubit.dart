import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/launch.dart';
import '../../data/repositories/launches_repository.dart';

part 'launches_state.dart';

class LaunchesCubit extends Cubit<LaunchesState> {
  final LaunchesRepository launchesRepo;
  LaunchesCubit(this.launchesRepo) : super(LaunchesInitial());

  void loadLaunches() async {
    try {
      emit(LaunchesLoading());
      final launches = await launchesRepo.loadLaunches();
      emit(LaunchesLoaded(launches));
    } catch (e) {
      print(e);
    }
  }
}
