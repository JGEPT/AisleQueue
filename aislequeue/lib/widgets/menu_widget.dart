import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final Offset buttonPosition = button.localToGlobal(Offset.zero);
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            buttonPosition.dx - 24.0,
            buttonPosition.dy + button.size.height,
            buttonPosition.dx + button.size.width,
            0.0,
          ),
          items: [
            PopupMenuItem(
              child: Container(
                width: 200,
                height: 850,
                color: Colors.grey[200], // Background color for visualization
                child: Stack(
                  children: [
                    Positioned(
                      top: 75,
                      left: 15,
                      child: Container(
                        width: 175,
                        height: 135,
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // First smaller box
                    Positioned(
                      top: 250,
                      left: 25,
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF006769),
                        ),
                        child: Center(
                          child: Text(
                            'Homepage',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Second smaller box (Legend)
                    Positioned(
                      top: 325,
                      left: 25,
                      child: InkWell(
                        onTap: () {
                          // Retrieve the button's position and size to calculate the menu position
                          final RenderBox button = context.findRenderObject() as RenderBox;
                          final Offset buttonPosition = button.localToGlobal(Offset.zero);
                          final RelativeRect position = RelativeRect.fromLTRB(
                            buttonPosition.dx - 24.0,
                            buttonPosition.dy + button.size.height,
                            buttonPosition.dx + button.size.width,
                            0.0,
                          );

                          // Call the reusable menu function
                          showCustomMenu(context, position);
                        },
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF006769),
                          ),
                          child: Center(
                            child: Text(
                              'Legend',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Third smaller box
                    Positioned(
                      top: 400,
                      left: 25,
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF006769),
                        ),
                        child: Center(
                          child: Text(
                            'Route',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              value: 1,
            ),
          ],
        );
      },
    );
  }
}

class InkWellWithMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 325,
      left: 25,
      child: InkWell(
        onTap: () {
          final RenderBox button = context.findRenderObject() as RenderBox;
          final Offset buttonPosition = button.localToGlobal(Offset.zero);
          final RelativeRect position = RelativeRect.fromLTRB(
            buttonPosition.dx - 24.0,
            buttonPosition.dy + button.size.height,
            buttonPosition.dx + button.size.width,
            0.0,
          );

          // Call the custom menu class
          showCustomMenu(context, position);
        },
        child: Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFF006769),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              "Open Menu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomMenu(BuildContext context, RelativeRect position) {
  showMenu(
    context: context,
    position: position,
    items: [
      PopupMenuItem(
        child: Container(
          width: 200, // Set width for the menu
          height: 800, // Set height for the menu
          color: Colors.grey[200],
          child: Stack( // Use Stack here to allow Positioned widgets
            children: [
              Positioned(
                top: 5,
                left: 0,
                child: Container(
                  width: 190,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Color(0xFF5A967A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        left: 10,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Color(0xFF006769),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Baking Needs",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 35,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Cleaning Aids",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 65,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Pastries",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 95,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '4',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Breads",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 125,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "White Rice",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 155,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '6',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Red & Brown rice",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 185,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '7',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Tomato Products",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 215,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '8',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Soy Sauces, Vinegars",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 245,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '9',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Condiments, Additives",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 275,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '10',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Preservatives, Canned Produce",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 305,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '11',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Canned Seafood, Dried Fish",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 335,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '12',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Pasta, Noodles, Bihon",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 365,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '13',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Olive Oils, Jarred Produce",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 395,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '14',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Cooking oil",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 425,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '15',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Shampoos",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 455,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '16',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Canned Meats",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 485,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '17',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Red & Brown rice",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 515,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '18',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Biscuits",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 545,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '19',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Menstrual Care Products",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 575,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '20',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Skincare Products",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 605,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '21',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Coffees",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 635,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '22',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Snacks",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 665,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '23',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Household Items",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 695,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '24',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Hand Soap, Liquid Soap",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 725,
                left: 0,
                child: Container(
                    width: 190,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              left: 10,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFF006769),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '25',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Center(
                            child: Text(
                              "Water Products",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              ),
              Positioned(
                top: 755,
                right: 2,
                child: GestureDetector(
                  onTap: () {
                    // Close the current menu (if it's open) and show the secondary menu
                    Navigator.of(context).pop(); // Close the current menu (pop from the stack)
                    // Now, show the secondary menu
                    final RenderBox button = context.findRenderObject() as RenderBox;
                    final Offset buttonPosition = button.localToGlobal(Offset.zero);
                    final RelativeRect position = RelativeRect.fromLTRB(
                      MediaQuery.of(context).size.width - 87, // Right-aligned
                      755, // Top position
                      200, // Padding from the right edge
                      0, // Bottom of the screen
                    );
                    // Call the function that shows the secondary menu
                    showSecondaryMenu(context, position);
                  },
                  child: Container(
                    width: 85,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A967A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        value: 1, // This is the menu item's value
      ),
    ],
  );
}

void showSecondaryMenu(BuildContext context, RelativeRect position) {
  showMenu(
    context: context,
    position: position,
    items: [
      PopupMenuItem(
        child: Container(
          width: 200,
          height: 850,
          color: Colors.grey[200],
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                ],
              ),
              Stack(
                children: [
                  Positioned(
                    top: 5,
                    left: 0,
                    child: Container(
                      width: 190,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(0xFF5A967A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 5,
                            left: 10,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Color(0xFF006769),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '26',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Deodorant",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 35,
                    left: 0,
                    child: Container(
                      width: 190,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(0xFF5A967A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 5,
                            left: 10,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Color(0xFF006769),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '27',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Toothpaste",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 65,
                    left: 0,
                    child: Container(
                      width: 190,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(0xFF5A967A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 5,
                            left: 10,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Color(0xFF006769),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '28',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Vegetables",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 95,
                    left: 0,
                    child: Container(
                      width: 190,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(0xFF5A967A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 5,
                            left: 10,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Color(0xFF006769),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '29',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Fruits",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 125,
                    left: 0,
                    child: Container(
                      width: 190,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(0xFF5A967A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 5,
                            left: 10,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Color(0xFF006769),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '30',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Ice Creams",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 155,
                    left: 0,
                    child: Container(
                      width: 190,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(0xFF5A967A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 5,
                            left: 10,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Color(0xFF006769),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '31',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Softdrinks and sodas",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 755,
                    right: 2,
                    child: GestureDetector(
                      onTap: () {
                        // Close the current menu (if it's open) and show the secondary menu
                        Navigator.of(context).pop(); // Close the current menu (pop from the stack)
                        // Now, show the secondary menu
                        final RenderBox button = context.findRenderObject() as RenderBox;
                        final Offset buttonPosition = button.localToGlobal(Offset.zero);
                        final RelativeRect position = RelativeRect.fromLTRB(
                          MediaQuery.of(context).size.width - 87, // Right-aligned
                          755, // Top position
                          200, // Padding from the right edge
                          0, // Bottom of the screen
                        );
                        // Call the function that shows the secondary menu
                        showCustomMenu(context, position);
                      },
                      child: Container(
                        width: 85,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Color(0xFF5A967A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Prev",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}




