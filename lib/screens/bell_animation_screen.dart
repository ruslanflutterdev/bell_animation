import 'package:flutter/material.dart';

class BellAnimationScreen extends StatefulWidget {
  const BellAnimationScreen({super.key});

  @override
  _BellAnimationScreen createState() => _BellAnimationScreen();
}

class _BellAnimationScreen extends State<BellAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _repeatCount = 0;
  final int _maxRepeats = 6;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    double maxAngle = 1.0;

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -maxAngle),
        weight: 33.3,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -maxAngle, end: maxAngle),
        weight: 33.3,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: maxAngle, end: 0.0),
        weight: 33.4,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _repeatCount++;
        if (_repeatCount < _maxRepeats) {
          _controller.forward(from: 0.0);
        } else {
          _repeatCount = 0;
          _controller.stop();
        }
      }
    });
  }

  void _onIconTapped() {
    if (!_controller.isAnimating) {
      _repeatCount = 0;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _onIconTapped,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (_, _) {
            return Transform.rotate(
              angle: _animation.value,
              alignment: Alignment.topCenter,
              child: Icon(
                Icons.notifications,
                size: 120,
                color: Colors.greenAccent,
              ),
            );
          },
        ),
      ),
    );
  }
}
