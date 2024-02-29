import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class NotificationModel {
  final String title;
  final String content;

  NotificationModel({required this.title, required this.content});
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [
    NotificationModel(
        title: 'New Gazzette Out !',
        content: 'The Parlimentary Gazzette was relseaed Today.'),
    NotificationModel(
        title: 'New NIC with a QR !',
        content:
            'Government is planning to establish a new NIC with a QR Code before 2025.'),
  ];
  List<NotificationModel> dismissedNotifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent, // Set to transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00A8E8), Color(0xFF01579B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var notification in notifications)
              NotificationCard(
                notification: notification,
                onMarkAsRead: () {
                  setState(() {
                    notifications.remove(notification);
                    dismissedNotifications.add(notification);
                  });
                },
              ),
            if (dismissedNotifications.isNotEmpty) ...[
              SizedBox(height: 16),
              UndoButton(
                onUndo: () {
                  setState(() {
                    var lastDismissed = dismissedNotifications.removeLast();
                    notifications.add(lastDismissed);
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onMarkAsRead;

  NotificationCard({required this.notification, required this.onMarkAsRead});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 8),
      color: Color(0xFF01579B),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    notification.content,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            ActionButtons(onMarkAsRead: onMarkAsRead),
          ],
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final VoidCallback onMarkAsRead;

  ActionButtons({required this.onMarkAsRead});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMarkAsRead,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.done,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class UndoButton extends StatelessWidget {
  final VoidCallback onUndo;

  UndoButton({required this.onUndo});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onUndo,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
      ),
      child: Text(
        'Undo',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationScreen(),
  ));
}
