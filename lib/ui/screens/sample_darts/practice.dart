// // import 'package:flutter/material.dart';
// //
// // import '../shared/values/colors.dart';
// // //
// // // class NewtonsCradle extends StatefulWidget {
// // //   const NewtonsCradle({super.key});
// // //
// // //   @override
// // //   _NewtonsCradleState createState() => _NewtonsCradleState();
// // // }
// // //
// // // class _NewtonsCradleState extends State<NewtonsCradle> with TickerProviderStateMixin {
// // //   late final AnimationController _firstController;
// // //   late final AnimationController _lastController;
// // //   late final Animation<double> _firstAnimation;
// // //   late final Animation<double> _lastAnimation;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //
// // //     _firstController = AnimationController(
// // //       duration: const Duration(seconds: 1),
// // //       vsync: this,
// // //     )..repeat();
// // //
// // //     _lastController = AnimationController(
// // //       duration: const Duration(seconds: 1),
// // //       vsync: this,
// // //     )..repeat();
// // //
// // //     _firstAnimation = TweenSequence([
// // //       TweenSequenceItem(tween: Tween(begin: 0.0, end: 70.0).chain(CurveTween(curve: Curves.easeOut)), weight: 25),
// // //       TweenSequenceItem(tween: Tween(begin: 70.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 25),
// // //       TweenSequenceItem(tween: ConstantTween(0.0), weight: 50),
// // //     ]).animate(_firstController);
// // //
// // //     _lastAnimation = TweenSequence([
// // //       TweenSequenceItem(tween: ConstantTween(0.0), weight: 50),
// // //       TweenSequenceItem(tween: Tween(begin: 0.0, end: -70.0).chain(CurveTween(curve: Curves.easeOut)), weight: 25),
// // //       TweenSequenceItem(tween: Tween(begin: -70.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 25),
// // //     ]).animate(_lastController);
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _firstController.dispose();
// // //     _lastController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     const size = 50.0;
// // //     const color = Color(0xFF474554);
// // //
// // //     return SizedBox(
// // //       width: size,
// // //       height: size,
// // //       child: Row(
// // //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //         children: [
// // //           _buildDot(size, _firstAnimation, color),
// // //           _buildDot(size, null, color),
// // //           _buildDot(size, null, color),
// // //           _buildDot(size, _lastAnimation, color),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildDot(double size, Animation<double>? animation, Color color) {
// // //     return Expanded(
// // //       child: Align(
// // //         alignment: Alignment.topCenter,
// // //         child: AnimatedBuilder(
// // //           animation: animation ?? const AlwaysStoppedAnimation(0.0),
// // //           builder: (_, child) {
// // //             return Transform.rotate(
// // //               angle: (animation?.value ?? 0) * 3.141592653589793 / 180,
// // //               origin: Offset(0, -size * 0.5),
// // //               child: child,
// // //             );
// // //           },
// // //           child: Container(
// // //             width: size * 0.25,
// // //             height: size * 0.25,
// // //             decoration: BoxDecoration(
// // //               color: color,
// // //               shape: BoxShape.circle,
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
//
// import 'package:flutter/material.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
//
// class StackImage extends StatefulWidget {
//   const StackImage({super.key});
//
//   @override
//   State<StackImage> createState() => _StackImageState();
// }
//
// class _StackImageState extends State<StackImage> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           margin: EdgeInsets.all(20),
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 height: 140,
//                 width: double.infinity,
//                 margin: EdgeInsets.only(top: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.teal.shade100,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 17, top: 25),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         '50% Off',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.ngoColor,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 4,
//                       ),
//                       const Text(
//                         '50% Off',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.ngoColor,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       Container(
//                         height: 32,
//                         width: 105,
//                         decoration: BoxDecoration(
//                           color: AppColors.ngoColor,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Center(
//                           child: const Text(
//                             '50% Off',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: AppColors.ngoColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Image.asset(
//                   'images/young_woman.png',
//                   height: 157,
//                   fit: BoxFit.fitHeight,
//                 ),
//               ),
//             ],
//           ),
//           // child: Stack(
//           //   clipBehavior: Clip.none,
//           //   children: [
//           //     Container(
//           //       height: 140,
//           //       width: 140,
//           //       margin: EdgeInsets.only(top: 16),
//           //       decoration: BoxDecoration(
//           //         color: Colors.teal.shade100,
//           //         shape: BoxShape.circle,
//           //       ),
//           //     ),
//           //     Positioned(
//           //       top: -3, // Adjust this to control how much of the image overflows from the top
//           //       right: 0,
//           //       child: Container(
//           //         width: 140, // Width of the image
//           //         height: 157, // Height of the image
//           //         child: ClipRRect(
//           //           borderRadius: BorderRadius.circular(70), // Match the circle radius
//           //           child: Image.asset(
//           //             'images/young_woman.png',
//           //             fit: BoxFit.cover,
//           //           ),
//           //         ),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           // child: Stack(
//           //   clipBehavior: Clip.none,
//           //   children: [
//           //     Container(
//           //       width: 900,
//           //       height: 200,
//           //       decoration: BoxDecoration(
//           //         color: Colors.pinkAccent.shade100,
//           //         borderRadius: BorderRadius.all(Radius.circular(10)),
//           //         border: Border.all(
//           //           width: 2,
//           //           color: Colors.red, // Adjust to your color
//           //         ),
//           //       ),
//           //     ),
//           //     Positioned(
//           //       top: -50, // Adjust this to control how much of the image overflows the top
//           //       left: 0,
//           //       right: 0,
//           //       child: Container(
//           //         height: 250, // Height of the image (more than the container height to allow overflow)
//           //         child: Image.asset(
//           //           'images/rbi.png',
//           //           fit: BoxFit.fitHeight,
//           //         ),
//           //       ),
//           //     ),
//           //     Container(
//           //       width: 900,
//           //       height: 200,
//           //       decoration: BoxDecoration(
//           //         borderRadius: BorderRadius.all(Radius.circular(10)),
//           //         border: Border(
//           //           bottom: BorderSide(
//           //             width: 2,
//           //             color: Colors.red, // Adjust to your color
//           //           ),
//           //           left: BorderSide(
//           //             width: 2,
//           //             color: Colors.red, // Adjust to your color
//           //           ),
//           //           right: BorderSide(
//           //             width: 2,
//           //             color: Colors.red, // Adjust to your color
//           //           ),
//           //         ),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//         ),
//       ],
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/sample_darts/cart_items_UI.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/sample_darts/product_list.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/sample_darts/product_model.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/search_bar.dart';

import '../../shared/values/colors.dart';
import 'draggable_sheet.dart';

class SampleBottomNavBar extends StatefulWidget {
  const SampleBottomNavBar({super.key});

  @override
  State<SampleBottomNavBar> createState() => _SampleBottomNavBarState();
}

class _SampleBottomNavBarState extends State<SampleBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFabTapped() {
    setState(() {
      _selectedIndex = 2; // Assuming the FAB represents the third item
    });
  }

  Widget _buildSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const HomeItem();
      case 1:
        return SearchItem();
      case 2:
        return FabItem();
      case 3:
        return NotificationsItem();
      case 4:
        return ProfileItem();
      default:
        return const HomeItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSelectedScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: _onFabTapped,
        child: Container(
          height: 56.0,
          width: 56.0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: _onFabTapped,
                child: const Icon(Icons.add, color: Colors.white),
                backgroundColor: Colors.blue, // Replace with your color
              ),
              if (_selectedIndex == 2)
                const Positioned(
                  bottom: -21,
                  child: Icon(
                    Icons.circle,
                    size: 7,
                    color: Colors.blue, // Replace with your color
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipPath(
        clipper: NotchedClipper(),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            color: Colors.grey.shade300,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBottomNavigationBarItem(Icons.home, 0),
              _buildBottomNavigationBarItem(Icons.search, 1),
              _buildBottomNavigationBarItem(null, 2), // Placeholder for FAB
              _buildBottomNavigationBarItem(Icons.notifications, 3),
              _buildBottomNavigationBarItem(Icons.person, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem(IconData? icon, int index) {
    return GestureDetector(
      onTap: () {
        if (icon != null) {
          _onItemTapped(index);
        } else {
          _onFabTapped();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Icon(icon, color: _selectedIndex == index ? AppColors.sidePanel3 : Colors.grey),
                if (_selectedIndex == index)
                  const Positioned(
                    bottom: -8,
                    child: Icon(
                      Icons.circle,
                      size: 7,
                      color: AppColors.sidePanel3,
                    ),
                  ),
              ],
            )
          else
            const SizedBox.shrink(), // Placeholder for FAB
        ],
      ),
    );
  }
}

class NotchedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double notchRadius = 28; // radius of the FAB
    final double notchCenter = size.width / 2; //positioning of the curve
    final double notchDepth = notchRadius * 1.3; // adjust for a smoother curve //Lower center curve

    Path path = Path()
      ..lineTo(notchCenter - notchRadius * 2.5, 0)
      ..cubicTo(
        notchCenter - notchRadius * 1.5,
        0,
        notchCenter - notchRadius,
        notchDepth,
        notchCenter,
        notchDepth,
      )
      ..cubicTo(
        notchCenter + notchRadius,
        notchDepth,
        notchCenter + notchRadius * 1.5,
        0,
        notchCenter + notchRadius * 2.5,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HomeItem extends StatefulWidget {
  const HomeItem({Key? key}) : super(key: key);

  @override
  State<HomeItem> createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {
  final searchController = TextEditingController();
  final List<CartItem> cartItems = [];

  // Function to add items to cart
  void addToCart(CartItem cartItem) {
    setState(() {
      final existingItemIndex = cartItems.indexWhere((item) => item.name == cartItem.name);

      if (existingItemIndex == -1) {
        cartItems.add(cartItem);
      } else {
        // Update the quantity based on the current quantity
        cartItems[existingItemIndex] = CartItem(
          name: cartItem.name,
          image: cartItem.image,
          price: cartItem.price,
          quantity: cartItem.quantity, // Set the quantity to the current value
        );
      }
    });
    debugPrint('Cart Items: ${cartItems.map((item) => '${item.name}: ${item.quantity}').toList()}');
  }

  // void addToCart(CartItem cartItem) {
  //   setState(() {
  //     final existingItemIndex = cartItems.indexWhere((item) => item.name == cartItem.name);
  //
  //     if (existingItemIndex == -1) {
  //       cartItems.add(cartItem);
  //     } else {
  //       cartItems[existingItemIndex].quantity += cartItem.quantity;
  //     }
  //   });
  //   debugPrint('Cart Items: ${cartItems.map((item) => '${item.name}: ${item.quantity}').toList()}');
  // }

  // Function to remove items from cart
  void removeFromCart(String itemName) {
    setState(() {
      cartItems.removeWhere((item) => item.name == itemName);
    });
    debugPrint('Cart Items: ${cartItems.map((item) => '${item.name}: ${item.quantity}').toList()}');
  }

  double getTotalCartPrice() {
    double totalPrice = 0.0;
    for (CartItem item in cartItems) {
      totalPrice += item.total;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Stack(
          children: [
            Column(
              children: [
                AppBarWidget(
                  title: 'Add Package',
                  backArrowColor: Colors.grey.shade200,
                ),
                Container(
                  margin: const EdgeInsets.all(30),
                  child: DynamicSearchBarWidget(
                    controller: searchController,
                    searchWidth: double.infinity,
                    searchHeight: 45,
                    radius: 50,
                    borderColor: Colors.grey,
                    color: Colors.white,
                    icon: Icons.search_rounded,
                    iconColor: Colors.grey.shade700,
                    iconSize: 30,
                    hintText: 'Search',
                  ),
                ),
                ProductListPage(
                  onAddToCart: addToCart, // Pass the add function
                  onRemoveFromCart: removeFromCart, // Pass the remove function
                ),
              ],
            ),
            DraggableSheetWidget(
              totalPrice: getTotalCartPrice(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Container(height: 100, color: Colors.red),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return CartItemUI(cartItem: cartItems[index]);
                      },
                    ),
                    Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarWidget extends StatefulWidget {
  final String title;
  final Color backArrowColor;
  const AppBarWidget({super.key, required this.title, required this.backArrowColor});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(2, 2, 10, 2),
            decoration: BoxDecoration(color: widget.backArrowColor, borderRadius: BorderRadius.circular(50)),
            child: const Row(
              children: [
                Icon(Icons.keyboard_arrow_left),
                Text(
                  'Back',
                  style: TextStyles.bold12Black,
                )
              ],
            ),
          ),
          const Spacer(),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w900),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class SearchItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink.shade100,
      child: const Center(
        child: Text('Search'),
      ),
    );
  }
}

class NotificationsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurpleAccent.shade100,
      child: const Center(
        child: Text('Notifications'),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.shade100,
      child: const Center(
        child: Text('Profile'),
      ),
    );
  }
}

class FabItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: const Center(
        child: Text('FAB'),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class FilePickerDemo extends StatefulWidget {
//   @override
//   _FilePickerDemoState createState() => _FilePickerDemoState();
// }
//
// class _FilePickerDemoState extends State<FilePickerDemo> {
//   static const platform = MethodChannel('file_picker_channel');
//   List<String> _selectedFiles = [];
//
//   Future<void> _pickFiles() async {
//     try {
//       final result = await platform.invokeMethod('pickFiles');
//       setState(() {
//         _selectedFiles = List<String>.from(result);
//       });
//     } on PlatformException catch (e) {
//       print("Error picking files: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('CSV File Picker'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _pickFiles,
//               child: Text('Select CSV Files'),
//             ),
//             SizedBox(height: 20),
//             _selectedFiles.isNotEmpty
//                 ? Expanded(
//                     child: ListView.builder(
//                       itemCount: _selectedFiles.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(_selectedFiles[index].split('/').last),
//                         );
//                       },
//                     ),
//                   )
//                 : Text('No files selected'),
//           ],
//         ),
//       ),
//     );
//   }
// }
