import 'package:appointmentlksahansa/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatelessWidget {
  List categoryNames = [
    "NIC",
    "Passport",
    "License",
    "Pension",
  ];

  List<Icon> categoryIcons = [
    Icon(MdiIcons.abacus, color: prColor, size: 30),
    Icon(MdiIcons.walletTravel, color: prColor, size: 30),
    Icon(MdiIcons.car, color: prColor, size: 30),
    Icon(MdiIcons.naturePeople, color: prColor, size: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0x427D9D),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    prColor.withOpacity(0.8),
                    prColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
