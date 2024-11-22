import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/colors.dart';

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key,
        this.label,
        this.placeholder,
        this.icon,
        required this.controller});

  final String? label;
  final String? placeholder;
  final String? icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Visibility(
              visible: label != null,
              child: Text(
                label!,
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.grey.shade100,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  hintText: placeholder,
                  hintStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.grey.shade300
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: AppColors.primary,),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  prefixIcon: Visibility(
                    visible: icon != null,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image(
                        image: AssetImage(icon!),
                        height: 10,
                        width: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
