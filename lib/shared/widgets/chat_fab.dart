import 'package:flutter/material.dart';
import '../../../../core/theme/mifc_colors.dart';

class ChatFab extends StatelessWidget {
  const ChatFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: MifcColors.red,
      child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
    );
  }
}
