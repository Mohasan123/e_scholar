import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearProgress extends StatefulWidget {
  const LinearProgress({super.key});

  @override
  State<LinearProgress> createState() => _LinearProgressState();
}

class _LinearProgressState extends State<LinearProgress> {
  late double _progressValue;

  @override
  void initState() {
    super.initState();
    _progressValue = 20.0;
  }

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      width: MediaQuery.of(context).size.width - 80,
      animation: true,
      lineHeight: 8.0,
      barRadius: const Radius.circular(20.0),
      percent: 0.7,
      progressColor: Colors.white,
    );
  }
}
