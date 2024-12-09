import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({Key? key}) : super(key: key);

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
                          // Functionality to summon another menu
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
                                  color: Colors.grey[200],
                                  child: Stack(
                                    // Use Stack here to allow Positioned widgets
                                    children: [
                                      Positioned(
                                        top: 5,
                                        left: 0,
                                        child: Container(
                                          width: 190,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF5A967A),
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 65,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 95,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 125,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 155,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 185,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 215,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 245,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 275,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 305,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 335,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 365,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 395,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 425,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 455,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 485,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 515,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 545,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 575,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 605,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 635,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 665,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 695,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 725,
                                        left: 0,
                                        child: Container(
                                            width: 190,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
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
                                            ])),
                                      ),
                                      Positioned(
                                        top: 755,
                                        right: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Close the old menu and open the new one
                                            Navigator.of(context)
                                                .pop(); // Close the current menu (pop from the stack)
                                            showMenu(
                                              context: context,
                                              position: RelativeRect.fromLTRB(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    87, // Right-aligned
                                                755, // Top position
                                                200, // Padding from the right edge
                                                0, // Bottom of the screen
                                              ),
                                              items: [
                                                PopupMenuItem(
                                                  child: Container(
                                                    width: 200,
                                                    height: 850,
                                                    color: Colors.grey[
                                                        300], // Different background for the new menu
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "This is the Next Menu",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        SizedBox(height: 20),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the new menu if needed
                                                          },
                                                          child: Text("Close"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  value: 1,
                                                ),
                                              ],
                                            );
                                          },
                                          child: Container(
                                            width: 85,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5A967A),
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
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
