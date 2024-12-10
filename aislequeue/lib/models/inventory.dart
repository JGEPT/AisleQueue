class Inventory {
  int id;
  int aisleId;
  String productName;
  int quantity;

  Inventory({
    required this.id,
    required this.aisleId,
    required this.productName,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aisleId': aisleId,
      'productName': productName,
      'quantity': quantity,
    };
  }

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      aisleId: json['aisleId'],
      productName: json['productName'],
      quantity: json['quantity'],
    );
  }
}
