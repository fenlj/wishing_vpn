import 'dart:async';

import 'package:flutter/material.dart';

class AutoProgressBar extends StatefulWidget {
  final Duration firstStageTime;
  final Duration maxWaitTime;
  final double firstStageProgress;
  final VoidCallback? onFirstStageComplete;
  final VoidCallback? onComplete;
  final bool isEnableShow;

  const AutoProgressBar({
    super.key,
    this.firstStageTime = const Duration(seconds: 2),
    this.maxWaitTime = const Duration(seconds: 1),
    this.firstStageProgress = 0.8,
    this.onFirstStageComplete,
    this.onComplete,
    this.isEnableShow = true,
  });

  @override
  State<AutoProgressBar> createState() => AutoProgressBarState();
}

class AutoProgressBarState extends State<AutoProgressBar> {
  double _progress = 0.0;
  bool _firstStageComplete = false;
  Timer? _firstStageTimer;
  Timer? _maxWaitTimer;
  Timer? _secondStageTimer;

  @override
  void initState() {
    super.initState();
    _startFirstStage();
  }

  void _startFirstStage() {
    final interval = widget.firstStageTime.inMilliseconds ~/ 60;
    _firstStageTimer =
        Timer.periodic(Duration(milliseconds: interval), (timer) {
      setState(() {
        _progress += widget.firstStageProgress / 60;
        if (_progress >= widget.firstStageProgress) {
          _progress = widget.firstStageProgress;
          _firstStageComplete = true;
          timer.cancel();
          widget.onFirstStageComplete?.call();
          _startMaxWaitTimer();
        }
      });
    });
  }

  void _startMaxWaitTimer() {
    _maxWaitTimer = Timer(widget.maxWaitTime, () {
      if (_firstStageComplete && _progress < 1.0) {
        completeProgress();
      }
    });
  }

  void completeProgress() {
    if (!_firstStageComplete) return;
    _maxWaitTimer?.cancel();

    final interval = const Duration(seconds: 1).inMilliseconds ~/ 60;
    _secondStageTimer =
        Timer.periodic(Duration(milliseconds: interval), (timer) {
      setState(() {
        _progress += (1.0 - widget.firstStageProgress) / 60;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
          widget.onComplete?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _firstStageTimer?.cancel();
    _maxWaitTimer?.cancel();
    _secondStageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEnableShow
        ? LinearProgressIndicator(
            value: _progress,
            backgroundColor: Color(0xff2B3378),
            borderRadius: BorderRadius.circular(10),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffFFF76D)),
          )
        : SizedBox.shrink();
  }
}
