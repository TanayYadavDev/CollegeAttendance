import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFFC4E1FF),
      elevation: 2,
      child: ListTile(
        leading: Icon(
          leading,
          color: const Color(0xFF174A73),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF123B63),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF52718D),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF174A73),
        ),
        onTap: onTap,
      ),
    );
  }
}