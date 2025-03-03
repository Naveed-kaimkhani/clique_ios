// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final String labelText;
//   final bool isPassword;
//   final TextEditingController controller;

//   const CustomTextField({
//     Key? key,
//     required this.labelText,
//     required this.controller,
//     this.isPassword = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             // gradient: AppColors.appGradientColors.withOpacity(0.3),
//             color: Colors.black.withAlpha(76),
//           ),
//           padding: EdgeInsets.all(2),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: TextField(
//               controller: controller,
//               obscureText: isPassword,
//               decoration: InputDecoration(
//                 labelText: labelText,
//                 labelStyle: TextStyle(color: Colors.black),
//                 border: InputBorder.none,
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 suffixIcon: isPassword ? Icon(Icons.visibility_off) : null,
//                 isDense: true,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black87, fontSize: 14),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffCCCCCC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffCCCCCC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffCCCCCC), width: 2),
          // borderSide: const BorderSide(color:Colors.grey, width: 2),
      
        ),
      ),
    );
  }
}