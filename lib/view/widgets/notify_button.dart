import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/launch.dart';
import '../../logic/cubit/subscribtions_cubit.dart';

class NotifyButton extends StatelessWidget {
  final Launch launch;
  NotifyButton({required this.launch});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: BlocBuilder<SubscribtionsCubit, SubscribtionsState>(
          builder: (context, state) {
            print(state.subscribtions);
            return CircleAvatar(
              radius: 26,
              backgroundColor: Color(0x77989898),
              child: IconButton(
                color: state.subscribtions.contains(launch.id)
                    ? Colors.green
                    : Colors.white,
                icon: state.subscribtions.contains(launch.id)
                    ? Icon(Icons.notifications_active_outlined)
                    : Icon(Icons.notifications_outlined),
                onPressed: () => context
                    .read<SubscribtionsCubit>()
                    .toggleSubscribtion(launch),
              ),
            );
          },
        ),
      ),
    );
  }
}
