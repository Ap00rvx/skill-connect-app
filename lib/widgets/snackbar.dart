import 'package:flutter/material.dart';

void showSnackbar(String message, bool isError, BuildContext context ,{bool top = false}) {
  // top is used to show the snackbar at the top of the screen
  
  ScaffoldMessenger.of(context).showSnackBar(
    
    SnackBar(

      content: Text(message,style:const TextStyle(
        color: Colors.white

      ),),
      backgroundColor: isError ? Colors.red : Colors.blue,
      
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: "Dismiss",
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        textColor: Colors.white,
      ),
    ),
  );
}
