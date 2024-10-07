import 'package:flutter/material.dart';

class CircleStepper extends StatefulWidget {
  final Color borderColor;
  final Color secondBorderColor;
  final Color stepperColor;
  final Color shadowColor;
  final double padding;
  final Widget child;

  const CircleStepper({
    Key? key,
    required this.borderColor,
    required this.secondBorderColor,
    required this.stepperColor,
    required this.shadowColor,
    required this.padding,
    required this.child,
  }) : super(key: key);

  @override
  State<CircleStepper> createState() => _CircleStepperState();
}

class _CircleStepperState extends State<CircleStepper> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Outer border
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: widget.borderColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.secondBorderColor,
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.shadowColor.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.stepperColor,
                    boxShadow: [
                      BoxShadow(
                        color: widget.shadowColor.withOpacity(0.8),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(child: widget.child),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
