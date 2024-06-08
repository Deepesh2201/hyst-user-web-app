import 'package:flutter/material.dart';

import '../../util/dimensions.dart';

class ShiningContainer extends StatefulWidget {
  final bool inLeft;

  ShiningContainer({required this.inLeft});

  @override
  _ShiningContainerState createState() => _ShiningContainerState();
}

class _ShiningContainerState extends State<ShiningContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(widget.inLeft ? Dimensions.radiusSmall : 0),
          left: Radius.circular(widget.inLeft ? 0 : Dimensions.radiusSmall),
        ),
        gradient: LinearGradient(
          begin: Alignment(-1.0, -0.5),
          end: Alignment(2.0, -0.5),
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.3),
            Colors.transparent,
          ],
          stops: [0, 0.5, 1],
        ),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(50 * _animation.value, 0),
            child: child,
          );
        },
        child: Container(
          width: 100, // Adjust this as needed
          height: 40, // Adjust this as needed
        ),
      ),
    );
  }
}
