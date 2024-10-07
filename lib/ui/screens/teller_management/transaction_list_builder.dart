import 'package:flutter/material.dart';
import 'package:mfi_whitelist_admin_portal/core/provider/mfi/top_up_provider.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/transaction_items.dart';
import 'package:provider/provider.dart';

// Sample Data
// final data = {
//   "failed": [
//     {"AccountNumber": "100001000000024", "creditCustomerName": "", "message": "Source / Destination Account is Closed", "status": "FAILED", "trxReference": "TRX-TL01-001202410030904454675b2"},
//     {"AccountNumber": "100001000000025", "creditCustomerName": "", "message": "Source / Destination Account is Closed", "status": "FAILED", "trxReference": "TRX-TL01-00120241003090445222699"},
//     {"AccountNumber": "100001000000026", "creditCustomerName": "", "message": "Source / Destination Account is Closed", "status": "FAILED", "trxReference": "TRX-TL01-00120241003090446029a1c"},
//     {"AccountNumber": "100001000000024", "creditCustomerName": "", "message": "Source / Destination Account is Closed", "status": "FAILED", "trxReference": "TRX-TL01-001202410030904454675b2"},
//     {"AccountNumber": "100001000000025", "creditCustomerName": "", "message": "Source / Destination Account is Closed", "status": "FAILED", "trxReference": "TRX-TL01-00120241003090445222699"},
//     {"AccountNumber": "100001000000026", "creditCustomerName": "", "message": "Source / Destination Account is Closed", "status": "FAILED", "trxReference": "TRX-TL01-00120241003090446029a1c"},
//     {"AccountNumber": "100001000000024", "creditCustomerName": "", "message": "Source / Destination Account is Closed", "status": "FAILED", "trxReference": "TRX-TL01-001202410030904454675b2"},
//     {"AccountNumber": "100001000000025", "creditCustomerName": "", "message": "Source / Destination Account is Closed", "status": "FAILED", "trxReference": "TRX-TL01-00120241003090445222699"},
//     {"AccountNumber": "100001000000026", "creditCustomerName": "", "message": "Source / Destination Account is Closed", "status": "FAILED", "trxReference": "TRX-TL01-00120241003090446029a1c"}
//   ],
//   "success": [
//     {"AccountNumber": "100001000000021", "creditCustomerName": "George Almare Tan", "message": "Top-up Successful", "status": "SUCCESS", "trxReference": "TRX-TL01-00120241003090446304e0a"},
//     {"AccountNumber": "100001000000022", "creditCustomerName": "Chienlo Mejia", "message": "Top-up Successful", "status": "SUCCESS", "trxReference": "TRX-TL01-00120241003090444935596"},
//     {"AccountNumber": "100001000000023", "creditCustomerName": "Chienlo Mejia", "message": "Top-up Successful", "status": "SUCCESS", "trxReference": "TRX-TL01-0012024100309044571661e"},
//     {"AccountNumber": "100001000000021", "creditCustomerName": "George Almare Tan", "message": "Top-up Successful", "status": "SUCCESS", "trxReference": "TRX-TL01-00120241003090446304e0a"},
//     {"AccountNumber": "100001000000022", "creditCustomerName": "Chienlo Mejia", "message": "Top-up Successful", "status": "SUCCESS", "trxReference": "TRX-TL01-00120241003090444935596"},
//     {"AccountNumber": "100001000000023", "creditCustomerName": "Chienlo Mejia", "message": "Top-up Successful", "status": "SUCCESS", "trxReference": "TRX-TL01-0012024100309044571661e"},
//     {"AccountNumber": "100001000000021", "creditCustomerName": "George Almare Tan", "message": "Top-up Successful", "status": "SUCCESS", "trxReference": "TRX-TL01-00120241003090446304e0a"},
//     {"AccountNumber": "100001000000022", "creditCustomerName": "Chienlo Mejia", "message": "Top-up Successful", "status": "SUCCESS", "trxReference": "TRX-TL01-00120241003090444935596"},
//     {"AccountNumber": "100001000000023", "creditCustomerName": "Chienlo Mejia", "message": "Top-up Successful", "status": "SUCCESS", "trxReference": "TRX-TL01-0012024100309044571661e"}
//   ]
// };

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen width to determine if it's mobile or desktop view
    bool isMobile = MediaQuery.of(context).size.width < 600;

    // Access the TopUpProvider to get success and failed data
    final topUpProvider = Provider.of<TopUpProvider>(context);

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(30),
      width: 900,
      height: 600,
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
      child: Center(
        child: Wrap(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          spacing: 10,
          runSpacing: 20,
          children: [
            // Section for Successful Transactions
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 400, // Adjust width for mobile/desktop
                maxHeight: 500, // Adjust height as necessary
              ),
              child: ListView.builder(
                itemCount: topUpProvider.successList.length,
                itemBuilder: (context, index) {
                  var item = topUpProvider.successList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TransactionItem(
                      customerName: item.creditCustomerName ?? '',
                      accountNumber: item.accountNumber ?? '',
                      transactionNumber: item.trxReference ?? '',
                      status: "Success",
                      statusColor: Colors.green,
                      icon: Icons.check_circle,
                    ),
                  );
                },
              ),
            ),
            // Section for Failed Transactions
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 400, // Adjust width for mobile/desktop
                maxHeight: 500, // Adjust height as necessary
              ),
              child: ListView.builder(
                itemCount: topUpProvider.failedList.length,
                itemBuilder: (context, index) {
                  var item = topUpProvider.failedList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TransactionItem(
                      customerName: item.creditCustomerName ?? '',
                      accountNumber: item.accountNumber ?? '',
                      transactionNumber: item.trxReference ?? '',
                      status: "Failed",
                      statusColor: Colors.red,
                      icon: Icons.warning,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
