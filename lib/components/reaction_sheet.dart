import 'package:flutter/material.dart';

// class ReactionSheet extends StatelessWidget {
//   final void Function(String) onReactionSelected;

//   const ReactionSheet({super.key, required this.onReactionSelected});

//   @override
//   Widget build(BuildContext context) {
//     final reactions = ['❤️', '😂', '👍', '😢', '😮', '😡']; // Customize as needed
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Wrap(
//         children: reactions.map((reaction) {
//           return GestureDetector(
//             onTap: () => onReactionSelected(reaction),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(reaction, style: TextStyle(fontSize: 28)),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

class ReactionSheet extends StatelessWidget {
  final void Function(String) onReactionSelected;

  const ReactionSheet({super.key, required this.onReactionSelected});

  @override
  Widget build(BuildContext context) {
    final reactions = ['❤️', '😂', '👍', '😢', '😮', '🔥'];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions.map((emoji) {
          return GestureDetector(
            onTap: () => onReactionSelected(emoji),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
