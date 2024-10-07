import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/sample_darts/product_model.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/sample_darts/product_quantity_buttons.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/buttons/button.dart';

class ProductListPage extends StatefulWidget {
  final Function(CartItem) onAddToCart;
  final Function(String) onRemoveFromCart; // New callback to handle item removal

  const ProductListPage({required this.onAddToCart, Key? key, required this.onRemoveFromCart}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<String> categories = ['All', 'Fruit', 'Vegetable', 'Grain', 'Canned', 'Bread', 'Beverages', 'Dairy', 'Detergent', 'Personal Hygiene', 'Beauty Products']; //Create an array for filter chips, corresponds to the categories from the model
  List<String> selectedCategories = ['All']; //Array to store the selected categories
  List<CartItem> cartItems = []; //Array to store the items to be added to cart/package
  Map<String, int> productQuantities = {}; // Map to store quantities for each product
  Map<String, bool> isButtonDisabled = {}; // Track button state for each product

  //FUNCTION TO ADD ITEMS TO CART/PACKAGE
  void addToCart(Product product, int quantity) {
    widget.onAddToCart(CartItem(
      name: product.name,
      image: 'images/rbi.png',
      price: product.price,
      quantity: quantity,
    ));
    setState(() {
      isButtonDisabled[product.name] = true; // Disable button after adding to cart
    });
  }

  //REMOVE PRODUCT FROM CART WHEN QTY REACHED ZERO
  void removeFromCart(Product product) {
    widget.onRemoveFromCart(product.name);
    setState(() {
      isButtonDisabled[product.name] = true; // Ensure button remains disabled if quantity is zero
    });
  }

  //FUNCTION TO ADD ITEMS TO CART/PACKAGE
  // void addToCart(Product product, int quantity) {
  //   widget.onAddToCart(CartItem(
  //     name: product.name,
  //     image: 'images/rbi.png',
  //     price: product.price,
  //     quantity: quantity,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    //Calls the product list through category
    final filterProducts = productList.where((product) => selectedCategories.isEmpty || selectedCategories.contains('All') || selectedCategories.contains(product.category)).toList();
    return Column(
      children: [
        //Filter Chip UI
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          child: Wrap(
            runSpacing: 8,
            spacing: 10,
            alignment: WrapAlignment.start,
            children: categories
                .map((category) => FilterChip(
                      label: Text(
                        category,
                        style: TextStyle(color: selectedCategories.contains(category) ? Colors.white : Colors.black, fontWeight: FontWeight.normal, fontSize: 10),
                      ),
                      pressElevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      side: BorderSide.none,
                      backgroundColor: Colors.grey.shade200,
                      showCheckmark: false,
                      selectedColor: AppColors.mlniColor,
                      selected: selectedCategories.contains(category),
                      onSelected: (selected) {
                        setState(() {
                          if (category == 'All') {
                            if (selected) {
                              selectedCategories = ['All'];
                            } else {
                              selectedCategories.clear();
                            }
                          } else {
                            if (selectedCategories.contains('All')) {
                              selectedCategories.remove('All');
                            }
                            if (selected) {
                              selectedCategories.add(category);
                            } else {
                              selectedCategories.remove(category);
                            }
                            // If no categories are selected, select "All" by default
                            if (selectedCategories.isEmpty) {
                              selectedCategories.add('All');
                            }
                          }
                        });
                      },
                    ))
                .toList(),
          ),
        ),
        //Card UIs
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          padding: EdgeInsets.only(bottom: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double containerWidth = constraints.maxWidth;
              int crossAxisCount = (containerWidth / 200).floor(); //Dynamic positioning of cards
              if (crossAxisCount < 2) crossAxisCount = 2;

              return GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // Dynamic number of columns
                  crossAxisSpacing: 10.0, // Space between columns
                  mainAxisSpacing: 20.0, // Space between rows
                  childAspectRatio: 1.3, // Adjusted aspect ratio
                ),
                itemCount: filterProducts.length,
                itemBuilder: (context, index) {
                  final product = filterProducts[index];
                  final productQuantity = productQuantities[product.name] ?? 0;
                  final buttonDisabled = isButtonDisabled[product.name] ?? false;

                  //Per Item Card Container
                  return Container(
                    width: 150, // Fixed width for grid item
                    height: 200, // Fixed height for grid item
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Item Photo
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Container(
                                          constraints: const BoxConstraints(
                                            maxHeight: 90,
                                            maxWidth: 90,
                                            minWidth: 40,
                                            minHeight: 40,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.indigoAccent.shade100,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Image(
                                            image: AssetImage('images/rbi.png'),
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 10),

                                    // Item Name and Price
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: '₱ ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: product.price.toString(),
                                                  style: TextStyle(
                                                    fontSize: (MediaQuery.of(context).size.width / 40).clamp(14, 18),
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),

                              // Quantity Buttons
                              Row(
                                children: [
                                  ProductQuantityWidget(
                                    initialQuantity: productQuantity,
                                    onQuantityChanged: (quantity) {
                                      setState(() {
                                        productQuantities[product.name] = quantity;
                                        if (quantity == 0) {
                                          // Disable button when quantity is zero
                                          isButtonDisabled[product.name] = true;
                                        } else {
                                          // Enable button when quantity changes
                                          isButtonDisabled[product.name] = false;
                                        }
                                        debugPrint('Current Qty of ${product.name}: ${productQuantities[product.name]}');
                                      });
                                    },
                                  ),
                                  // ProductQuantityWidget(
                                  //   initialQuantity: productQuantity,
                                  //   onQuantityChanged: (quantity) {
                                  //     setState(() {
                                  //       productQuantities[product.name] = quantity;
                                  //       debugPrint('Current Qty of ${product.name}: ${productQuantities[product.name]}');
                                  //     });
                                  //   },
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: MLNIButtons.circleButtonWithIcon(
                              context,
                              Icons.add_shopping_cart,
                              20,
                              Colors.white,
                              Colors.green.shade800,
                              // Set button color based on whether it's disabled or not
                              productQuantity == 0 || buttonDisabled ? AppColors.mlniColor.withOpacity(0.5) : AppColors.mlniColor,
                              35,
                              // Enable or disable the button based on quantity
                              productQuantity == 0 || buttonDisabled
                                  ? null
                                  : () {
                                      addToCart(product, productQuantity); // Add or update item in cart
                                      if (productQuantity == 0) {
                                        removeFromCart(product); // Remove item from cart if quantity is zero
                                      }
                                    },
                            ),
                          ),

                          // Positioned(
                          //   bottom: 0,
                          //   right: 0,
                          //   child: MLNIButtons.circleButtonWithIcon(
                          //     context,
                          //     Icons.add_shopping_cart,
                          //     20,
                          //     Colors.white,
                          //     Colors.green.shade800,
                          //     buttonDisabled ? AppColors.mlniColor.withOpacity(0.5) : AppColors.mlniColor,
                          //     35,
                          //     buttonDisabled
                          //         ? null
                          //         : () {
                          //             addToCart(product, productQuantity);
                          //             if (productQuantity == 0) {
                          //               removeFromCart(product);
                          //             }
                          //           },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
