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
                    // First smaller box at a custom position
                    Positioned(
                      top: 250, // Distance from the top of the parent container
                      left: 25, // Distance from the left of the parent container
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
                    // Second smaller box at another position
                    Positioned(
                      top: 325,
                      left: 25,
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
                    // Third smaller box at yet another position
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
