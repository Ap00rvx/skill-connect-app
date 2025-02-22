import 'package:flutter/material.dart';

class HeroContainer extends StatelessWidget {
  const HeroContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blueAccent, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: const Offset(0.0, 1), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      height: 200,
      child: Row(
        children: [
          Image.asset(
            "assets/images/man.png",
            width: 160,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Connect. \nCollaborate.\nGrow.",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                      "Where skills ignite opportunities and growth knows no bounds.",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade300,
                          fontWeight: FontWeight.normal)),
                ]),
          ),
        ],
      ),
    );
  }
}
