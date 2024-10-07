import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/gettoken/gettoken.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';

import '../../../../../../../core/models/dashboard_values/dashboard_values_model.dart';
import '../../../../../core/mfi_whitelist_api/dashboard/dashboard_values_api.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  ClientStatusCounts? _clientStatusCounts;

  bool _isLoading = true;
  final token = getToken();

  @override
  void initState() {
    super.initState();
    fetchClientStatusCounts();
  }

  Future<void> fetchClientStatusCounts() async {
    final clientStatusCounts = await ClientStatusCountsAPI().fetchClientStatusCounts();

    setState(() {
      _isLoading = false;
      if (clientStatusCounts != null) {
        _clientStatusCounts = clientStatusCounts;
      } else {
        print('null value =======================');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      runSpacing: 20,
      spacing: 20,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          runSpacing: 20,
          spacing: 20,
          children: [
            //ANALYTICS CARD
            AnalyticsCard(
              title: 'Pending Clients',
              icon: Icons.pending_outlined,
              totalRecordsWidget: _isLoading
                  ? const SpinKitWave(color: AppColors.maroon2, size: 20)
                  : Text(
                      _clientStatusCounts?.pendingCount.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
              cardColor: Colors.orange,
              width: 350,
              height: 150,
            ),
            AnalyticsCard(
              title: 'Approved Clients',
              icon: Icons.check_circle,
              totalRecordsWidget: _isLoading
                  ? const SpinKitWave(color: AppColors.maroon2, size: 20)
                  : Text(
                      _clientStatusCounts?.approvedCount.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
              cardColor: Colors.green,
              width: 350,
              height: 150,
            ),
            AnalyticsCard(
              title: 'Disapproved Clients',
              icon: Icons.cancel,
              totalRecordsWidget: _isLoading
                  ? const SpinKitWave(color: AppColors.maroon2, size: 20)
                  : Text(
                      _clientStatusCounts?.disapprovedCount.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
              cardColor: Colors.red,
              width: 350,
              height: 150,
            ),
          ],
        ),
      ],
    ));
  }
}

class AnalyticsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget totalRecordsWidget;
  final Color cardColor;
  final double width;
  final double height;

  AnalyticsCard({required this.title, required this.icon, required this.totalRecordsWidget, required this.cardColor, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.grey.shade50,
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, spreadRadius: 0.0, blurRadius: 3, offset: const Offset(3.0, 3.0)),
          BoxShadow(color: Colors.grey.shade300, spreadRadius: 0.0, blurRadius: 3 / 2.0, offset: const Offset(3.0, 3.0)),
          const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3, offset: Offset(-3.0, -3.0)),
          const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3 / 2, offset: Offset(-3.0, -3.0)),
        ],
      ),
      padding: const EdgeInsets.all(30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: cardColor.withOpacity(0.1), spreadRadius: 2, blurRadius: 5, offset: const Offset(2, 2)),
              ],
            ),
            child: Icon(
              icon,
              color: cardColor,
              size: 40,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              totalRecordsWidget,
              Wrap(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: cardColor,
                    ),
                    maxLines: 3,
                    softWrap: true,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminAnalytics extends StatefulWidget {
  const AdminAnalytics({super.key});

  @override
  State<AdminAnalytics> createState() => _AdminAnalyticsState();
}

class _AdminAnalyticsState extends State<AdminAnalytics> {
  UserStatusCounts? _userStatusCounts;

  bool _isLoading = true;
  final token = getToken();

  @override
  void initState() {
    super.initState();
    fetchUserStatusCounts();
  }

  Future<void> fetchUserStatusCounts() async {
    final userStatusCounts = await UserStatusCountsAPI().fetchUserStatusCounts();

    setState(() {
      _isLoading = false;
      if (userStatusCounts != null) {
        _userStatusCounts = userStatusCounts;
      } else {
        print('null value =======================');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      runSpacing: 20,
      spacing: 20,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          runSpacing: 20,
          spacing: 20,
          children: [
            //ANALYTICS CARD
            AnalyticsCard(
              title: 'MFI Whitelist Users',
              icon: Icons.person,
              totalRecordsWidget: _isLoading
                  ? const SpinKitWave(color: AppColors.maroon2, size: 20)
                  : Text(
                      _userStatusCounts?.allUsersCount.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
              cardColor: Colors.orange,
              width: 350,
              height: 150,
            ),
            AnalyticsCard(
              title: 'MFI Makers',
              icon: Icons.person,
              totalRecordsWidget: _isLoading
                  ? const SpinKitWave(color: AppColors.maroon2, size: 20)
                  : Text(
                      _userStatusCounts?.makerCount.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
              cardColor: Colors.green,
              width: 350,
              height: 150,
            ),
            AnalyticsCard(
              title: 'MFI Checkers',
              icon: Icons.person,
              totalRecordsWidget: _isLoading
                  ? const SpinKitWave(color: AppColors.maroon2, size: 20)
                  : Text(
                      _userStatusCounts?.checkerCount.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
              cardColor: Colors.red,
              width: 350,
              height: 150,
            ),
          ],
        ),
      ],
    ));
  }
}

class AdminAnalyticsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget totalRecordsWidget;
  final Color cardColor;
  final double width;
  final double height;

  AdminAnalyticsCard({required this.title, required this.icon, required this.totalRecordsWidget, required this.cardColor, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.grey.shade50,
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, spreadRadius: 0.0, blurRadius: 3, offset: const Offset(3.0, 3.0)),
          BoxShadow(color: Colors.grey.shade300, spreadRadius: 0.0, blurRadius: 3 / 2.0, offset: const Offset(3.0, 3.0)),
          const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3, offset: Offset(-3.0, -3.0)),
          const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3 / 2, offset: Offset(-3.0, -3.0)),
        ],
      ),

      // BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(8),
      //   boxShadow: [
      //     BoxShadow(color: cardColor.withOpacity(0.1), spreadRadius: 2, blurRadius: 5, offset: Offset(2, 2)),
      //   ],
      // ),
      padding: const EdgeInsets.all(30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: cardColor.withOpacity(0.1), spreadRadius: 2, blurRadius: 5, offset: const Offset(2, 2)),
              ],
            ),
            child: Icon(
              icon,
              color: cardColor,
              size: 40,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              totalRecordsWidget,
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AMLAAnalytics extends StatefulWidget {
  const AMLAAnalytics({super.key});

  @override
  State<AMLAAnalytics> createState() => _AMLAAnalyticsState();
}

class _AMLAAnalyticsState extends State<AMLAAnalytics> {
  AMLAStatusCounts? _amlaStatusCounts;

  bool _isLoading = true;
  final token = getToken();

  @override
  void initState() {
    super.initState();
    fetchAMLAStatusCounts();
  }

  Future<void> fetchAMLAStatusCounts() async {
    final amlaStatusCounts = await AMLAStatusCountsAPI().fetchAMLAStatusCounts();

    setState(() {
      _isLoading = false;
      if (amlaStatusCounts != null) {
        _amlaStatusCounts = amlaStatusCounts;
      } else {
        print('null value =======================');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      runSpacing: 20,
      spacing: 20,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          runSpacing: 20,
          spacing: 20,
          children: [
            //ANALYTICS CARD
            AnalyticsCard(
              title: 'AMLA Watchlist',
              icon: Icons.person,
              totalRecordsWidget: _isLoading
                  ? const SpinKitWave(color: AppColors.maroon2, size: 20)
                  : Text(
                      _amlaStatusCounts?.amlaCount.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
              cardColor: Colors.orange,
              width: 350,
              height: 150,
            ),
            AnalyticsCard(
              title: 'AMLA Delisted',
              icon: Icons.person,
              totalRecordsWidget: _isLoading
                  ? const SpinKitWave(color: AppColors.maroon2, size: 20)
                  : Text(
                      _amlaStatusCounts?.amlaDelistedCount.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
              cardColor: Colors.red,
              width: 350,
              height: 150,
            ),
          ],
        ),
      ],
    ));
  }
}

class AMLAAnalyticsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget totalRecordsWidget;
  final Color cardColor;
  final double width;
  final double height;

  AMLAAnalyticsCard({required this.title, required this.icon, required this.totalRecordsWidget, required this.cardColor, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.grey.shade50,
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, spreadRadius: 0.0, blurRadius: 3, offset: const Offset(3.0, 3.0)),
          BoxShadow(color: Colors.grey.shade300, spreadRadius: 0.0, blurRadius: 3 / 2.0, offset: const Offset(3.0, 3.0)),
          const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3, offset: Offset(-3.0, -3.0)),
          const BoxShadow(color: Colors.white70, spreadRadius: 2.0, blurRadius: 3 / 2, offset: Offset(-3.0, -3.0)),
        ],
      ),

      // BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(8),
      //   boxShadow: [
      //     BoxShadow(color: cardColor.withOpacity(0.1), spreadRadius: 2, blurRadius: 5, offset: Offset(2, 2)),
      //   ],
      // ),
      padding: const EdgeInsets.all(30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: cardColor.withOpacity(0.1), spreadRadius: 2, blurRadius: 5, offset: const Offset(2, 2)),
              ],
            ),
            child: Icon(
              icon,
              color: cardColor,
              size: 40,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              totalRecordsWidget,
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
