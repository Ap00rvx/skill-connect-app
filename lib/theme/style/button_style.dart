import 'package:flutter/material.dart';

final buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blueAccent,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
  textStyle: const TextStyle(fontSize: 16),
  fixedSize: const Size(double.infinity, 50),
  minimumSize:const  Size(400, 60),
  
);


