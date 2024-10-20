import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeedRecallModeStudy extends ConsumerStatefulWidget {
  final String? setId;
  const SpeedRecallModeStudy({super.key, required this.setId});

  @override
  ConsumerState<SpeedRecallModeStudy> createState() => _SpeedRecallModeStudyState();
}

class _SpeedRecallModeStudyState extends ConsumerState<SpeedRecallModeStudy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(widget.setId!),),);
  }
}
