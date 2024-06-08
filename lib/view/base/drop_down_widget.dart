import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  // const DropDownWidget({Key key}) : super(key: key);
  const DropDownWidget();

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();

}

class _DropDownWidgetState extends State<DropDownWidget> {
  String _selectedValue = ''; // Initialize with an empty value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedValue,
              onChanged: (newValue) {
                setState(() {
                  _selectedValue = newValue!;
                });
              },
              items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Selected: $_selectedValue'),
          ],
        ),
      ),
    );
  }
}
