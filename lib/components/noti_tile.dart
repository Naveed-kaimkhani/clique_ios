import 'package:clique/constants/app_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure this 
class NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  const NotificationTile({
    super.key,
    required this.title,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
      color: Colors.white,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            // padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
                     boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(31, 184, 177, 177),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
            ),
            child: Icon(Icons.notifications_outlined), 
            // SvgPicture.asset(
            //   AppSvgIcons.notiIcon,
            //   fit: BoxFit.contain,
            //   width: 32,
            //   height: 32,
            // ),
          ),
          title: Text(
            title.trim(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            message.trim(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          trailing: Text(
            time.trim(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}