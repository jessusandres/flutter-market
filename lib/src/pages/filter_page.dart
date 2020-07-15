import 'package:flutter/material.dart';

class FilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final type = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        elevation: 0,
        leading:IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54,),
          onPressed: ()=>Navigator.pop(context),
        )
      ),
      body: Container(
        color: Colors.white60,
        child: Center(
          child: Text('FilterPage for : $type'),
        ),
      ),
    );
  }
}