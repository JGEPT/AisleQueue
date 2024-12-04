import 'package:flutter/material.dart';

class CategorySearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onFilterChanged;

  const CategorySearchBar({
    super.key, 
    required this.searchController, 
    required this.onFilterChanged
  });

  @override
  CategorySearchBarState createState() => CategorySearchBarState();
}

class CategorySearchBarState extends State<CategorySearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: widget.searchController,
          decoration: InputDecoration(
            hintText: 'Search categories...',
            prefixIcon: const Icon(Icons.search, color: Colors.green),
            suffixIcon: widget.searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.green),
                    onPressed: () {
                      widget.searchController.clear();
                      widget.onFilterChanged('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, 
              vertical: 12
            ),
          ),
          onChanged: widget.onFilterChanged,
        ),
      ),
    );
  }
}
