import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.teal),
        onPressed: () {},
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250, // Makes the container span the full width
            height: 25, // Adjust the height as needed
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/BannerLogo.png'),
                fit: BoxFit
                    .cover, // This ensures the image covers the entire container
              ),
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart, color: Colors.teal),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
