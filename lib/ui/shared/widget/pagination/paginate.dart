import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../formatters/formatter.dart';
import '../../values/styles.dart';

class Pagination extends StatefulWidget {
  final TextEditingController? rowController;
  final void Function(String) rowOnChanged;
  final VoidCallback? onPressPrev;
  final VoidCallback? onPressNext;
  final String? text;

  const Pagination({Key? key, this.text, required this.rowController, required this.rowOnChanged, required this.onPressPrev, required this.onPressNext}) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Rows per page: ',
                style: TextStyles.normal12Black,
              ),
              SizedBox(
                height: 25,
                width: 45,
                child: TextFormField(
                  style: TextStyles.normal12Black,
                  controller: widget.rowController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    ZeroFormat(),
                  ],
                  onChanged: widget.rowOnChanged,
                  decoration: InputDecoration(
                    // isDense: true,
                    // filled: true,
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: widget.onPressPrev,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                widget.text!,
                style: const TextStyle(fontSize: 10),
              ),
              IconButton(
                onPressed: widget.onPressNext,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          )
        ],
      ),
    );
  }
}
