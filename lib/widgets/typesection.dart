import 'package:appointmentlksahansa/colors.dart';
import 'package:flutter/material.dart';

class TypeSection extends StatelessWidget {
  final List<String> imagePaths = [
    "images/mying1.jpg",
    "images/sahansa.jpg",
    "images/jesus.jpg",
    "images/king.jpg",
    // "images/mying1.jpg",
    //  "images/mying1.jpg",
  ];

  final List<String> cardTexts = [
    "NIC",
    "Passport",
    "License",
    "Pension",
    // "Medical",
    //  "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: 260,
                width: 150,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(0, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: pr2Color,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigate to a different page based on the index
                            switch (index) {
                              case 0:
                                Navigator.pushNamed(context, '/page1');
                                break;
                              case 1:
                                Navigator.pushNamed(context, '/page5');
                                break;
                              case 2:
                                Navigator.pushNamed(context, '/page3');
                                break;
                              case 3:
                                Navigator.pushNamed(context, '/page4');
                                break;
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              imagePaths[index],
                              height: 200,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Add dynamic text below the image
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cardTexts[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
