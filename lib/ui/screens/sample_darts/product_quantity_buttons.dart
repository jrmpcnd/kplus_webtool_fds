import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/buttons/button.dart';

class ProductQuantityWidget extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged; // Callback for quantity change

  ProductQuantityWidget({Key? key, required this.initialQuantity, required this.onQuantityChanged}) : super(key: key);

  @override
  _ProductQuantityWidgetState createState() => _ProductQuantityWidgetState();
}

class _ProductQuantityWidgetState extends State<ProductQuantityWidget> {
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      widget.onQuantityChanged(_quantity);
    });
  }

  void _decrementQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
        widget.onQuantityChanged(_quantity);
      });
    }
  }

  void _updateQuantity(String value) {
    setState(() {
      _quantity = int.tryParse(value) ?? _quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.25, minWidth: MediaQuery.of(context).size.width * 0.2),
      // color: Colors.indigoAccent.shade100,
      child: Wrap(
        runSpacing: 5,
        spacing: 10,
        children: [
          Text(
            'Qty',
            style: TextStyle(
              color: Colors.black,
              fontSize: (MediaQuery.of(context).size.width / 40).clamp(10, 12),
            ),
          ),
          Container(
            // color: Colors.indigoAccent,
            width: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MLNIButtons.circleButtonWithIcon(
                  context,
                  Icons.remove,
                  15,
                  Colors.black87,
                  AppColors.mlniColor,
                  Colors.white60,
                  20,
                  _decrementQuantity,
                ),
                Container(
                  width: 45,
                  height: 20,
                  child: TextField(
                    style: TextStyles.dataTextStyle,
                    cursorHeight: 12,
                    cursorWidth: 0.5,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: TextEditingController(text: _quantity.toString()),
                    onSubmitted: _updateQuantity,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Colors.white60,
                      focusColor: Colors.white60,
                    ),
                  ),
                ),
                MLNIButtons.circleButtonWithIcon(
                  context,
                  Icons.add,
                  15,
                  Colors.black87,
                  AppColors.mlniColor,
                  Colors.white60,
                  20,
                  _incrementQuantity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
