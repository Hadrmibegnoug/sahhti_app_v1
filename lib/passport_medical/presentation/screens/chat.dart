import 'package:flutter/material.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            customChat(context, "Dr. John Doe", "3"),
            customChat(context, "Dr. Jane Smith", "1"),
            customChat(context, "Dr. Emily Davis", "5"),
          ],
        ),
      ),
    );
  }

  InkWell customChat(
    BuildContext context,
    String doctorName,
    String notificationCount,
  ) {
    return InkWell(
      onTap: () {},
      splashColor: AppColors.primary.withOpacity(0.2),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.1,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(blurRadius: 5, color: Colors.black, offset: Offset(3, 0)),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: AppColors.primary.withOpacity(0.5),
              child: Icon(Icons.person, color: AppColors.primary),
            ),
            SizedBox(width: 10),
            Text(
              doctorName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            CircleAvatar(
              maxRadius: 15,
              backgroundColor: AppColors.primary,
              child: Text(
                notificationCount,
                style: TextStyle(fontSize: 15, color: AppColors.background),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
