import 'package:flutter/material.dart';
import 'package:aislequeue/widgets/menu_widget.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xffFDFDF8),
        appBar: AppBar(
          backgroundColor: Color(0xffFDFDF8), // same color sa bg
        ),
        body: Stack(
          children: [
            // Menu Icon
            Positioned(
              top: 10,
              left: 20,
              child: CustomMenu(),
            ),
            // Search Bar
            Positioned(
              top: 13,
              left: 104,
              child: Container(
                height: 19,
                width: 210,
                decoration: BoxDecoration(
                  color: Color(0xff9AC9B1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            // Cart Icon
            Positioned(
              top: 13,
              right: 20,
              child: Icon(Icons.shopping_cart),
            ),
            //Stand Alone Component
            //32
            Positioned(
              top: 65,
              left: 265,
              child: Container(
                height: 30,
                width: 95,
                color: Color(0xff5A967A),
              ),
            ),
            //33
            Positioned(
              top: 65,
              left: 150,
              child: Container(
                height: 30,
                width: 85,
                color: Color(0xff5A967A),
              ),
            ),
            //34
            Positioned(
              top: 65,
              left: 0,
              child: Container(
                height: 90,
                width: 30,
                color: Color(0xff5A967A),
              ),
            ),
            //34
            Positioned(
              top: 65,
              left: 30,
              child: Container(
                height: 30,
                width: 75,
                color: Color(0xff5A967A),
              ),
            ),
            //36
            Positioned(
              bottom: 65,
              left: 0,
              child: Container(
                height: 155,
                width: 30,
                color: Color(0xff5A967A),
              ),
            ),

            // Aisle Boxes 1-10
            AisleBox(top: 365, left: 55),  // Box 1 415
            AisleBox(top: 340, left: 55),  // Box 2
            AisleBox(top: 365, right: 60), // Box 3
            AisleBox(top: 340, right: 60), // Box 4
            AisleBox(top: 425, left: 55),  // Box 5
            AisleBox(top: 400, left: 55),  // Box 6 450
            AisleBox(top: 425, right: 60), // Box 7
            AisleBox(top: 400, right: 60), // Box 8
            AisleBox(top: 485, left: 55),  // Box 9
            AisleBox(top: 460, left: 55),  // Box 10
            AisleBox(top: 485, right: 60), // Box 11
            AisleBox(top: 460, right: 60), // Box 12
            AisleBox(top: 545, left: 55),  // Box 13
            AisleBox(top: 520, left: 55),  // Box 14
            AisleBox(top: 545, right: 60),  // Box 15
            AisleBox(top: 520, right: 60),  // Box 16
            //Bottom Aisle
            AisleBox(bottom: 70, left: 50),  // Box 17
            AisleBox(bottom: 95, left: 50),  // Box 18
            AisleBox(bottom: 70, right: 60),  // Box 19
            AisleBox(bottom: 95, right: 60),  // Box 20
            AisleBox(bottom: 15, left: 50),  // Box 21
            AisleBox(bottom: 40, left: 50),  // Box 22
            AisleBox(bottom: 15, right: 60),  // Box 23
            AisleBox(bottom: 40, right: 60),  // Box 24
            // Center Boxes
            CenterAisle(top: 230, right: 80),  // Box 28 (Center)
            CenterAisle(top: 150, right: 80),  // Box 29 (Center)
            CenterAisle(top: 230, left: 110),  // Box 30 (Center)
            CenterAisle(top: 150, left: 110),  // Box 31 (Center)
            //Left boxes 35
            LeftBox(top: 195, left: 0),  // Box 35.1
            LeftBox(top: 245, left: 0),  // Box 35.2
            LeftBox(top: 295, left: 0),  // Box 35.3
            LeftBox(top: 345, left: 0),  // Box 35.4
            LeftBox(top: 395, left: 0),  // Box 35.5
            //Right Box
            RightBox(bottom: 80, right: 0),  // Box 37.1
            RightBox(bottom: 145, right: 0),  // Box 37.2
            RightBox(bottom: 210, right: 0),  // Box 37.3
            RightBox(bottom: 275, right: 0),  // Box 37.4
            //Bottom Box 25
            BottomBox(bottom: 190, left: 45),  // Box 25.1
            BottomBox(bottom: 145, left: 45),  // Box 25.2
            BottomBox(bottom: 190, left: 125),  // Box 25.3
            BottomBox(bottom: 145, left: 125),  // Box 25.4
            //
            BottomBox(bottom: 190, right: 50),  // Box 27.1
            BottomBox(bottom: 145, right: 50),  // Box 27.2
            BottomBox(bottom: 190, right: 130),  // Box 26.1
            BottomBox(bottom: 145, right: 130),  // Box 26.1
            //Circle
            CircleNum(top: 365, left: 45, number: '1'),
            CircleNum(top: 330, left: 170, number: '2'),
            CircleNum(top: 365, right: 170, number: '3'),
            CircleNum(top: 330, right: 45, number: '4'),
            CircleNum(top: 425, left: 45, number: '5'),
            CircleNum(top: 390, left: 170, number: '6'),
            CircleNum(top: 425, right: 170, number: '7'),
            CircleNum(top: 390, right: 45, number: '8'),
            CircleNum(top: 485, left: 45, number: '9'),
            CircleNum(top: 450, left: 170, number: '10'),
            CircleNum(top: 485, right: 170, number: '11'),
            CircleNum(top: 450, right: 45, number: '12'),
            CircleNum(top: 545, left: 45, number: '13'),
            CircleNum(top: 510, left: 170, number: '14'),
            CircleNum(top: 545, right: 170, number: '15'),
            CircleNum(top: 510, right: 45, number: '16'),
            CircleNum(bottom: 63, left: 35, number: '17'),
            CircleNum(bottom: 100, left: 160, number: '18'),
            CircleNum(bottom: 100, right: 45, number: '20'),
            CircleNum(bottom: 63, right: 170, number: '19'),
            CircleNum(bottom: 10, left: 35, number: '21'),
            CircleNum(bottom: 38, left: 160, number: '22'),
            CircleNum(bottom: 10, right: 170, number: '23'),
            CircleNum(bottom: 38, right: 45, number: '24'),
            CircleNum(bottom: 170, left:  100, number: '25'),
            CircleNum(bottom: 145, right: 105, number: '26'),
            CircleNum(bottom: 190, right: 105, number: '27'),
            CircleNum(top: 140, right: 60, number: '28'),
            CircleNum(top: 220, right: 60, number: '29'),
            CircleNum(top: 220, left: 100, number: '30'),
            CircleNum(top: 140, left: 100, number: '31'),
            CircleNum(top: 60, right: 30, number: '32'),
            CircleNum(top: 60, right: 160, number: '33'),
            CircleNum(top: 60, left: 90, number: '34'),
            CircleNum(top: 303, left: 15, number: '35'),
            CircleNum(bottom: 120, left: 10, number: '36'),
            CircleNum(bottom: 195, right: 0, number: '37'),



          ],
       ),
      ),
    );
  }
}
//-----------------------------------
// Custom Widget for Aisle Boxes
class AisleBox extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final Color color;

  const AisleBox({
    Key? key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.height = 20,
    this.width = 130,
    this.color = const Color(0xff5A967A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        height: height,
        width: width,
        color: color,
      ),
    );
  }
}

// Custom Widget for Center Boxes
class CenterAisle extends StatelessWidget {
  final double top;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final Color color;

  const CenterAisle({
    Key? key,
    required this.top,
    this.left,
    this.right,
    this.height = 65, // Default center box height
    this.width = 100, // Default center box width
    this.color = const Color(0xff5A967A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        height: height,
        width: width,
        color: color,
      ),
    );
  }
}
// Custom Widget for Left
class LeftBox extends StatelessWidget {
  final double top;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final Color color;

  const LeftBox({
    Key? key,
    required this.top,
    this.left,
    this.right,
    this.height = 45, // Default center box height
    this.width = 30, // Default center box width
    this.color = const Color(0xff5A967A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        height: height,
        width: width,
        color: color,
      ),
    );
  }
}
// Custom Widget for Right
class RightBox extends StatelessWidget {
  final double bottom;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final Color color;

  const RightBox({
    Key? key,
    required this.bottom,
    this.left,
    this.right,
    this.height = 60 , // Default center box height
    this.width = 30, // Default center box width
    this.color = const Color(0xff5A967A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        height: height,
        width: width,
        color: color,
      ),
    );
  }
}

// Custom Widget for Bottom Boxes
class BottomBox extends StatelessWidget {
  final double bottom;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final Color color;

  const BottomBox({
    Key? key,
    required this.bottom,
    this.left,
    this.right,
    this.height = 30,
    this.width = 60,
    this.color = const Color(0xff5A967A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        height: height,
        width: width,
        color: color,
      ),
    );
  }
}
//Circle
class CircleNum extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final Color color;
  final String number; // Add a parameter to hold the number

  const CircleNum({
    Key? key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.height = 30,
    this.width = 30,
    this.color = const Color(0xff006769),
    required this.number, // Make sure the number is required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: Text(
            number, // The number inside the circle
            style: TextStyle(
              color: Color(0xffFFF1DB),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        // Define menu button behavior here
      },
    );
  }
}