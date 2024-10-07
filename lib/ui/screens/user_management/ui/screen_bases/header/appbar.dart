import 'package:flutter/material.dart';

class MFIAppbarMain extends StatelessWidget implements PreferredSizeWidget {
  const MFIAppbarMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MFIAppbar();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.8);
}

class MFIAppbar extends StatefulWidget {
  @override
  _MFIAppbarState createState() => _MFIAppbarState();
}

class _MFIAppbarState extends State<MFIAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: false,
      shadowColor: Colors.grey.shade300,
      backgroundColor: Colors.grey.shade50,
      title: Row(
        children: [
          Image(
            image: const AssetImage('images/whitelist_logo.png'),
            width: 40,
            height: 40,
          ),
        ],
      ),
      actions: const <Widget>[],
    );
  }
}
