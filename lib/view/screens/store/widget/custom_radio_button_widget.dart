import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final int? value;
  final int? groupValue;
  final ValueChanged<int?>? onChanged;

  CustomRadio({
    this.value,
    this.groupValue,
    this.onChanged,
  });

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged!(widget.value);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.value == widget.groupValue ? Colors.green : Colors.white, // Change color here
          border: Border.all(
            color: Colors.green, // Change border color here
            width: 2.0,
          ),
        ),
        child: widget.value == widget.groupValue
            ? Icon(
          Icons.check,
          size: 24.0,
          color: Colors.white, // Change checkmark color here
        )
            : Container(),
      ),
    );
  }
}
