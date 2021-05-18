import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/launches_repository.dart';
import 'data/repositories/notifications_repository.dart';
import 'logic/cubit/launches_cubit.dart';
import 'view/widgets/launch_list_item.dart';

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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LaunchesRepository _launchesRepo = LaunchesRepository();
  late final LaunchesCubit _launchesCubit = LaunchesCubit(_launchesRepo);

  @override
  void initState() {
    super.initState();
    _launchesCubit.loadLaunches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LaunchesCubit, LaunchesState>(
        bloc: _launchesCubit,
        builder: (_, state) {
          if (state is LaunchesLoaded) {
            return state.launches.isEmpty
                ? Center(child: Text('No Launches Planned'))
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.launches.length,
                    itemBuilder: (_, i) {
                      return LaunchListItem(
                        image: i.isOdd
                            ? 'assets/images/launch_1.jpg'
                            : 'assets/images/launch_0.jpg',
                        launch: state.launches[i],
                      );
                    },
                  );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
