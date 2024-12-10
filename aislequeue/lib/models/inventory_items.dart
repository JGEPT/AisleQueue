class InventoryItem {
  String id; // Unique identifier
  String name;
  int quantity;
  double price;

  InventoryItem({
    String? id,
    required this.name,
    required this.quantity,
    required this.price,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'price': price,
  };

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
    id: json['id'],
    name: json['name'],
    quantity: json['quantity'],
    price: json['price'],
  );
}
