import 'package:flutter/material.dart';

import '../../data/models/launch.dart';
import 'launch_list_item.dart';

class LaunchList extends StatelessWidget {
  final List<Launch> launches;

  LaunchList({
    Key? key,
    required this.launches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: launches.length,
          itemBuilder: (_, i) {
            return LaunchListItem(
              image: i.isOdd
                  ? 'assets/images/launch_1.jpg'
                  : 'assets/images/launch_0.jpg',
              launch: launches[i],
            );
          },
        ),
      ),
    );
  }
}
