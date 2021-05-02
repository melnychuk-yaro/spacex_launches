import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/launches_repository.dart';
import 'logic/cubit/launches_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
      appBar: AppBar(title: Text('SpaceX Launches')),
      body: BlocBuilder<LaunchesCubit, LaunchesState>(
        bloc: _launchesCubit,
        builder: (_, state) {
          if (state is LaunchesLoaded) {
            return state.launches.isEmpty
                ? Center(child: Text('No Launches Planned'))
                : ListView.builder(
                    itemCount: state.launches.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        title: Text(state.launches[i].name),
                        subtitle: Text(state.launches[i].dateTime),
                      );
                    },
                  );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
