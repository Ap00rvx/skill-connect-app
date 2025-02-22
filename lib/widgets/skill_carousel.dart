import 'package:flutter/material.dart';

class SkillCarousel extends StatefulWidget {
  const SkillCarousel({super.key});

  @override
  State<SkillCarousel> createState() => _SkillCarouselState();
}

class _SkillCarouselState extends State<SkillCarousel> {
  final elements = [
    {
      "title": "Data Engineering",
      "description": "Learn how to analyze and interpret complex data.",
      "avg_salary": "1.5M INR",
      "color": Colors.teal.shade700,
    },
    {
      "title": "Mobile App Development",
      "description":
          "Learn how to build mobile applications for Android and iOS devices.",
      "avg_salary": "1.2M INR",
      "color": Colors.green.shade700,
    },
    {
      "title": "Web Development",
      "description": "Learn how to build websites and web applications.",
      "avg_salary": "1M INR",
      "color": Colors.orange.shade700,
    },
    {
      "title": "Digital Marketing",
      "description":
          "Learn how to promote brands and products using online marketing.",
      "avg_salary": "800K INR",
      "color": Colors.blue.shade700,
    },
    {
      "title": "UI/UX Design",
      "description":
          "Learn how to design user interfaces and user experiences.",
      "avg_salary": "1M INR",
      "color": Colors.red.shade700,
    },
    {
      "title": "Cloud Computing",
      "description":
          "Learn how to deliver computing services over the internet.",
      "avg_salary": "1.2M INR",
      "color": Colors.purple.shade700,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: elements.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(7.0),
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints(maxWidth: 250),
                decoration: BoxDecoration(
                  color: (elements[index]["color"] as Color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(elements[index]["title"] as String,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(elements[index]["description"] as String,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.normal)),
                    const SizedBox(height: 10),
                    RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                            text: elements[index]["avg_salary"] as String,
                            style: TextStyle(
                                fontSize: 20,
                                color: elements[index]["color"] as Color,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "  Yearly",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.normal)),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
