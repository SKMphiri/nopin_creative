import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/colors.dart';

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key,
      this.label,
      this.placeholder,
      this.hint,
      this.iconUri,
      this.leadingIcon,
      this.iconSize = 14,
      required this.controller});

  final String? label;
  final String? placeholder;
  final String? hint;
  final String? iconUri;
  final Icon? leadingIcon;
  final double? iconSize;
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
                label != null ? label! : "",
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.grey.shade200,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: hint ?? placeholder,
                    hintStyle: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.grey.shade400),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AppColors.primary,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: leadingIcon ??
                        (iconUri != null
                            ? Padding(
                                padding: EdgeInsets.all((1 / iconSize!) * 80),
                                child: Image(
                                  image: AssetImage(iconUri!),
                                  height: iconSize,
                                  width: iconSize,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : null),
                    contentPadding: EdgeInsets.zero),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
