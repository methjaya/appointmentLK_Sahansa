import 'package:appointmentlksahansa/colors.dart';
import 'package:appointmentlksahansa/widgets/typesection.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatelessWidget {
  List<String> categoryNames = [
    "NIC",
    "Passport",
    "License",
    "Pension",
    "Medical",
  ];

  List<Image> categoryImages = [
    Image.asset("images/mying1.jpg", height: 30, width: 30),
    Image.asset("images/king.jpg", height: 30, width: 30),
    Image.asset("images/sahansa.jpg", height: 30, width: 30),
    Image.asset("images/jesus.jpg", height: 30, width: 30),
    Image.asset("images/mying1.jpg", height: 30, width: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromARGB(255, 216, 216, 216),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 1.3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  prColor,
                  Color.fromARGB(255, 46, 124, 208),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 1.5 - 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage("images/mying1.jpg"),
                          ),
                          Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 60,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Hi, Sahansa",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "All your Government \nService  Appointments at \nyour Fingertips.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15, bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              blurRadius: 6,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: " Search Here",
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Types",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 100,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryNames.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(0, 255, 255, 255),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: categoryImages[index],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            categoryNames[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text("Current Slots",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black26.withOpacity(0.7),
                      )),
                ),
                // Assuming TypeSection is implemented
                TypeSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
