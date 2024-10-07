import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';

class TransactionItem extends StatelessWidget {
  final String customerName;
  final String accountNumber;
  final String transactionNumber;
  final String status;
  final Color statusColor;
  final IconData icon;

  const TransactionItem({
    Key? key,
    required this.customerName,
    required this.accountNumber,
    required this.transactionNumber,
    required this.status,
    required this.statusColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey.shade50,
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, spreadRadius: 0.0, blurRadius: 3, offset: const Offset(3.0, 3.0)),
          BoxShadow(color: Colors.grey.shade300, spreadRadius: 0.0, blurRadius: 3 / 2.0, offset: const Offset(3.0, 3.0)),
          const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3, offset: Offset(-3.0, -3.0)),
          const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3 / 2, offset: Offset(-3.0, -3.0)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Icon(icon, color: statusColor, size: 30),
        title: Text(
          customerName.isNotEmpty ? customerName : 'Unknown Customer',
          style: TextStyles.heavyBold16Black,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(accountNumber, style: TextStyles.dataTextStyle),
            Text('Ref: $transactionNumber', style: TextStyles.normal14Black),
          ],
        ),
        // trailing: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //       width: 20,
        //       height: 20,
        //       child: Icon(
        //         Icons.info,
        //         color: Colors.grey,
        //         size: 20,
        //       ),
        //     ),
        //     Container(
        //       width: 20,
        //       height: 20,
        //       child: Icon(
        //         Icons.close,
        //         color: Colors.grey,
        //         size: 20,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
