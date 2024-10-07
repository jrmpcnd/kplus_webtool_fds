import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalRecords;
  final void Function() onPreviousPage;
  final void Function() onNextPage;
  final String title;

  const PaginationControls({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous Button
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: currentPage > 1 ? AppColors.maroon2 : Colors.grey.shade400, // Check if not the first page
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 12,
            ),
            color: Colors.white,
            onPressed: currentPage > 1 ? onPreviousPage : null, // Disable if on the first page
          ),
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              'PAGE $currentPage OF $totalPages',
              style: const TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
            Text(
              'Total Number of $title: $totalRecords',
              style: const TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
          ],
        ),
        const Spacer(),
        // Next Button
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: currentPage < totalPages ? AppColors.maroon2 : Colors.grey.shade400, // Check if not the last page
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: IconButton(
            color: Colors.white,
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
            ),
            onPressed: currentPage < totalPages ? onNextPage : null, // Disable if on the last page
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
//
// class PaginationControls extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final int totalRecords;
//   final void Function() onPreviousPage;
//   final void Function() onNextPage;
//   final void Function(int) onPageSelected;
//   final void Function(int) onRowsPerPageChanged;
//   final void Function(String) onGoToPage;
//   final int rowsPerPage;
//   final String title;
//
//   const PaginationControls({
//     Key? key,
//     required this.currentPage,
//     required this.totalPages,
//     required this.totalRecords,
//     required this.onPreviousPage,
//     required this.onNextPage,
//     required this.onPageSelected,
//     required this.onRowsPerPageChanged,
//     required this.onGoToPage,
//     required this.rowsPerPage,
//     required this.title,
//   }) : super(key: key);
//
//   // Helper function to build page numbers with ellipses
//   // List<Widget> _buildPageNumbers(BuildContext context) {
//   //   List<Widget> pageWidgets = [];
//   //
//   //   // Previous Button
//   //   pageWidgets.add(
//   //     IconButton(
//   //       icon: const Icon(
//   //         Icons.arrow_back_ios_new_rounded,
//   //         size: 12,
//   //       ),
//   //       color: currentPage > 1 ? AppColors.maroon2 : Colors.grey.shade400,
//   //       onPressed: currentPage > 1 ? onPreviousPage : null,
//   //     ),
//   //   );
//   //
//   //   // First Page
//   //   if (currentPage > 3) {
//   //     print('first page: $currentPage');
//   //     pageWidgets.add(_buildPageButton(context, 0));
//   //
//   //     print('add page: ${_buildPageButton(context, 0)}');
//   //     pageWidgets.add(const Padding(
//   //       padding: EdgeInsets.symmetric(horizontal: 5),
//   //       child: Text('...'),
//   //     ));
//   //   }
//   //
//   //   // Display three pages in the middle
//   //   for (int i = currentPage - 1; i <= currentPage + 1; i++) {
//   //     if (i > 0 && i <= totalPages) {
//   //       pageWidgets.add(_buildPageButton(context, i));
//   //     }
//   //   }
//   //
//   //   // Last Page
//   //   if (currentPage < totalPages - 2) {
//   //     pageWidgets.add(const Padding(
//   //       padding: EdgeInsets.symmetric(horizontal: 5),
//   //       child: Text('...'),
//   //     ));
//   //     pageWidgets.add(_buildPageButton(context, totalPages));
//   //   }
//   //
//   //   // Next Button
//   //   pageWidgets.add(
//   //     IconButton(
//   //       icon: const Icon(
//   //         Icons.arrow_forward_ios_rounded,
//   //         size: 12,
//   //       ),
//   //       color: currentPage < totalPages ? AppColors.maroon2 : Colors.grey.shade400,
//   //       onPressed: currentPage < totalPages ? onNextPage : null,
//   //     ),
//   //   );
//   //
//   //   return pageWidgets;
//   // }
//
//   List<Widget> _buildPageNumbers(BuildContext context) {
//     List<Widget> pageWidgets = [];
//
//     // Previous Button
//     pageWidgets.add(
//       IconButton(
//         icon: const Icon(
//           Icons.arrow_back_ios_new_rounded,
//           size: 12,
//         ),
//         color: currentPage > 1 && totalRecords != 0 ? AppColors.maroon2 : Colors.grey.shade400,
//         onPressed: currentPage > 1 && totalRecords != 0 ? onPreviousPage : null,
//       ),
//     );
//
//     // First Page
//     if (currentPage > 3) {
//       pageWidgets.add(_buildPageButton(context, 1)); // First page displayed as 1
//       pageWidgets.add(const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 5),
//         child: Text('...'),
//       ));
//     }
//
//     // Display three pages in the middle
//     for (int i = currentPage - 1; i <= currentPage + 1; i++) {
//       if (i > 0 && i <= totalPages) {
//         // ADJUST THE PAGE NUMBER FOR DISPLAY (subtract 1 if needed)
//         pageWidgets.add(_buildPageButton(context, i));
//       }
//     }
//
//     // Last Page
//     if (currentPage < totalPages - 2) {
//       pageWidgets.add(const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 5),
//         child: Text('...'),
//       ));
//       pageWidgets.add(_buildPageButton(context, totalPages)); // Show the last page
//     }
//
//     // Next Button
//     pageWidgets.add(
//       IconButton(
//         icon: const Icon(
//           Icons.arrow_forward_ios_rounded,
//           size: 12,
//         ),
//         color: currentPage < totalPages && totalRecords != 0 ? AppColors.maroon2 : Colors.grey.shade400,
//         onPressed: currentPage < totalPages && totalRecords != 0 ? onNextPage : null,
//       ),
//     );
//
//     return pageWidgets;
//   }
//
//   // Helper function to build individual page button
//   Widget _buildPageButton(BuildContext context, int page) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: page == currentPage ? AppColors.maroon5.withOpacity(0.2) : Colors.transparent,
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(
//           color: page == currentPage ? AppColors.maroon2 : Colors.transparent,
//         ),
//       ),
//       child: Text(
//         page.toString(),
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//           color: page == currentPage ? AppColors.maroon2 : Colors.grey,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 800,
//       child: Wrap(
//         spacing: 20,
//         alignment: WrapAlignment.end,
//         crossAxisAlignment: WrapCrossAlignment.center,
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Show dropdown for selecting number of rows per page
//           SizedBox(
//             width: 120,
//             child: Row(
//               children: [
//                 const Text(
//                   "Show: ",
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//                 DropdownButton<int>(
//                   value: rowsPerPage,
//                   underline: const SizedBox.shrink(),
//                   focusColor: Colors.transparent,
//                   dropdownColor: Colors.white,
//                   items: <int>[10, 20, 40, 50, 100].map((int value) {
//                     return DropdownMenuItem<int>(
//                       value: value,
//                       child: Text(
//                         '$value rows',
//                         style: const TextStyle(
//                           fontSize: 11,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (int? newValue) {
//                     if (newValue != null) {
//                       onRowsPerPageChanged(newValue);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//
//           // "Go to" input field
//           SizedBox(
//             width: 180,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Go to:",
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//                 SizedBox(
//                   width: 30,
//                   height: 30,
//                   child: TextFormField(
//                     cursorHeight: 10,
//                     cursorColor: AppColors.maroon2,
//                     style: const TextStyle(fontSize: 11),
//                     decoration: const InputDecoration(
//                       isDense: true,
//                       contentPadding: EdgeInsets.all(10),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onFieldSubmitted: (String value) {
//                       onGoToPage(value);
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//
//                 // Range display for current page
//                 Text(
//                   totalRecords == 0 ? '${0}-${0} of $totalRecords' : '${((currentPage - 1) * rowsPerPage) + 1}-${((currentPage) * rowsPerPage).clamp(1, totalRecords)} of $totalRecords',
//                   style: const TextStyle(fontSize: 11, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           // Page number buttons
//           SizedBox(
//             width: 320,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: _buildPageNumbers(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
