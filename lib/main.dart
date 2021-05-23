import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/launches_repository.dart';
import 'data/repositories/notifications_repository.dart';
import 'logic/cubit/launches_cubit.dart';
import 'logic/cubit/subscribtions_cubit.dart';
import 'view/widgets/launch_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsRepository().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final LaunchesRepository _launchesRepo = LaunchesRepository();
  final NotificationsRepository _notifyRepo = NotificationsRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LaunchesCubit>(
          create: (_) => LaunchesCubit(_launchesRepo),
        ),
        BlocProvider<SubscribtionsCubit>(
          create: (_) => SubscribtionsCubit(_notifyRepo),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<LaunchesCubit, LaunchesState>(
          builder: (_, state) {
            if (state is LaunchesLoaded) {
              return state.launches.isEmpty
                  ? Center(child: Text('No Launches Planned'))
                  : LaunchList(launches: state.launches);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
