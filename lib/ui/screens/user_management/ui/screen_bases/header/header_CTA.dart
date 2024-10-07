import 'package:flutter/material.dart';

class HeaderCTA extends StatefulWidget {
  final List<Widget> children;
  const HeaderCTA({super.key, required this.children});

  @override
  State<HeaderCTA> createState() => _HeaderCTAState();
}

class _HeaderCTAState extends State<HeaderCTA> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [...widget.children],
      ),
    );
  }
}
