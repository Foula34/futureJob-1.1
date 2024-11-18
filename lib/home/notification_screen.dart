import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:future_job/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<AppNotification> notifications = [
    AppNotification(
      id: 'notif1',
      userId: 'user1',
      title: 'Nimba Hub Notification',
      body: 'Vous avez reçu une notification de la part de Nimba hub',
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    ),
    AppNotification(
      id: 'notif2',
      userId: 'user2',
      title: 'Nimba Hub Notification',
      body: 'Vous avez reçu une notification de la part de Nimba hub',
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: GoogleFonts.roboto(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 25.0,
                        backgroundImage: AssetImage('assets/images/me.jpg'),
                      ),
                      title: Text(
                        notification.title, // Titre de la notification
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.body,
                            style: GoogleFonts.roboto(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '${notification.timestamp.hour}:${notification.timestamp.minute.toString().padLeft(2, '0')}',
                            style: GoogleFonts.roboto(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.notifications,
                        color: Colors.blueAccent,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
