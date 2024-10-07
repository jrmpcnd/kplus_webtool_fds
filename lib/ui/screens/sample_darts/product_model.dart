class Product {
  final String name;
  final String category;
  final double price;

  Product(this.name, this.category, this.price);

  // Format the price as a string with two decimal places
  String get formattedPrice => price.toStringAsFixed(2);
}

final List<Product> productList = [
  // Fruits
  Product('Apple', 'Fruit', 50.0),
  Product('Banana', 'Fruit', 30.0),
  Product('Orange', 'Fruit', 40.0),
  Product('Grapes', 'Fruit', 60.0),
  Product('Strawberry', 'Fruit', 70.0),

  // Vegetables
  Product('Carrot', 'Vegetable', 20.0),
  Product('Broccoli', 'Vegetable', 50.0),
  Product('Spinach', 'Vegetable', 25.0),
  Product('Potato', 'Vegetable', 15.0),
  Product('Tomato', 'Vegetable', 18.0),

  // Grains
  Product('Rice', 'Grain', 60.0),
  Product('Wheat', 'Grain', 55.0),
  Product('Oats', 'Grain', 80.0),
  Product('Barley', 'Grain', 65.0),
  Product('Quinoa', 'Grain', 100.0),

  // Canned
  Product('555 Tuna', 'Canned', 45.0),
  Product('Lucky Sardines', 'Canned', 40.0),
  Product('Lucky 7 Corned Beef', 'Canned', 35.0),
  Product('Green Peas', 'Canned', 30.0),
  Product('Saba Mackerel', 'Canned', 50.0),

  // Bread
  Product('White Bread', 'Bread', 25.0),
  Product('Whole Wheat Bread', 'Bread', 30.0),
  Product('Bagel', 'Bread', 15.0),
  Product('Croissant', 'Bread', 20.0),
  Product('Baguette', 'Bread', 18.0),

  // Beverages
  Product('Coca-Cola Zero', 'Beverages', 25.0),
  Product('Pocari Sweat', 'Beverages', 30.0),
  Product('Vitamilk Double Choco', 'Beverages', 20.0),
  Product('Selecta Sterilized Milk', 'Beverages', 35.0),
  Product('C2 Apple', 'Beverages', 45.0),

  // Dairy
  Product('Milk', 'Dairy', 35.0),
  Product('Cheese', 'Dairy', 60.0),
  Product('Butter', 'Dairy', 50.0),
  Product('Yogurt', 'Dairy', 40.0),
  Product('Cream', 'Dairy', 45.0),

  // Detergent
  Product('Laundry Detergent', 'Detergent', 70.0),
  Product('Dishwasher Detergent', 'Detergent', 65.0),
  Product('Fabric Softener', 'Detergent', 55.0),
  Product('Bleach', 'Detergent', 50.0),
  Product('Stain Remover', 'Detergent', 60.0),

  // Personal Hygiene
  Product('Toothpaste', 'Personal Hygiene', 25.0),
  Product('Shampoo', 'Personal Hygiene', 30.0),
  Product('Soap', 'Personal Hygiene', 20.0),
  Product('Deodorant', 'Personal Hygiene', 35.0),
  Product('Toothbrush', 'Personal Hygiene', 15.0),

  // Beauty Products
  Product('Lipstick', 'Beauty Products', 50.0),
  Product('Foundation', 'Beauty Products', 70.0),
  Product('Mascara', 'Beauty Products', 60.0),
  Product('Eye Shadow', 'Beauty Products', 40.0),
  Product('Blush', 'Beauty Products', 55.0),
];

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;
  double total;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  }) : total = price * quantity;

  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
    total = price * quantity;
  }
}
