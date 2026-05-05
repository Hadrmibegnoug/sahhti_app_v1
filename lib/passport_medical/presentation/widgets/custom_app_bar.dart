import 'package:flutter/material.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(130);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [BoxShadow(blurRadius: 20.0, offset: Offset(0, 2))],
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                //SizedBox(height: 2),
                Text(
                  "jeudi 12 mars 2026",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withOpacity(0.2),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.24),
          Expanded(
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  splashColor: AppColors.border,
                  child: CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.language,
                      size: 30,
                      color: AppColors.notfication,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  splashColor: AppColors.primaryBorder,
                  child: CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.notifications,
                      size: 30,
                      color: AppColors.language,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
