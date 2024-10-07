import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';

class PopContainer extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final List<Widget>? rowChildren;
  final bool isMinimize;
  final Function(bool) onMinimizeToggle;
  final Function() onClose;
  final double popUpWidth;
  const PopContainer({super.key, required this.title, required this.children, this.rowChildren, required this.isMinimize, required this.onMinimizeToggle, required this.onClose, required this.popUpWidth});

  @override
  State<PopContainer> createState() => _PopContainerState();
}

class _PopContainerState extends State<PopContainer> {
  @override
  Widget build(BuildContext context) {
    final double containerHeight = widget.isMinimize ? 50 : MediaQuery.of(context).size.height * 0.6;
    bool showRowChildren = false;

    return Align(
      alignment: Alignment.bottomRight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 50),
        width: widget.popUpWidth,
        height: containerHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(-2, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.maroon5.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: TextStyles.bold14Black,
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    onPressed: () {
                      setState(() {
                        widget.onMinimizeToggle(!widget.isMinimize);
                      });
                    },
                    icon: Icon(
                      widget.isMinimize ? Icons.home_max : Icons.minimize,
                      size: 15,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    onPressed: () {
                      setState(() {
                        widget.onClose();
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            if (!widget.isMinimize)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Wrap(
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [...widget.children],
                    ),
                  ),
                ),
              ),
            // Show rowChildren only if the container is at full height
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.isMinimize ? 0 : 70,
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [...widget.rowChildren ?? []],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
