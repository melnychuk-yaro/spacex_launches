import 'package:flutter/material.dart';

import '../../data/models/launch.dart';
import '../../data/repositories/notifications_repository.dart';

class NotifyButton extends StatefulWidget {
  final Launch launch;
  NotifyButton({required this.launch});

  @override
  _NotifyButtonState createState() => _NotifyButtonState();
}

class _NotifyButtonState extends State<NotifyButton> {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: CircleAvatar(
          radius: 26,
          backgroundColor: Color(0x77989898),
          child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.notifications_outlined),
            onPressed: () => NotificationsRepository().scheduleNotification(
              title: widget.launch.name,
              body: 'SpaceX will launch their rocket soon.',
              launchTimeUTC: widget.launch.launchTimeUTC,
            ),
          ),
        ),
      ),
    );
  }
}
