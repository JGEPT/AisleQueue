import 'package:flutter/material.dart';

class ItemMenu extends StatelessWidget {
  final double top;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final String category; // New parameter for category name
  final List<Map<String, String>> items;
  final double categoryTop; // Customizable top position for category header
  final double itemTop; // Customizable top position for item list

  const ItemMenu({
    Key? key,
    required this.top,
    this.left,
    this.right,
    this.height = 350,
    this.width = 309,
    required this.category,
    required this.items,
    this.categoryTop = 32, // Default position for category
    this.itemTop = 87, // Default position for items
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: const Color(0xFFFDFDF8),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFF006769),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Stack(
          children: [
            // Header
            Positioned(
              left: 83,
              top: categoryTop, // Customizable top position for category
              child: Container(
                width: 150,
                height: 23,
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      category.toUpperCase(), // Dynamically use category name
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF006769),
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Item Stacks
            ...items.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, String> item = entry.value;

              return Positioned(
                left: 25,
                top: itemTop + (index * 50), // Customizable vertical spacing for items
                child: ItemStack(
                  itemName: item['name']!,
                  price: item['price']!,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ItemStack extends StatelessWidget {
  final String itemName;
  final String price;

  const ItemStack({
    Key? key,
    required this.itemName,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 264,
      height: 41,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F1DE),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Item Name and Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                Text(
                  itemName,
                  style: const TextStyle(
                    color: Color(0xFF006769),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.8,
                  ),
                ),
                // Price Row
                Row(
                  children: [
                    const Text(
                      'Php',
                      style: TextStyle(
                        color: Color(0xFF17A45B),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                    // Add to cart
                    const SizedBox(width: 15),
                    Container(
                      height: 12,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff006769),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          'add to cart',
                          style: TextStyle(
                            fontSize: 8,
                            fontFamily: 'Inter',
                            height: 1,
                            color: Color(0xFFFFF1DB),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Minus Button
                Padding(
                  padding: const EdgeInsets.only(top: 0), // Adjust vertical alignment
                  child: const Text(
                    '-',
                    style: TextStyle(
                      color: Color(0xFF006769),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Quantity
                const SizedBox(width: 8),
                const Text(
                  '0',
                  style: TextStyle(
                    color: Color(0xFF006769),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Plus Button
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.0), // Adjust vertical alignment
                  child: const Text(
                    '+',
                    style: TextStyle(
                      color: Color(0xFF006769),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
