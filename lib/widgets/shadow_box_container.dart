import 'package:flutter/material.dart';

class ShadowBoxContainer extends StatelessWidget {
  const ShadowBoxContainer({super.key, required this.child, this.padding = 0, required this.height});
  final Widget child;
  final double padding;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
