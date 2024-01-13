import 'package:appointmentlksahansa/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OpenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0XFFD9E4EE),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.16,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/mying1.jpg"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    prColor.withOpacity(0.8),
                    prColor.withOpacity(0),
                    prColor.withOpacity(0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            int index = 0;
                            switch (index) {
                              case 0:
                                Navigator.pushNamed(context, '/page3');
                                break;
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(15, 0, 0, 0),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: prColor,
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back,
                              ),
                            ),
                          ),
                        ),
                        /* Right icon (I just commented if needed)
                        Container(
                          margin: EdgeInsets.all(8),
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(15, 0, 0, 0),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: prColor,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.favoritw_outline,
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "NIC Renewal",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: whiteColor,
                                ),
                              ),
                              // SizedBox(height: 10),
                              Text(
                                "Colombo",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: whiteColor,
                                ),
                              )
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "April 22nd",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 31, 100, 169),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      MdiIcons.book,
                      color: Color.fromARGB(255, 31, 100, 169),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "April 22nd",
                      style: TextStyle(
                        fontSize: 17,
                        color: blackColor.withOpacity(0.6),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "Things you need to bring for the Renewal: \n* Birth Certificate\n* OLD NIC if not a Police Complaint",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 15),
                Text(
                  "Reserve Date",
                  style: TextStyle(
                    fontSize: 18,
                    color: blackColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
