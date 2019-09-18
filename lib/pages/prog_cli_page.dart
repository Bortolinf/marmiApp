import 'package:flutter/material.dart';
import 'package:marmi_app/widgets/calendar_cli.dart';

class ProgrCliPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Programação do Cliente"),),
      body: CalendarCli(),
    
    );
  }
}