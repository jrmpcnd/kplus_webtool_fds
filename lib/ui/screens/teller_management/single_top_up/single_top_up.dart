import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mfi_whitelist_admin_portal/core/provider/mfi/top_up_provider.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header.dart';
import 'package:mfi_whitelist_admin_portal/ui/screens/user_management/ui/screen_bases/header/header_CTA.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/clock/clock.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/formatters/formatter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/getuserinfo/getuserinfo.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/colors.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/alert_dialog/alert_dialogs.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/buttons/button.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/containers/dialog.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/simplified_widget.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/stepper/stepper_circle.dart';
import 'package:provider/provider.dart';

import '../../../../../main.dart';
import '../../../shared/utils/utils_responsive.dart';

class SingleWalletTopUp extends StatefulWidget {
  const SingleWalletTopUp({Key? key}) : super(key: key);

  @override
  State<SingleWalletTopUp> createState() => _SingleWalletTopUpState();
}

class _SingleWalletTopUpState extends State<SingleWalletTopUp> {
  @override
  void initState() {
    super.initState();
    updateUrl('/Access/Top_Up/Single_Top_Up');
    singleTopUpTellerName.text = '${getFname()!} ${getLname()!}';
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ///TELLER PERSONAL INFORMATION
  TextEditingController singleTopUpTellerName = TextEditingController();

  ///PERSONAL INFORMATION
  TextEditingController singleTopUpCID = TextEditingController();
  TextEditingController singleTopUpFullName = TextEditingController();
  TextEditingController singleTopUpFirstName = TextEditingController();
  TextEditingController singleTopUpMiddleName = TextEditingController();
  TextEditingController singleTopUpLastName = TextEditingController();
  TextEditingController singleTopUpBirthdate = TextEditingController();
  TextEditingController singleTopUpMobileNumber = TextEditingController();

  ///INSTI INFORMATION
  TextEditingController singleTopUpInstiName = TextEditingController();
  TextEditingController singleTopUpAccountName = TextEditingController();
  TextEditingController singleTopUpAccountNumber = TextEditingController();
  TextEditingController singleTopUpAmount = TextEditingController();

  int currentStep = 0;
  String formattedAccountNumber = '';

  // Function to fetch data and update controllers
  Future<void> _fetchClientData() async {
    if (singleTopUpAccountNumber.text.isNotEmpty) {
      _searchNewAccount();
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 350,
          height: 100,
          decoration: const BoxDecoration(
            color: AppColors.dialogColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCircle(color: AppColors.maroon2),
              SizedBox(width: 10),
              Text('Inquiry processing...'),
            ],
          ),
        ),
      ),
    );

    final provider = Provider.of<TopUpProvider>(context, listen: false);

    // Call the fetch function with the CID
    await provider.inquireClientData(int.parse(singleTopUpCID.text));

    // Close the loading dialog
    Navigator.pop(navigatorKey.currentContext!);

    // Check if the client data is available
    if (provider.clientData != null) {
      // Updated property name
      // Update the controllers with fetched data
      setState(() {
        singleTopUpFirstName.text = provider.clientData!.data.firstName; // Adjusted to access nested property
        singleTopUpMiddleName.text = provider.clientData!.data.middleName ?? '';
        singleTopUpLastName.text = provider.clientData!.data.lastName; // Adjusted to access nested property
        singleTopUpBirthdate.text = provider.clientData!.data.birthday; // Adjusted to access nested property
        singleTopUpMobileNumber.text = provider.clientData!.data.mobile; // Adjusted to access nested property
        singleTopUpInstiName.text = provider.clientData!.data.accounts[0].instiName; // Adjusted property name
        singleTopUpAccountName.text = provider.clientData!.data.accounts[0].savings[0].accountName; // Adjusted property name
        singleTopUpAccountNumber.text = provider.clientData!.data.accounts[0].savings[0].accountNumber; // Adjusted property name

        // Get the raw account number
        String rawAccountNumber = provider.clientData!.data.accounts[0].savings[0].accountNumber;
        // Format the account number
        singleTopUpAccountNumber.text = formatBankAccountNumber(rawAccountNumber); // Set formatted value

        singleTopUpFullName.text = '${singleTopUpFirstName.text} ${singleTopUpMiddleName.text} ${singleTopUpLastName.text}';
      });
    } else if (provider.errorMessage != null) {
      // Show an alert dialog in case of error
      showGeneralErrorAlertDialog(navigatorKey.currentContext!, provider.errorMessage.toString());
    }
  }

  String formattedAmount() {
    String amountText = singleTopUpAmount.text;

    // Check if the amount has a decimal part
    if (amountText.contains('.')) {
      // If it has a decimal part, split the amount
      List<String> parts = amountText.split('.');
      String integerPart = parts[0];
      String decimalPart = parts.length > 1 ? parts[1] : '';

      // Append '0' if the decimal part has only one digit
      if (decimalPart.length == 1) {
        return 'PHP $integerPart.${decimalPart}0'; // Correctly append '0' to the decimal part
      }

      // Return the formatted amount with the original decimal part
      return 'PHP $amountText';
    } else {
      // If there's no decimal part, append '.00'
      return 'PHP $amountText.00';
    }
  }

  String formatBankAccountNumber(String accountNumber) {
    // Remove any non-digit characters
    String cleanedNumber = accountNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the cleaned number into groups of 4-4-4-3
    StringBuffer formattedText = StringBuffer();

    for (int i = 0; i < cleanedNumber.length; i++) {
      if (i > 0 && (i % 4 == 0) && (i < cleanedNumber.length)) {
        formattedText.write('-');
      }
      formattedText.write(cleanedNumber[i]);
    }

    return formattedText.toString();
  }

  void _clearFields() {
    ///PERSONAL INFORMATION
    singleTopUpCID.clear();
    singleTopUpFullName.clear();
    singleTopUpFirstName.clear();
    singleTopUpMiddleName.clear();
    singleTopUpLastName.clear();
    singleTopUpBirthdate.clear();
    singleTopUpMobileNumber.clear();

    ///INSTI INFORMATION
    singleTopUpInstiName.clear();
    singleTopUpAccountName.clear();
    singleTopUpAccountNumber.clear();
    singleTopUpAmount.clear();
  }

  void _searchNewAccount() {
    ///PERSONAL INFORMATION
    singleTopUpFullName.clear();
    singleTopUpFirstName.clear();
    singleTopUpMiddleName.clear();
    singleTopUpLastName.clear();
    singleTopUpBirthdate.clear();
    singleTopUpMobileNumber.clear();

    ///INSTI INFORMATION
    singleTopUpInstiName.clear();
    singleTopUpAccountName.clear();
    singleTopUpAccountNumber.clear();
    singleTopUpAmount.clear();
  }

  void _onTopUpPressed() async {
    Navigator.pop(context);
    String accountNumber = singleTopUpAccountNumber.text.replaceAll('-', ''); // Remove dashes if necessary
    String topUpAmount = singleTopUpAmount.text.replaceAll(',', '');
    double amount = double.tryParse(topUpAmount) ?? 0; // Ensure to replace with your actual amount input

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 350,
          height: 100,
          decoration: const BoxDecoration(
            color: AppColors.dialogColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCircle(color: AppColors.maroon2),
              SizedBox(width: 10),
              Text('Top up request processing...'),
            ],
          ),
        ),
      ),
    );

    final provider = Provider.of<TopUpProvider>(context, listen: false);

    await provider.requestTopUp(accountNumber, amount);

    // Close the loading dialog
    Navigator.pop(navigatorKey.currentContext!);

    if (provider.successfulMessage == 'Successful Top Up') {
      // Handle success
      showSuccessAlertDialog(navigatorKey.currentContext!, "The top-up was successful! The amount has been credited to the client's account.", onPositiveButtonPressed: () {
        _clearFields();
      });
    } else {
      // Show an alert dialog in case of error
      showGeneralErrorAlertDialog(navigatorKey.currentContext!, 'Sorry, we are unable to process your request.');
    }
  }

  ///BOOLEAN VALUES

  /// VALIDATOR
  String? _validateTopUpAmount(String? value) {
    String topUpAmount = singleTopUpAmount.text.replaceAll(',', '');
    double amount = double.tryParse(topUpAmount) ?? 0;

    // If the field is empty, remove previous validation messages
    if (value == null || value.isEmpty) {
      return null;
    }

    if (amount < 100) {
      return 'Amount is below the required minimum of 100';
    } else if (amount > 50000) {
      return 'Amount exceeds the allowed maximum of 50,000';
    } else {
      return null; // No validation message if the value is valid
    }
  }

  void validateFieldUponProceed(String value) {
    if (formKey.currentState!.validate()) {
      _validateTopUpAmount(value);
    }
  }

  //FOR TEXT FORM FIELD VALIDATOR
  String? _validateField(String? value, {bool isMobileNumber = false}) {
    if (value == null || value.isEmpty) {
      return '';
    }

    // Additional validation for mobile number fields
    if (isMobileNumber && value.length != 11) {
      return '';
    }
    return null;
  }

  //DETERMINE MIN AND MAX VALUE
  void determineMinMaxAmount(double amount) {
    if (amount < 100) {
      _showMinMaxAmountDialog(context, 'The entered amount is below the required minimum for a top-up.', 'Minimum Top-Up Amount Required');
    } else if (amount > 50000) {
      _showMinMaxAmountDialog(context, 'The entered amount exceeds the allowed maximum for a top-up.', 'Maximum Top-Up Limit Exceeded');
    } else {
      _showTopUpConfirmationDialog(context);
    }
  }

  ///MAIN BUILDER
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 90),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HeaderBar(screenText: 'SINGLE E-WALLET TOP UP'),
            const HeaderCTA(children: [
              Spacer(),
              Responsive(desktop: Clock(), mobile: Spacer()),
            ]),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
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
                child: bodySingleWalletTopUp(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///CONTAIN THE MAIN BODY
  Widget bodySingleWalletTopUp() {
    double fontSize = (MediaQuery.sizeOf(context).width / 30);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Iconsax.wallet_add_1_copy,
                    color: AppColors.maroon2,
                    size: 35,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'E-Wallet Top-up',
                    style: TextStyle(color: AppColors.maroon2, fontSize: fontSize.clamp(25, 40), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
                child: personalInformationForm(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Responsive(
            desktop: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: singleTopUpAmount,
                  builder: (context, TextEditingValue value, child) {
                    return SizedBox(
                      width: 160,
                      height: 50,
                      child: MyButton.buttonWithLabel(
                        context,
                        () => singleTopUpAmount.text.isNotEmpty ? determineMinMaxAmount(double.parse(singleTopUpAmount.text.replaceAll(',', ''))) : null,
                        'PROCEED TOP UP',
                        Iconsax.wallet_add_1_copy,
                        singleTopUpAmount.text.isNotEmpty ? AppColors.maroon2 : Colors.grey,
                      ),
                    );
                  },
                ),
              ],
            ),
            tablet: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: singleTopUpAmount,
                  builder: (context, TextEditingValue value, child) {
                    return SizedBox(
                      width: 160,
                      height: 50,
                      child: MyButton.buttonWithLabel(
                        context,
                        () => singleTopUpAmount.text.isNotEmpty ? determineMinMaxAmount(double.parse(singleTopUpAmount.text.replaceAll(',', ''))) : null,
                        'PROCEED TOP UP',
                        Iconsax.wallet_add_1_copy,
                        singleTopUpAmount.text.isNotEmpty ? AppColors.maroon2 : Colors.grey,
                      ),
                    );
                  },
                ),
              ],
            ),
            mobile: ValueListenableBuilder(
              valueListenable: singleTopUpAmount,
              builder: (context, TextEditingValue value, child) {
                return SizedBox(
                    height: 60,
                    child: CustomColoredButton.primaryButtonWithText(
                      context,
                      5,
                      () => singleTopUpAmount.text.isNotEmpty ? determineMinMaxAmount(double.parse(singleTopUpAmount.text.replaceAll(',', ''))) : null,
                      singleTopUpAmount.text.isNotEmpty ? AppColors.maroon2 : Colors.grey,
                      'PROCEED TOP UP',
                    ));
              },
            ),
          )
        ],
      ),
    );
  }

  ///STEPPER 1: PERSONAL INFORMATION
  Widget personalInformationForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   // color: Colors.teal,
          //   constraints: const BoxConstraints(maxWidth: 900),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Container(
          //         margin: const EdgeInsets.only(left: 5),
          //         child: RichText(
          //           text: const TextSpan(
          //             children: [
          //               TextSpan(
          //                 text: "Teller's Name ",
          //                 style: TextStyles.normal12Maroon,
          //               ),
          //               TextSpan(
          //                 text: '*',
          //                 style: TextStyle(
          //                   color: CagabayColors.Main,
          //                   fontSize: 12,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       // buildTextFormField(
          //       //   width: 500,
          //       //   title: '',
          //       //   hintText: '',
          //       //   prefixIcon: Iconsax.profile_circle_copy,
          //       //   controller: singleTopUpTellerName,
          //       //   validator: _validateField,
          //       //   enabled: false,
          //       // ),
          //     ],
          //   ),
          // ),
          Wrap(
            spacing: 20,
            children: [
              Container(
                // color: Colors.amber,
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'E-Wallet Information',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: (MediaQuery.sizeOf(context).width / 50).clamp(14, 16),
                            ),
                          ),
                          const Text(
                            "Provide the client's institutional membership.",
                            style: TextStyles.dataTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'CID ',
                                      style: TextStyles.normal12Maroon,
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        color: CagabayColors.Main,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            buildTextFormField(
                              width: 320,
                              title: '',
                              hintText: '0000000000',
                              prefixIcon: Iconsax.card_copy,
                              controller: singleTopUpCID,
                              validator: _validateField,
                              inputFormatters: [NumbersOnlyFormatter()],
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: singleTopUpCID,
                          builder: (context, TextEditingValue value, child) {
                            if (singleTopUpCID.text.isEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                // Clear the other fields when CID is empty
                                singleTopUpInstiName.clear();
                                singleTopUpAccountName.clear();
                                singleTopUpAccountNumber.clear();
                                singleTopUpFullName.clear();
                                singleTopUpBirthdate.clear();
                                singleTopUpMobileNumber.clear();
                                singleTopUpAmount.clear();
                              });
                            }
                            return SizedBox(
                                width: 160,
                                child: MyButton.buttonWithLabel(
                                  context,
                                  () => singleTopUpCID.text.isNotEmpty ? _fetchClientData() : null,
                                  'Search Account',
                                  Iconsax.wallet_search_copy,
                                  singleTopUpCID.text.isNotEmpty ? AppColors.maroon2 : Colors.grey,
                                ));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        LabeledTextField(
                          label: 'Institution Name',
                          isRequired: false,
                          formField: buildTextFormField(
                            width: 620,
                            title: '',
                            hintText: 'CARD, Inc.',
                            prefixIcon: Iconsax.bank_copy,
                            controller: singleTopUpInstiName,
                            validator: _validateField,
                            enabled: false,
                          ),
                        ),
                        LabeledTextField(
                          label: 'Account Name',
                          isRequired: false,
                          formField: buildTextFormField(
                            width: 300,
                            title: '',
                            hintText: 'KPlus Account',
                            prefixIcon: Iconsax.personalcard_copy,
                            controller: singleTopUpAccountName,
                            validator: _validateField,
                            enabled: false,
                          ),
                        ),
                        LabeledTextField(
                          label: 'Account Number',
                          isRequired: false,
                          formField: buildTextFormField(
                            width: 300,
                            title: '',
                            hintText: '0000-0000-0000-000',
                            prefixIcon: Iconsax.card_copy,
                            controller: singleTopUpAccountNumber,
                            validator: _validateField,
                            enabled: false,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                // color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Client Information',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: (MediaQuery.sizeOf(context).width / 50).clamp(14, 16),
                                ),
                              ),
                              const Text(
                                "Fields are automatically field out upon search.",
                                style: TextStyles.dataTextStyle,
                              ),
                            ],
                          ),
                        ),
                        LabeledTextField(
                          label: "Client's Full Name",
                          isRequired: false,
                          formField: buildTextFormField(
                            width: 620,
                            title: '',
                            hintText: 'Juana Dela Cruz',
                            prefixIcon: Iconsax.profile_circle_copy,
                            controller: singleTopUpFullName,
                            validator: _validateField,
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 7),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        LabeledTextField(
                          label: 'Birthdate',
                          isRequired: false,
                          formField: buildTextFormField(
                            width: 300,
                            title: '',
                            hintText: 'YYYY-MM-DD',
                            prefixIcon: Iconsax.calendar_1_copy,
                            controller: singleTopUpBirthdate,
                            validator: _validateField,
                            enabled: false,
                          ),
                        ),
                        LabeledTextField(
                          label: 'Mobile Number',
                          isRequired: false,
                          formField: buildTextFormField(
                            width: 300,
                            title: '',
                            mobileNumberField: true,
                            prefixIcon: Iconsax.mobile_copy,
                            controller: singleTopUpMobileNumber,
                            validator: (value) => _validateField(value, isMobileNumber: true),
                            inputFormatters: [DigitInputFormatter()],
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            // color: Colors.amber,
            margin: const EdgeInsets.only(top: 10),
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How much would you like to top up?',
                  style: TextStyles.bold14Black,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 5),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Top Up Amount ",
                          style: TextStyles.normal12Maroon,
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: CagabayColors.Main,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: singleTopUpAccountNumber, // Listen to account number changes
                  builder: (context, accountNumberValue, child) {
                    return SizedBox(
                      width: 620,
                      child: buildCurrencyTextField(
                        onChanged: validateFieldUponProceed,
                        controller: singleTopUpAmount,
                        hintText: '0.00', // Placeholder text
                        validator: _validateTopUpAmount,
                        isEnabled: (accountNumberValue.text.isNotEmpty),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///DIALOGS
  void _showTopUpConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Get a dynamic width for the shadow container based on the dialog width
              double shadowContainerWidth = constraints.maxWidth * 0.6; // Adjust this ratio as needed

              // Ensure the shadow container doesn't exceed a certain maximum width
              if (shadowContainerWidth > 300) {
                shadowContainerWidth = 300; // Set a max width if needed
              }

              return Stack(
                clipBehavior: Clip.none, // This allows the icon to overflow the dialog
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Positioned(
                    bottom: -10,
                    child: Container(
                      width: shadowContainerWidth, // Adjust width to half of the dialog
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.infoColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                    width: 500,
                    decoration: BoxDecoration(
                      color: AppColors.bgColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Amount Top-up',
                          style: TextStyles.dataTextStyle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formattedAmount(),
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const Text('Account Number'),
                            const Spacer(),
                            Text(
                              singleTopUpAccountNumber.text,
                              style: TextStyles.bold14Black,
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Account Name'),
                            const Spacer(),
                            Text(singleTopUpFullName.text, style: TextStyles.bold14Black),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: SizedBox(
                      width: 300,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomColoredButton.secondaryButtonWithText(context, 5, () => Navigator.pop(context), AppColors.bgColor, 'Cancel'),
                          CustomColoredButton.primaryButtonWithText(context, 5, () => singleTopUpAmount.text == '0.00' || singleTopUpAmount.text == '0' || singleTopUpAmount.text == '0.0' || singleTopUpAmount.text == '0.' ? null : _onTopUpPressed(), singleTopUpAmount.text == '0.00' || singleTopUpAmount.text == '0' || singleTopUpAmount.text == '0.0' || singleTopUpAmount.text == '0.' ? Colors.grey : AppColors.infoColor, 'Confirm'),
                        ],
                      ),
                    ),
                  ),
                  // CircleAvatar positioned to float outside the dialog
                  const Positioned(
                    top: -30, // Adjust the position to have half of it outside
                    child: CircleStepper(
                      borderColor: AppColors.infoColor,
                      secondBorderColor: AppColors.infoColor,
                      stepperColor: AppColors.infoColor,
                      padding: 10,
                      shadowColor: AppColors.infoColor,
                      child: CircleAvatar(
                        backgroundColor: AppColors.infoColor,
                        radius: 30,
                        child: Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  ///MIN AND MAX AMOUNT
  void _showMinMaxAmountDialog(BuildContext context, String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialogWidget(
        titleText: title,
        contentText: message,
        titleColor: AppColors.infoColor,
        iconColor: AppColors.whiteColor,
        iconData: Iconsax.info_circle_copy,
        positiveButtonText: 'Adjust Top-Up',
        positiveOnPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Widget formField;

  const LabeledTextField({
    required this.label,
    this.isRequired = false,
    required this.formField,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5, bottom: 3),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: TextStyles.normal12Maroon,
                ),
                if (isRequired)
                  const TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: CagabayColors.Main,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ),
        formField, // The form field is passed as a parameter
      ],
    );
  }
}
