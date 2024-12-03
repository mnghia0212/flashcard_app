import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final double duration;
  final VoidCallback onComplete;
  final bool isAnswered;

  const ProgressBar({
    super.key,
    required this.duration,
    required this.onComplete,
    required this.isAnswered,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this, 
      duration: Duration(seconds: widget.duration.toInt())
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.linear),
    );

    // Start the animation immediately
    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !widget.isAnswered) {
        controller.stop();
        widget.onComplete();
      }

      // If answered, stop the animation
      if (widget.isAnswered) {
        controller.stop();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnswered != oldWidget.isAnswered) {
      if (widget.isAnswered) {
        controller.stop();
      } else {
        controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: animation.value,
      backgroundColor: Colors.grey[300],
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

