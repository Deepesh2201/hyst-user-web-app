import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Shining Discount Tag Example'),
      ),
      body: Center(
        child: ShiningDiscountTag(percentage: '10'),
      ),
    ),
  ));
}

class ShiningDiscountTag extends StatefulWidget {
  final String? percentage;

  const ShiningDiscountTag({Key? key, this.percentage}) : super(key: key);

  @override
  _ShiningDiscountTagState createState() => _ShiningDiscountTagState();
}

class _ShiningDiscountTagState extends State<ShiningDiscountTag> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.percentage != null && int.parse(widget.percentage!) > 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red, // Use your desired shining color here
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_animation.value), // Apply rotation to create the diagonal shining effect
                child: Text(
                  'Upto ${widget.percentage}% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
