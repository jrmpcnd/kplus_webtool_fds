import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';

class DraggableSheetWidget extends StatefulWidget {
  final Widget child;
  final double totalPrice;
  const DraggableSheetWidget({super.key, required this.child, required this.totalPrice});

  @override
  State<DraggableSheetWidget> createState() => _DraggableSheetWidgetState();
}

class _DraggableSheetWidgetState extends State<DraggableSheetWidget> with SingleTickerProviderStateMixin {
  double currentHeight = 0.15;
  final double minHeight = 0.15;
  final double maxHeight = 0.7;
  final double showContentThreshold = 0.5; // Define a threshold to show content

  late AnimationController _controller;
  late Animation<double> _animation;

  final TextEditingController _packageNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _packageNameController.text = 'Name';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      // Update the currentHeight based on the drag amount
      currentHeight -= details.primaryDelta! / constraints.maxHeight;

      // Clamp the currentHeight to be within minHeight and maxHeight bounds
      currentHeight = currentHeight.clamp(minHeight, maxHeight);

      // If the currentHeight exceeds the showContentThreshold, forward the animation
      if (currentHeight > showContentThreshold) {
        _controller.forward();
      } else {
        // Otherwise, reverse the animation
        _controller.reverse();
      }
    });
  }

  void _onDragEnd(DragEndDetails details, BoxConstraints constraints) {
    if (currentHeight < minHeight) {
      setState(() {
        // If currentHeight is less than minHeight, set it to minHeight and reverse the animation
        currentHeight = minHeight;
        _controller.reverse();
      });
    } else if (currentHeight > maxHeight) {
      setState(() {
        // If currentHeight is greater than maxHeight, set it to maxHeight and forward the animation
        currentHeight = maxHeight;
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              // Add the semi-transparent background
              if (currentHeight > minHeight)
                const ModalBarrier(
                  dismissible: false,
                  color: Colors.black54,
                ),
              GestureDetector(
                onVerticalDragUpdate: (details) => _onDragUpdate(details, constraints),
                onVerticalDragEnd: (details) => _onDragEnd(details, constraints),
                child: Container(
                  height: constraints.maxHeight * currentHeight,
                  decoration: BoxDecoration(
                    color: (currentHeight > minHeight) ? Colors.grey.shade100 : Colors.grey.shade200,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      topButtonIndicator(100, 5),
                      Expanded(
                        child: CustomScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: FadeTransition(
                                opacity: _animation,
                                child: SizedBox(height: constraints.maxHeight * (currentHeight - 0.05), child: widget.child),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: (currentHeight > minHeight) ? Colors.grey.shade100 : Colors.grey.shade200,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 50,
                          // color: Colors.indigoAccent.shade100,
                          child: const Image(
                            image: AssetImage('images/no_list.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Package Name',
                              style: TextStyle(fontWeight: FontWeight.normal, color: AppColors.greyColor),
                            ),
                            Container(
                              width: 100,
                              height: 24,
                              // color: Colors.amber,
                              child: Stack(
                                children: [
                                  TextField(
                                    controller: _packageNameController,
                                    cursorHeight: 20,
                                    cursorWidth: 1,
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.mlniColor),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(borderSide: BorderSide.none),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  // Positioned(
                                  //   right: 0,
                                  //   bottom: 0,
                                  //   child: GestureDetector(
                                  //     onTap: printCartDetails,
                                  //     child: Icon(
                                  //       Icons.mode_edit_outlined,
                                  //       size: 10,
                                  //       color: Colors.grey.shade400,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.normal, color: AppColors.greyColor),
                            ),
                            Text(
                              widget.totalPrice.toStringAsFixed(2),
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87),
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.mlniColor,
                          ),
                          child: Center(
                            child: Text(
                              'Create',
                              style: TextStyles.bold14White,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (currentHeight > showContentThreshold)
                Positioned(
                  bottom: 75,
                  child: topButtonIndicator(MediaQuery.of(context).size.width * 0.9, 3),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget topButtonIndicator(double width, double height) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      height: height,
      decoration: const BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }
}
