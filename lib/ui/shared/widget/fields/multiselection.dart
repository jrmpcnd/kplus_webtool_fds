import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';

class CustomMultiSelectDropdown extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<String> selectedItems;
  final Function(String, bool)? onItemSelected;
  final List<String> disabledItems;
  final bool enforceDateLogic; // New optional parameter

  CustomMultiSelectDropdown({
    required this.title,
    required this.items,
    required this.selectedItems,
    this.onItemSelected,
    this.disabledItems = const [],
    this.enforceDateLogic = false, // Default value set to false
  });

  @override
  _CustomMultiSelectDropdownState createState() => _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  List<String> _tempSelectedItems = [];
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = List.from(widget.selectedItems);
  }

  void _closeDropdown() {
    if (_isDropdownOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isDropdownOpen = false;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
                behavior: HitTestBehavior.opaque,
              ),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 5),
                child: Material(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: widget.items.map((item) {
                        bool isDisabled = widget.disabledItems.contains(item);
                        return CheckboxListTile(
                          dense: true,
                          value: _tempSelectedItems.contains(item),
                          title: Text(
                            item,
                            style: TextStyles.dataTextStyle,
                          ),
                          activeColor: AppColors.maroon2,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: isDisabled
                              ? null
                              : (isChecked) {
                                  setState(() {
                                    if (isChecked!) {
                                      _tempSelectedItems.add(item);
                                      widget.onItemSelected?.call(item, true);
                                    } else {
                                      _tempSelectedItems.remove(item);
                                      widget.onItemSelected?.call(item, false);

                                      // Conditionally execute the "Date From" -> "Date To" logic
                                      if (widget.enforceDateLogic && item == 'Date From' && _tempSelectedItems.contains('Date To')) {
                                        // If Date From is unchecked, uncheck Date To as well
                                        _tempSelectedItems.remove('Date To');
                                        widget.onItemSelected?.call('Date To', false); // Manually uncheck Date To
                                      }
                                    }
                                    _rebuildOverlay();
                                  });
                                },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _overlayEntry?.remove();
      _isDropdownOpen = false;
    } else {
      setState(() {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
        _isDropdownOpen = true;
      });
    }
  }

  void _rebuildOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 11.0),
              ),
              const Icon(
                Icons.filter_list,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
