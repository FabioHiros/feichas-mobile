class GroceryItem {
  final int id;
  final String name;
  final double quantity;
  final String unit;
  final String category;
  final bool bought;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.bought,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'] as int,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
      bought: json['bought'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'category': category,
        'bought': bought,
      };

  GroceryItem copyWith({
    int? id,
    String? name,
    double? quantity,
    String? unit,
    String? category,
    bool? bought,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      bought: bought ?? this.bought,
    );
  }
}
