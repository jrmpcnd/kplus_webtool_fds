import 'package:flutter/material.dart';

class ScrollableWidget extends StatelessWidget {
  final Widget child;

  const ScrollableWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: child,
        ),
      );
}

class ScrollBarWidget extends StatelessWidget {
  final Widget child;
  ScrollBarWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final ScrollController controllerOne = ScrollController();
  final ScrollController controllerTwo = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      radius: const Radius.circular(3),
      thumbVisibility: true,
      scrollbarOrientation: ScrollbarOrientation.bottom,
      controller: controllerOne,
      child: SingleChildScrollView(
        controller: controllerOne,
        scrollDirection: Axis.horizontal,
        child: Scrollbar(
          radius: const Radius.circular(3),
          thumbVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.right,
          controller: controllerTwo,
          child: SingleChildScrollView(
            controller: controllerTwo,
            scrollDirection: Axis.vertical,
            child: child,
          ),
        ),
      ),
    );
  }
}
