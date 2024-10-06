import 'package:flashcard_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField(
      {super.key,
      required this.labelText,
      this.controller,
      this.maxLines = 1,
      this.readOnly = false,
      required this.icon,
      this.filledColor = const Color(0xfff1f1f1),
      this.type = TextInputType.emailAddress,
      this.isPassword = false});

  final String labelText;
  final Widget icon;
  final TextEditingController? controller;
  final int? maxLines;
  final bool readOnly;
  final Color? filledColor;
  final TextInputType? type;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: type,
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.white,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: context.colorScheme.primary,
            )),
        filled: true,
        fillColor: filledColor,
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (value) {},
    );
  }
}
