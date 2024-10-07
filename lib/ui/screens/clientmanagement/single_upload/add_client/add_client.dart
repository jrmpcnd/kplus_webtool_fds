import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mfi_whitelist_admin_portal/core/models/mfi_whitelist_admin_portal/addressModel.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/formatters/formatter.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/values/styles.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/fields/simplified_widget.dart';
import 'package:mfi_whitelist_admin_portal/ui/shared/widget/scrollable/scrollable_widget.dart';

import '../../../../../core/mfi_whitelist_api/clients/clients_api.dart';
import '../../../../../core/models/mfi_whitelist_admin_portal/civilStatusModel.dart';
import '../../../../../core/models/mfi_whitelist_admin_portal/clientModel.dart';
import '../../../../../main.dart';
import '../../../../shared/clock/clock.dart';
import '../../../../shared/utils/utils_responsive.dart';
import '../../../../shared/values/colors.dart';
import '../../../../shared/widget/alert_dialog/alert_dialogs.dart';
import '../../../../shared/widget/buttons/button.dart';
import '../../../../shared/widget/calendar/date_picker.dart';
import '../../../../shared/widget/containers/dialog.dart';
import '../../../../shared/widget/stepper/stepper_circle.dart';
import '../../../user_management/ui/screen_bases/header/header.dart';
import '../../../user_management/ui/screen_bases/header/header_CTA.dart';

class UploadSingleClient extends StatefulWidget {
  const UploadSingleClient({Key? key}) : super(key: key);

  @override
  State<UploadSingleClient> createState() => _UploadSingleClientState();
}

class _UploadSingleClientState extends State<UploadSingleClient> {
  late Future<List<RegionData>> _regionsFuture;
  late Future<List<RegionData>> _regionsFuturePermanent;
  late Future<List<ProvinceData>> _provincesFuture;
  late Future<List<CityMunicipalityData>> _citiesFuture;
  List<RegionData> _regions = [];
  List<RegionData> _regionsPermanent = [];
  List<ProvinceData> _provinces = [];
  List<ProvinceData> _provincesPermanent = [];
  List<CityMunicipalityData> _citiesMunicipalities = [];
  List<CityMunicipalityData> _citiesMunicipalitiesPermanent = [];
  String? _selectedRegion;
  String? _selectedRegionPermanent;
  String? _selectedProvince;
  String? _selectedProvincePermanent;
  String? _selectedCityMunicipality;
  String? _selectedCityMunicipalityPermanent;
  String? _selectedCityZipCode;
  String? _selectedCityZipCodePermanent;

  @override
  void initState() {
    super.initState();
    updateUrl('/Access/Single_Upload/Insert_Client');
    _regionsFuture = loadRegions(); // Initialize the Future for regions
    _regionsFuture.then((regions) {
      setState(() {
        _regions = regions; // Update state when regions are loaded
        debugPrint('Regions loaded: ${_regions.length}'); // Print the number of loaded regions
        for (var region in _regions) {
          debugPrint('Region: ${region.name}, Code: ${region.regionCode}'); // Print each region's name and code
        }
      });
    }).catchError((error) {
      debugPrint('Failed to load regions: $error');
    });

    _regionsFuturePermanent = loadRegionsPermanent();
    _regionsFuturePermanent.then((regions) {
      setState(() {
        _regionsPermanent = regions;
        debugPrint('Permanent Regions loaded: ${_regionsPermanent.length}');
        for (var region in _regionsPermanent) {
          debugPrint('Permanent Region: ${region.name}, Code: ${region.regionCode}');
        }
      });
    }).catchError((error) {
      debugPrint('Failed to load permanent regions: $error');
    });
  }

  Future<void> _loadProvinces(String regionCode) async {
    final provinces = await loadProvincesForRegion(regionCode);
    setState(() {
      _provinces = provinces; // Update state when provinces are loaded
      _selectedProvince = null; // Clear selected province when region changes
    });
  }

  Future<void> _loadCities(String provinceCode) async {
    final cities = _provinces.firstWhere((prov) => prov.provinceCode == provinceCode);
    setState(() {
      _citiesMunicipalities = cities.citiesMunicipalities ?? [];
      _selectedProvince = provinceCode;
    });
  }

  Future<void> _loadNCRCities(String regionCode) async {
    final region = _regions.firstWhere((reg) => reg.regionCode == regionCode);
    setState(() {
      _citiesMunicipalities = region.citiesMunicipalities ?? [];
      _selectedProvince = regionCode;
    });
  }

  String? _getZipCodeForCity(String cityCode) {
    return _citiesMunicipalities
        .firstWhere(
          (city) => city.cityCode == cityCode,
          orElse: () => CityMunicipalityData(name: '', cityCode: '', zipPostalCode: ''),
        )
        .zipPostalCode;
  }

  Future<void> _loadProvincesPermanent(String regionCode) async {
    final provincesPermanent = await loadProvincesForRegionPermanent(regionCode);
    setState(() {
      _provincesPermanent = provincesPermanent; // Update state when provinces are loaded
      _selectedProvincePermanent = null; // Clear selected province when region changes
    });
  }

  Future<void> _loadNCRCitiesPermanent(String regionCode) async {
    final region = _regionsPermanent.firstWhere((reg) => reg.regionCode == regionCode);
    setState(() {
      _citiesMunicipalitiesPermanent = region.citiesMunicipalities ?? [];
      _selectedProvincePermanent = regionCode;
    });
  }

  Future<void> _loadCitiesPermanent(String provinceCode) async {
    final citiesPermanent = _provincesPermanent.firstWhere((prov) => prov.provinceCode == provinceCode);
    setState(() {
      _citiesMunicipalitiesPermanent = citiesPermanent.citiesMunicipalities ?? [];
      _selectedProvincePermanent = provinceCode;
    });
  }

  String? _getZipCodeForCityPermanent(String cityCode) {
    return _citiesMunicipalitiesPermanent
        .firstWhere(
          (city) => city.cityCode == cityCode,
          orElse: () => CityMunicipalityData(name: '', cityCode: '', zipPostalCode: ''),
        )
        .zipPostalCode;
  }

  String concatPresentAddress(String city, String province, String region) {
    if (province == 'NA') {
      return '$city, $region';
    } else {
      return '$city, $province, $region';
    }
  }

  void _copyPresentAddressToPermanent() {
    setState(() {
      // Step 1: Copy Region from Present to Permanent
      singlePermanentAddRegion.text = singleAddRegion.text;
      _selectedRegionPermanent = _selectedRegion;

      // Load Provinces for the copied region
      if (_selectedRegionPermanent == '1300000000') {
        // Step 2: If region is NCR, load cities for NCR and set province to 'NA'
        _loadNCRCitiesPermanent(_selectedRegionPermanent!);
        _provincesPermanent = [];
        singlePermanentAddProvince.text = 'NA';
      } else {
        // Step 2: Load provinces for other regions
        _loadProvincesPermanent(_selectedRegionPermanent!).then((_) {
          // Step 3: After provinces are loaded, select the corresponding province
          singlePermanentAddProvince.text = singleAddProvince.text;
          _selectedProvincePermanent = _selectedProvince;

          // Step 4: After selecting the province, load cities for that province
          _loadCitiesPermanent(_selectedProvincePermanent!).then((_) {
            // Step 5: Once cities are loaded, select the corresponding city
            singlePermanentAddCity.text = singleAddCity.text;
            _selectedCityMunicipalityPermanent = _selectedCityMunicipality;
            _selectedCityZipCodePermanent = singleAddPostalCode.text;
          });
        });
      }
      singlePermanentAddPostalCode.text = singleAddPostalCode.text;
      singleAddPermanentAddress.text = singleAddPresentAddress.text;
      singleAddCombinedPermanentAddress.text = singleAddCombinedPresentAddress.text;
    });
  }

  void _clearPermanentAddressFields() {
    setState(() {
      singlePermanentAddRegion.text = '';
      singlePermanentAddProvince.text = '';
      singlePermanentAddCity.text = '';
      singlePermanentAddPostalCode.text = '';
      singleAddPermanentAddress.text = '';
      singleAddCombinedPermanentAddress.text = '';
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ///PERSONAL INFORMATION
  TextEditingController singleAddCID = TextEditingController();
  TextEditingController singleAddFirstName = TextEditingController();
  TextEditingController singleAddMiddleName = TextEditingController();
  TextEditingController singleAddLastName = TextEditingController();
  TextEditingController singleAddBirthdate = TextEditingController();
  TextEditingController singleAddPlaceOfBirth = TextEditingController();
  TextEditingController singleAddReligion = TextEditingController();
  TextEditingController singleAddCivilStatus = TextEditingController();
  TextEditingController singleAddCitizenship = TextEditingController();
  TextEditingController singleAddMobileNumber = TextEditingController();
  TextEditingController singleAddEmail = TextEditingController();

  ///ADDRESS INFORMATION
  TextEditingController singleAddRegion = TextEditingController();
  TextEditingController singleAddProvince = TextEditingController();
  TextEditingController singleAddCity = TextEditingController();
  TextEditingController singleAddPostalCode = TextEditingController();
  TextEditingController singlePermanentAddRegion = TextEditingController();
  TextEditingController singlePermanentAddProvince = TextEditingController();
  TextEditingController singlePermanentAddCity = TextEditingController();
  TextEditingController singlePermanentAddPostalCode = TextEditingController();
  TextEditingController singleAddPresentAddress = TextEditingController();
  TextEditingController singleAddCombinedPresentAddress = TextEditingController();
  TextEditingController singleAddPermanentAddress = TextEditingController();
  TextEditingController singleAddCombinedPermanentAddress = TextEditingController();

  ///MAIDEN INFORMATION
  TextEditingController singleAddSpouseFirstName = TextEditingController();
  TextEditingController singleAddSpouseMiddleName = TextEditingController();
  TextEditingController singleAddSpouseLastName = TextEditingController();
  TextEditingController singleAddMaidenFirstName = TextEditingController();
  TextEditingController singleAddMaidenMiddleName = TextEditingController();
  TextEditingController singleAddMaidenLastName = TextEditingController();

  ///INSTI-EMPLOYMENT INFORMATION
  TextEditingController singleAddInstiName = TextEditingController();
  TextEditingController singleAddBranchName = TextEditingController();
  TextEditingController singleAddUnitName = TextEditingController();
  TextEditingController singleAddCenterName = TextEditingController();
  TextEditingController singleAddMemberClassification = TextEditingController();
  TextEditingController singleAddSourceOfFund = TextEditingController();
  TextEditingController singleAddEmployOrBusinessName = TextEditingController();
  TextEditingController singleAddEmployOrBusinessAdd = TextEditingController();
  TextEditingController singleAddClientClassification = TextEditingController();

  int currentStep = 0;
  String singleAddGender = '';
  String singleAddClientIdentity = '';
  String status = '';

  ///BOOLEAN VALUES
  bool isValidated = false;
  bool isSameAsPresentAddress = false;
  // bool _hasError = false; //Used to validate dropdown menu\

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

  ///USED IN THE STEPPER CHANGE
  void _onStepContinue() async {
    if (isValidated) {
      if (currentStep == 0) {
        // API validation for the first step
        final cid = singleAddCID.text;
        final email = singleAddEmail.text;
        // Remove the leading zero from the mobile number if it exists
        String mobileNumber = singleAddMobileNumber.text;
        if (mobileNumber.startsWith('0')) {
          mobileNumber = mobileNumber.substring(1); // Remove the first character (leading zero)
        }

        final checkClientInfo = CheckExistingClientInfo();
        final response = await checkClientInfo.checkingExistingClient(cid, mobileNumber, email);

        if (response.statusCode == 404) {
          // API response is successful, proceed to the next step
          setState(() {
            if (currentStep < 3) {
              currentStep++;
            }
          });
        } else {
          // Show dialog if the response is not successful
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['data']; // Assuming this is a map
          final errorTitle = responseData['message'];
          showExistingDataAlertDialog(navigatorKey.currentContext!, errorMessage, errorTitle);
        }
      } else if (currentStep < 3) {
        // Proceed to the next step if not the first step
        setState(() {
          currentStep++;
          debugPrint('This is : ${currentStep.toString()} step');
        });
      }
    }
  }

  void _onStepCancel() {
    setState(() {
      if (currentStep > 0) {
        currentStep--;
      }
    });
  }

  ///USED IN THE STEPPER CHANGE

  ///USED IN THE ON CHANGED OF RADIO BUTTON
  void _onGenderChanged(String? value) {
    setState(() {
      singleAddGender = value!;

      if (value == 'Male') {
        singleAddMaidenFirstName.text = 'NA';
        singleAddMaidenMiddleName.text = 'NA';
        singleAddMaidenLastName.text = 'NA';
      } else if (value == 'Female') {
        singleAddSpouseFirstName.text = 'NA';
        singleAddSpouseMiddleName.text = 'NA';
        singleAddSpouseLastName.text = 'NA';
      }
    });
  }

  /// Call the corresponding widget for each stepper
  Widget _buildStepContent(int index) {
    switch (index) {
      case 0:
        return personalInformationForm();
      case 1:
        return addressInformationForm();
      case 2:
        return maidenInformationForm();
      case 3:
        return membershipAndEmploymentInformationForm();
      default:
        return const SizedBox.shrink();
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
            const HeaderBar(screenText: 'SINGLE UPLOADING'),
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
                // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9, maxHeight: MediaQuery.of(context).size.height * 0.),
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
                child: Responsive(
                  desktop: Row(
                    children: [stepperUploadSingleClient(), bodyUploadSingleClient()],
                  ),
                  mobile: Column(
                    children: [
                      bodyUploadSingleClient(),
                    ],
                  ),
                  tablet: Row(
                    children: [stepperUploadSingleClient(), bodyUploadSingleClient()],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///CONTAIN THE MAIN BODY
  Widget bodyUploadSingleClient() {
    // Get the title and content based on the index
    final data = getTitleAndContent(currentStep);
    double fontSize = (MediaQuery.sizeOf(context).width / 30);
    return Expanded(
      flex: 7,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHITELIST',
                  style: TextStyle(color: AppColors.maroon2, fontSize: fontSize.clamp(25, 40), fontFamily: 'RobotoThin', fontWeight: FontWeight.bold),
                ),
                const Text(
                  'MANAGEMENT SYSTEM',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'RobotoThin',
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.add_circle_outline_outlined,
                      color: AppColors.maroon2,
                      size: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'ADD CLIENT',
                      style: TextStyle(
                        color: AppColors.maroon2,
                        fontFamily: 'RobotoThin',
                        fontSize: 10,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            ///MOBILE STEPPER
            Responsive(mobile: mobileStepperUploadSingleClient(), tablet: const SizedBox.shrink(), desktop: const SizedBox.shrink()),

            /// Informational Forms
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title']!,
                    style: TextStyle(
                      color: AppColors.maroon2,
                      fontFamily: 'RobotoThin',
                      fontWeight: FontWeight.bold,
                      fontSize: (MediaQuery.sizeOf(context).width / 50).clamp(16, 20),
                    ),
                  ),
                  Text(
                    data['content']!,
                    style: TextStyles.dataTextStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                  child: _buildStepContent(currentStep),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Responsive(
                desktop: Row(
                  children: [
                    MyButton.previousButtonWithLabel(
                      context,
                      () => currentStep > 0 ? _onStepCancel() : null,
                      'Previous',
                      Icons.chevron_left,
                      currentStep > 0 ? AppColors.maroon2 : AppColors.maroon2.withOpacity(0.5), // Enable or disable color
                    ),
                    const Spacer(),
                    MyButton.nextButtonWithLabel(
                      context,
                      () => currentStep == 3
                          ? saveAllData()
                          : currentStep < 3
                              ? validateField()
                              : null,
                      currentStep == 3 ? 'Save' : 'Next',
                      currentStep == 3 ? Icons.save_outlined : Icons.chevron_right,
                      AppColors.maroon2,
                    ),
                  ],
                ),
                tablet: Row(
                  children: [
                    MyButton.previousButtonWithLabel(
                      context,
                      () => currentStep > 0 ? _onStepCancel() : null,
                      'Previous',
                      Icons.chevron_left,
                      currentStep > 0 ? AppColors.maroon2 : AppColors.maroon2.withOpacity(0.5), // Enable or disable color
                    ),
                    const Spacer(),
                    MyButton.nextButtonWithLabel(
                      context,
                      () => currentStep == 3
                          ? saveAllData()
                          : currentStep < 3
                              ? validateField()
                              : null,
                      currentStep == 3 ? 'Save' : 'Next',
                      currentStep == 3 ? Icons.save_outlined : Icons.chevron_right,
                      AppColors.maroon2,
                    ),
                  ],
                ),
                mobile: CustomColoredButton.primaryButtonWithText(
                    context,
                    5,
                    () => currentStep == 3
                        ? saveAllData()
                        : currentStep < 3
                            ? validateField()
                            : null,
                    AppColors.maroon2,
                    currentStep == 3 ? 'Save' : 'Next')),
          ],
        ),
      ),
    );
  }

  ///SIDE UI FOR THE STEPPER
  Widget stepperUploadSingleClient() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.maroon1.withOpacity(0.9), AppColors.maroon2, AppColors.maroon3, AppColors.maroon4], // Gradient colors
            begin: Alignment.topCenter, // Alignment for the start of the gradient
            end: Alignment.bottomCenter, // Alignment for the end of the gradient
          ),
          borderRadius: const BorderRadius.all(Radius.zero),
          image: const DecorationImage(
            image: AssetImage('/images/mwap_header_portrait.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScrollBarWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < 4; i++) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (i < currentStep)
                              GestureDetector(
                                onTap: () {
                                  // Navigate back to step 'i'
                                  setState(() {
                                    currentStep = i;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.toastColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 20,
                                      color: AppColors.toastColor,
                                    ),
                                  ),
                                ),
                              )
                            else if (i == currentStep)
                              CircleStepper(
                                borderColor: AppColors.maroon5,
                                secondBorderColor: AppColors.maroon5,
                                stepperColor: Colors.white70,
                                padding: 10,
                                shadowColor: Colors.white,
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyles.heavyBold20Black,
                                ),
                              )
                            else
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.maroon5,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${i + 1}',
                                    style: TextStyles.heavyBold20Black.copyWith(color: Colors.white70), // Placeholder text color for inactive steps
                                  ),
                                ),
                              ),
                            const SizedBox(width: 20),
                            Responsive(
                              desktop: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'STEP ${i + 1}',
                                    style: currentStep == i
                                        ? TextStyles.normal12White // Active step text style
                                        : TextStyles.normal12White.copyWith(color: Colors.white70), // Inactive step text style
                                  ),
                                  Text(
                                    _getStepDescription(i),
                                    style: currentStep == i
                                        ? TextStyles.bold18White // Active step description style
                                        : TextStyles.bold18White.copyWith(color: Colors.white70), // Inactive step description style
                                  ),
                                ],
                              ),
                              mobile: const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        if (i < 3)
                          Container(
                            margin: const EdgeInsets.fromLTRB(35, 10, 10, 10),
                            height: 40,
                            width: 2,
                            color: Colors.white54,
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mobileStepperUploadSingleClient() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < 4; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (i < currentStep)
                GestureDetector(
                  onTap: () {
                    // Navigate back to step 'i'
                    setState(() {
                      currentStep = i;
                    });
                  },
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.maroon2),
                  ),
                )
              else if (i == currentStep)
                Container(
                  width: 30,
                  height: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: AppColors.maroon2,
                  ),
                )
              else
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.maroon5.withOpacity(0.5)),
                )
            ],
          ),
          if (i < 3)
            Container(
              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              // height: 2,
              // width: 20,
              // color: Colors.black26,
            ),
        ],
      ],
    );
  }

  ///DYNAMIC VALUES FOR DISPLAY
// Define a function to get the title and content based on the index
  Map<String, String> getTitleAndContent(int index) {
    switch (index) {
      case 0:
        return {'title': 'Personal Information', 'content': "Fill out the client's primary information."};
      case 1:
        return {'title': 'Address', 'content': "Fill out the client's primary addresses."};
      case 2:
        return {'title': 'Family and Marital Information', 'content': "Provide the family and marital background information."};
      case 3:
        return {'title': 'Membership and Employment', 'content': "Provide the client's membership and employment data."};
      default:
        return {'title': 'No Defined Form', 'content': 'No form to display'};
    }
  }

  String _getStepDescription(int step) {
    switch (step) {
      case 0:
        return 'Personal Information';
      case 1:
        return 'Address';
      case 2:
        return 'Family Information';
      case 3:
        return 'Employment';
      default:
        return '';
    }
  }

  ///STEPPER 1: PERSONAL INFORMATION
  Widget personalInformationForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                title: '',
                hintText: '000-0000-000',
                prefixIcon: Icons.badge_outlined,
                controller: singleAddCID,
                validator: _validateField,
                inputFormatters: [NumbersOnlyFormatter()],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              LabeledTextField(
                label: 'First Name',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Juana',
                  nameField: true,
                  controller: singleAddFirstName,
                  validator: _validateField,
                ),
              ),
              LabeledTextField(
                label: 'Middle Name',
                isRequired: false,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Santos',
                  nameField: true,
                  controller: singleAddMiddleName,
                ),
              ),
              LabeledTextField(
                label: 'Last Name',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Dela Cruz',
                  nameField: true,
                  controller: singleAddLastName,
                  validator: _validateField,
                ),
              ),
              LabeledTextField(
                label: 'Birthdate',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: Icons.calendar_month_outlined,
                  controller: singleAddBirthdate,
                  onTap: () {
                    DateTime? currentDate;
                    if (singleAddBirthdate.text.isNotEmpty) {
                      currentDate = DateTime.tryParse(singleAddBirthdate.text);
                    }
                    final initialDate = currentDate ?? DateTime.now(); // Use the current date if the field is empty or invalid
                    showModalDatePicker(context, singleAddBirthdate, initialDate, 'Select Birthdate', false, () {});
                  },
                  validator: _validateField,
                ),
              ),
              LabeledTextField(
                label: 'Place of Birth',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Maniila, Philippines',
                  prefixIcon: Icons.place_outlined,
                  controller: singleAddPlaceOfBirth,
                  validator: _validateField,
                  inputFormatters: [CamelCaseFormatter()],
                ),
              ),
              Container(
                height: 60,
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5, bottom: 3),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Gender ',
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
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildRadioButton(
                          label: 'Male',
                          value: 'Male',
                          groupValue: singleAddGender,
                          onChanged: (String? value) {
                            setState(() {
                              singleAddGender = value!;
                              _onGenderChanged(value);
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        buildRadioButton(
                          label: 'Female',
                          value: 'Female',
                          groupValue: singleAddGender,
                          onChanged: (String? value) {
                            setState(() {
                              singleAddGender = value!;
                              _onGenderChanged(value);
                            });
                          },
                        ),
                        const Spacer(),
                        if (isValidated && singleAddGender == '') // Show error icon if validated and no gender selected
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.maroon4,
                            size: 20,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              LabeledTextField(
                label: 'Religion',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Roman Catholic',
                  prefixIcon: Icons.business_outlined,
                  controller: singleAddReligion,
                  validator: _validateField,
                  inputFormatters: [CamelCaseFormatter()],
                ),
              ),
              LabeledTextField(
                label: 'Citizenship',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Filipino',
                  prefixIcon: Icons.people_outline,
                  controller: singleAddCitizenship,
                  validator: _validateField,
                  inputFormatters: [CamelCaseFormatter()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              LabeledTextField(
                label: 'Mobile Number',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  mobileNumberField: true,
                  prefixIcon: Icons.phone_enabled,
                  controller: singleAddMobileNumber,
                  validator: (value) => _validateField(value, isMobileNumber: true),
                  inputFormatters: [DigitInputFormatter()],
                ),
              ),
              LabeledTextField(
                label: 'Email',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  emailAddressField: true,
                  validator: _validateField,
                  controller: singleAddEmail,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  ///STEPPER 2: ADDRESS INFORMATION
  Widget addressInformationForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Present Address',
            style: TextStyle(
              color: Colors.black87,
              fontFamily: 'RobotoThin',
              fontWeight: FontWeight.w700,
              fontSize: (MediaQuery.sizeOf(context).width / 50).clamp(14, 16),
            ),
          ),
          const SizedBox(height: 10),
          //PRESENT ADDRESS FIELDS
          Wrap(
            spacing: 20,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              // Dropdown for Region
              _regions.isNotEmpty
                  ? LabeledTextField(
                      label: 'Region',
                      isRequired: true,
                      formField: buildDropDownField(
                        title: '',
                        hintText: '--Select A Region--',
                        prefixIcon: Icons.location_on_outlined,
                        controller: singleAddRegion,
                        onChanged: (String? newValue) {
                          setState(() {
                            // Clear the selections and options for provinces and cities
                            singleAddProvince.text = '';
                            singleAddCity.text = '';
                            singleAddPresentAddress.text = '';
                            singleAddPostalCode.text = '';
                            _selectedRegion = null;
                            _selectedProvince = null;
                            _selectedCityMunicipality = null;
                            _provinces = [];
                            _citiesMunicipalities = [];

                            if (newValue != null) {
                              RegionData? selectedRegion;
                              try {
                                selectedRegion = _regions.firstWhere(
                                  (region) => region.name == newValue,
                                );
                                singleAddRegion.text = newValue;
                                _selectedRegion = selectedRegion.regionCode;

                                if (_selectedRegion == '1300000000') {
                                  // Load cities for NCR
                                  _loadNCRCities(_selectedRegion!);
                                  // Disable the province dropdown
                                  _provinces = [];
                                  singleAddProvince.text = 'NA';
                                } else {
                                  // Load provinces for other regions
                                  _loadProvinces(_selectedRegion!);
                                }
                              } catch (e) {
                                rethrow;
                              }
                            }
                          });
                        },
                        validator: _validateField,
                        items: _regions.map((region) => region.name).toList(),
                      ),
                    )
                  : const SizedBox.shrink(),

              // Dropdown for Province
              LabeledTextField(
                label: 'Province',
                isRequired: true,
                formField: buildDropDownField(
                  title: '',
                  hintText: _selectedRegion == '1300000000' ? 'NA' : '--Select A Province--',
                  prefixIcon: Icons.location_on_outlined,
                  controller: singleAddProvince,
                  onChanged: (String? newValue) {
                    setState(() {
                      // Clear the selection and options for cities
                      singleAddCity.text = '';
                      singleAddPresentAddress.text = '';
                      _selectedProvince = null;
                      _selectedCityMunicipality = null;
                      _citiesMunicipalities = [];

                      if (newValue != null) {
                        ProvinceData? selectedProvince;
                        try {
                          selectedProvince = _provinces.firstWhere(
                            (province) => province.name == newValue,
                          );
                          singleAddProvince.text = newValue;
                          _selectedProvince = selectedProvince.provinceCode;
                          _loadCities(selectedProvince.provinceCode); // Load cities for selected province
                        } catch (e) {
                          rethrow;
                        }
                      }
                    });
                  },
                  validator: _validateField,
                  items: _provinces.map((province) => province.name).toList(),
                ),
              ),

              // Dropdown for City/Municipality
              LabeledTextField(
                label: 'City/Municipality',
                isRequired: true,
                formField: buildDropDownField(
                  title: '',
                  hintText: '--Select A City/Municipality--',
                  prefixIcon: Icons.location_on_outlined,
                  controller: singleAddCity,
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        CityMunicipalityData? selectedCity;
                        try {
                          selectedCity = _citiesMunicipalities.firstWhere(
                            (city) => city.name == newValue,
                          );
                          singleAddCity.text = newValue;
                          _selectedCityMunicipality = selectedCity.cityCode;
                          _selectedCityZipCode = _getZipCodeForCity(selectedCity.cityCode);
                          singleAddPostalCode.text = _selectedCityZipCode ?? ''; // Update the postal code
                          singleAddCombinedPresentAddress.text = concatPresentAddress(singleAddCity.text, singleAddProvince.text, singleAddRegion.text); //Combine the value of city, province, and region
                        } catch (e) {
                          rethrow;
                        }
                      }
                    });
                  },
                  validator: _validateField,
                  items: _citiesMunicipalities.map((city) => city.name).toList(),
                ),
              ),

              LabeledTextField(
                label: 'Postal Code',
                isRequired: false,
                formField: buildTextFormField(
                  title: '',
                  hintText: '0000',
                  controller: singleAddPostalCode,
                  validator: _validateField,
                  enabled: false,
                ),
              ),

              LabeledTextField(
                label: 'Barangay',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: '',
                  controller: singleAddPresentAddress,
                  validator: _validateField,
                ),
              ),
            ],
          ),

          //PERMANENT ADDRESS FIELDS
          // Checkbox for Permanent Address
          const SizedBox(height: 20),
          Text(
            'Permanent Address',
            style: TextStyle(
              color: Colors.black87,
              fontFamily: 'RobotoThin',
              fontWeight: FontWeight.w700,
              fontSize: (MediaQuery.sizeOf(context).width / 50).clamp(14, 16),
            ),
          ),

          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.maroon2,
            checkColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Same as the Present Address',
              style: TextStyles.dataTextStyle,
            ),
            value: isSameAsPresentAddress,
            onChanged: (singleAddRegion.text.isNotEmpty && singleAddProvince.text.isNotEmpty && singleAddCity.text.isNotEmpty && singleAddPostalCode.text.isNotEmpty)
                ? (bool? value) {
                    setState(() {
                      isSameAsPresentAddress = value ?? false;

                      if (isSameAsPresentAddress) {
                        _copyPresentAddressToPermanent();
                      } else {
                        // Clear permanent address fields if checkbox is unticked
                        _clearPermanentAddressFields();
                      }
                    });
                  }
                : null, // Disable checkbox if singleAddPresentAddress is empty
            enabled: true, // Disable checkbox if address is empty
          ),

          Stack(
            children: [
              Wrap(
                spacing: 20,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  // Dropdown for Region
                  _regionsPermanent.isNotEmpty
                      ? LabeledTextField(
                          label: 'Region',
                          isRequired: true,
                          formField: buildDropDownField(
                            title: '',
                            hintText: '--Select A Region--',
                            prefixIcon: Icons.location_on_outlined,
                            controller: singlePermanentAddRegion,
                            onChanged: (String? newValue) {
                              setState(() {
                                // Clear the selections and options for provinces and cities
                                singlePermanentAddProvince.text = '';
                                singlePermanentAddCity.text = '';
                                singleAddPermanentAddress.text = '';
                                singlePermanentAddPostalCode.text = '';
                                singleAddCombinedPermanentAddress.text = '';
                                _selectedRegionPermanent = null;
                                _selectedProvincePermanent = null;
                                _selectedCityMunicipalityPermanent = null;
                                _provincesPermanent = [];
                                _citiesMunicipalitiesPermanent = [];

                                if (newValue != null) {
                                  RegionData? selectedPermanentRegion;
                                  try {
                                    selectedPermanentRegion = _regionsPermanent.firstWhere(
                                      (region) => region.name == newValue,
                                    );
                                    singlePermanentAddRegion.text = newValue;
                                    _selectedRegionPermanent = selectedPermanentRegion.regionCode;

                                    if (_selectedRegionPermanent == '1300000000') {
                                      // Load cities for NCR
                                      _loadNCRCitiesPermanent(_selectedRegionPermanent!);
                                      // Disable the province dropdown
                                      _provincesPermanent = [];
                                      singlePermanentAddProvince.text = 'NA';
                                    } else {
                                      // Load provinces for other regions
                                      _loadProvincesPermanent(_selectedRegionPermanent!);
                                    }
                                  } catch (e) {
                                    rethrow;
                                  }
                                }
                              });
                            },
                            validator: _validateField,
                            items: _regionsPermanent.map((region) => region.name).toList(),
                          ),
                        )
                      : const SizedBox.shrink(),

                  // Dropdown for Province
                  LabeledTextField(
                    label: 'Province',
                    isRequired: true,
                    formField: buildDropDownField(
                      title: '',
                      hintText: _selectedRegionPermanent == '1300000000' ? 'NA' : '--Select A Province--',
                      prefixIcon: Icons.location_on_outlined,
                      controller: singlePermanentAddProvince,
                      onChanged: (String? newValue) {
                        setState(() {
                          // Clear the selection and options for cities
                          singlePermanentAddCity.text = '';
                          singlePermanentAddPostalCode.text = '';
                          singleAddPermanentAddress.text = '';
                          singleAddCombinedPermanentAddress.text = '';
                          _selectedProvincePermanent = null;
                          _selectedCityMunicipalityPermanent = null;
                          _citiesMunicipalitiesPermanent = [];

                          if (newValue != null) {
                            ProvinceData? selectedPermanentProvince;
                            try {
                              selectedPermanentProvince = _provincesPermanent.firstWhere(
                                (province) => province.name == newValue,
                              );
                              singlePermanentAddProvince.text = newValue;
                              _selectedProvincePermanent = selectedPermanentProvince.provinceCode;
                              _loadCitiesPermanent(selectedPermanentProvince.provinceCode); // Load cities for selected province
                            } catch (e) {
                              rethrow;
                            }
                          }
                        });
                      },
                      validator: _validateField,
                      items: _provincesPermanent.map((province) => province.name).toList(),
                    ),
                  ),

                  // Dropdown for City/Municipality
                  LabeledTextField(
                    label: 'City/Municipality',
                    isRequired: true,
                    formField: buildDropDownField(
                      title: '',
                      hintText: '--Select A City/Municipality--',
                      prefixIcon: Icons.location_on_outlined,
                      controller: singlePermanentAddCity,
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue != null) {
                            CityMunicipalityData? selectedPermanentCity;
                            try {
                              selectedPermanentCity = _citiesMunicipalitiesPermanent.firstWhere(
                                (city) => city.name == newValue,
                              );
                              singlePermanentAddCity.text = newValue;
                              _selectedCityMunicipalityPermanent = selectedPermanentCity.cityCode;
                              _selectedCityZipCodePermanent = _getZipCodeForCityPermanent(selectedPermanentCity.cityCode);
                              singlePermanentAddPostalCode.text = _selectedCityZipCodePermanent ?? ''; // Update the postal code
                              singleAddCombinedPermanentAddress.text = concatPresentAddress(singlePermanentAddCity.text, singlePermanentAddProvince.text, singlePermanentAddRegion.text); //Combine the value of city, province, and region
                            } catch (e) {
                              rethrow;
                            }
                          }
                        });
                      },
                      validator: _validateField,
                      items: _citiesMunicipalitiesPermanent.map((city) => city.name).toList(),
                    ),
                  ),

                  LabeledTextField(
                    label: 'Postal Code',
                    isRequired: false,
                    formField: buildTextFormField(
                      title: '',
                      hintText: '0000',
                      controller: singlePermanentAddPostalCode,
                      validator: _validateField,
                      enabled: false,
                    ),
                  ),

                  LabeledTextField(
                    label: 'Barangay',
                    isRequired: true,
                    formField: buildTextFormField(
                      title: '',
                      hintText: '',
                      controller: singleAddPermanentAddress,
                      validator: _validateField,
                    ),
                  ),
                ],
              ),
              if (isSameAsPresentAddress == true)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  ///STEPPER 3: MARITAL INFORMATION
  Widget maidenInformationForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
            label: 'Civil Status',
            isRequired: true,
            formField: buildDropDownField(
              title: '',
              hintText: '--Select A Status--',
              prefixIcon: Icons.nature_people_outlined,
              controller: singleAddCivilStatus,
              onChanged: (String? newValue) {
                setState(() {
                  CivilStatusData? selectedCivilStatus;
                  try {
                    selectedCivilStatus = titles.firstWhere(
                      (civilStatus) => civilStatus.title == newValue,
                    );
                  } catch (e) {
                    rethrow;
                  }
                  if (selectedCivilStatus != null) {
                    singleAddCivilStatus.text = newValue!;
                  }
                });
              },
              validator: _validateField,
              items: titles.map((civilStatus) => civilStatus.title).toList(),
            ),
          ),
          // Container(
          //   height: 60,
          //   width: 350,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text(
          //         'Determine if the client is a: ',
          //         style: TextStyles.normal14Black,
          //       ),
          //       const SizedBox(height: 5),
          //       Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           const SizedBox(width: 10),
          //           buildRadioButton(
          //             label: 'Male',
          //             value: 'Male',
          //             groupValue: singleAddClientIdentity,
          //             onChanged: _onGenderChanged,
          //           ),
          //           const SizedBox(width: 10),
          //           buildRadioButton(
          //             label: 'Female',
          //             value: 'Female',
          //             groupValue: singleAddClientIdentity,
          //             onChanged: _onGenderChanged,
          //           ),
          //           const Spacer(),
          //           if (isValidated && singleAddClientIdentity == '') // Show error icon if validated and no gender selected
          //             const Icon(
          //               Icons.error_outline,
          //               color: AppColors.maroon4,
          //               size: 20,
          //             ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          if (singleAddCivilStatus.text != '')
            Stack(
              children: [
                if (singleAddGender == 'Male' && singleAddCivilStatus.text != 'Single')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spouse Maiden Information',
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'RobotoThin',
                                fontWeight: FontWeight.w700,
                                fontSize: (MediaQuery.sizeOf(context).width / 50).clamp(14, 16),
                              ),
                            ),
                            const Text(
                              "Provide the client's spouse maiden name.",
                              style: TextStyles.dataTextStyle,
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          LabeledTextField(
                            label: 'First Name',
                            isRequired: true,
                            formField: buildTextFormField(
                              title: '',
                              hintText: singleAddSpouseFirstName.text != 'NA' ? 'Maria' : 'NA',
                              nameField: true,
                              controller: singleAddSpouseFirstName,
                              validator: _validateField,
                            ),
                          ),
                          LabeledTextField(
                            label: 'Middle Name',
                            isRequired: false,
                            formField: buildTextFormField(
                              title: '',
                              hintText: singleAddSpouseMiddleName.text != 'NA' ? 'Cruz' : 'NA',
                              nameField: true,
                              controller: singleAddSpouseMiddleName,
                            ),
                          ),
                          LabeledTextField(
                            label: 'Last Name',
                            isRequired: true,
                            formField: buildTextFormField(
                              title: '',
                              hintText: singleAddSpouseLastName.text != 'NA' ? 'Mercado' : 'NA',
                              nameField: true,
                              controller: singleAddSpouseLastName,
                              validator: _validateField,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (singleAddGender == 'Female' && singleAddCivilStatus.text != 'Single')
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client Maiden Information',
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'RobotoThin',
                              fontWeight: FontWeight.w700,
                              fontSize: (MediaQuery.sizeOf(context).width / 50).clamp(14, 16),
                            ),
                          ),
                          const Text(
                            "Provide the client's maiden name.",
                            style: TextStyles.dataTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        LabeledTextField(
                          label: 'First Name',
                          isRequired: true,
                          formField: buildTextFormField(
                            title: '',
                            hintText: singleAddMaidenFirstName.text != 'NA' ? 'Juana' : 'NA',
                            nameField: true,
                            controller: singleAddMaidenFirstName,
                            validator: _validateField,
                          ),
                        ),
                        LabeledTextField(
                          label: 'Middle Name',
                          isRequired: false,
                          formField: buildTextFormField(
                            title: '',
                            hintText: singleAddMaidenMiddleName.text != 'NA' ? 'Agoncillo' : 'NA',
                            nameField: true,
                            controller: singleAddMaidenMiddleName,
                          ),
                        ),
                        LabeledTextField(
                          label: 'Last Name',
                          isRequired: true,
                          formField: buildTextFormField(
                            title: '',
                            hintText: singleAddMaidenMiddleName.text != 'NA' ? 'Santos' : 'NA',
                            nameField: true,
                            controller: singleAddMaidenLastName,
                            validator: _validateField,
                          ),
                        ),
                      ],
                    ),
                  ]),
              ],
            ),
        ],
      ),
    );
  }

  ///STEPPER 4: EMPLOYMENT INFORMATION
  Widget membershipAndEmploymentInformationForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Institutional Information',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'RobotoThin',
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
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              LabeledTextField(
                label: 'Institution Name',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'CARD, Inc.',
                  prefixIcon: Icons.business,
                  controller: singleAddInstiName,
                  validator: _validateField,
                ),
              ),
              LabeledTextField(
                label: 'Branch Name',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Main Branch',
                  prefixIcon: Icons.business,
                  controller: singleAddBranchName,
                  validator: _validateField,
                ),
              ),
              LabeledTextField(
                label: 'Unit Name',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Main Office',
                  prefixIcon: Icons.business,
                  controller: singleAddUnitName,
                  validator: _validateField,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              LabeledTextField(
                label: 'Center Name',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Magcase 3 SPC-5 Extension',
                  prefixIcon: Icons.business,
                  controller: singleAddCenterName,
                  validator: _validateField,
                ),
              ),
              // buildTextFormField(
              //   title: 'Member Classification',
              //   hintText: 'CARD, Inc.',
              //   prefixIcon: Icons.category,
              //   controller: singleAddMemberClassification..text = (singleAddMemberClassification.text.isEmpty) ? 'NA' : singleAddMemberClassification.text,
              //   validator: _validateField,
              // ),
              LabeledTextField(
                label: 'Client Classification',
                isRequired: true,
                formField: buildDropDownField(
                  title: '',
                  hintText: '--Select--',
                  prefixIcon: Icons.category,
                  controller: singleAddClientClassification,
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        singleAddClientClassification.text = newValue;
                      }
                    });
                  },
                  validator: _validateField,
                  items: ['Agent', 'Client'], // Only "Agent" or "Client" as items
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 40, 0, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Source of Income',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'RobotoThin',
                    fontWeight: FontWeight.w700,
                    fontSize: (MediaQuery.sizeOf(context).width / 50).clamp(14, 16),
                  ),
                ),
                const Text(
                  "Provide the client's primary income source.",
                  style: TextStyles.dataTextStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              LabeledTextField(
                label: 'Source of Fund',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Salary',
                  prefixIcon: Icons.money,
                  controller: singleAddSourceOfFund,
                  validator: _validateField,
                ),
              ),
              LabeledTextField(
                label: 'Employment or Business Name',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'Sari-Sari Store',
                  prefixIcon: Icons.business_center_outlined,
                  controller: singleAddEmployOrBusinessName,
                  validator: _validateField,
                ),
              ),
              LabeledTextField(
                label: 'Employment or Business Address',
                isRequired: true,
                formField: buildTextFormField(
                  title: '',
                  hintText: 'San Pablo City, Laguna',
                  prefixIcon: Icons.location_on_outlined,
                  controller: singleAddEmployOrBusinessAdd,
                  validator: _validateField,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ],
      ),
    );
  }

  ///VALIDATION OF VALUES
  void validateField() {
    setState(() {
      isValidated = true;
    });

    if (formKey.currentState!.validate()) {
      _onStepContinue();
    }

    // Additional check for the singleAddClientIdentity field
    else if (singleAddClientIdentity == '' || singleAddClientIdentity.isEmpty) {
      return; // Early exit if this field is not filled out
    }
  }

  void saveAllData() {
    if (formKey.currentState!.validate()) {
      showSingleAddClientAlertDialog(context);
    }
  }

  void submitForm() async {
    final clientData = ClientDataModel(
      cid: singleAddCID.text,
      firstName: singleAddFirstName.text,
      middleName: singleAddMiddleName.text,
      lastName: singleAddLastName.text,
      maidenFName: singleAddSpouseFirstName.text,
      maidenMName: singleAddSpouseMiddleName.text,
      maidenLName: singleAddSpouseLastName.text,
      mobileNumber: singleAddMobileNumber.text,
      birthday: singleAddBirthdate.text,
      placeOfBirth: singleAddPlaceOfBirth.text,
      religion: singleAddReligion.text,
      gender: singleAddGender,
      civilStatus: singleAddCivilStatus.text,
      citizenship: singleAddCitizenship.text,
      presentAddress: '${singleAddPresentAddress.text} ${singleAddCombinedPresentAddress.text}',
      permanentAddress: '${singleAddPermanentAddress.text} ${singleAddCombinedPermanentAddress.text}',
      city: singleAddCity.text,
      province: singleAddProvince.text,
      postalCode: singleAddPostalCode.text,
      memberMaidenFName: singleAddMaidenFirstName.text,
      memberMaidenMName: singleAddMaidenMiddleName.text,
      memberMaidenLName: singleAddMaidenLastName.text,
      email: singleAddEmail.text,
      institutionCode: singleAddInstiName.text,
      unitCode: singleAddUnitName.text,
      centerCode: singleAddCenterName.text,
      branchCode: singleAddBranchName.text,
      clientType: "1872",
      // memberClassification: singleAddMemberClassification.text,
      memberClassification: singleAddClientClassification.text,
      sourceOfFund: singleAddSourceOfFund.text,
      employerOrBusinessName: singleAddEmployOrBusinessName.text,
      employerOrBusinessAddress: singleAddEmployOrBusinessAdd.text,
      clientClassification: singleAddClientClassification.text,
    );
    debugPrint(singleAddCID.text);
    debugPrint(singleAddFirstName.text);
    debugPrint(singleAddMiddleName.text);
    debugPrint(singleAddLastName.text);
    debugPrint(singleAddSpouseFirstName.text);
    debugPrint(singleAddSpouseMiddleName.text);
    debugPrint(singleAddSpouseLastName.text);
    debugPrint(singleAddMobileNumber.text);
    debugPrint(singleAddBirthdate.text);
    debugPrint(singleAddPlaceOfBirth.text);
    debugPrint(singleAddReligion.text);
    debugPrint(singleAddGender);
    debugPrint(singleAddCivilStatus.text);
    debugPrint(singleAddCitizenship.text);
    debugPrint(singleAddPresentAddress.text);
    debugPrint(singleAddPermanentAddress.text);
    debugPrint(singleAddCity.text);
    debugPrint(singleAddProvince.text);
    debugPrint(singleAddPostalCode.text);
    debugPrint(singleAddMaidenFirstName.text);
    debugPrint(singleAddMaidenMiddleName.text);
    debugPrint(singleAddMaidenLastName.text);
    debugPrint(singleAddEmail.text);
    debugPrint(singleAddInstiName.text);
    debugPrint(singleAddUnitName.text);
    debugPrint(singleAddCenterName.text);
    debugPrint(singleAddBranchName.text);
    debugPrint(singleAddMemberClassification.text);
    debugPrint(singleAddSourceOfFund.text);
    debugPrint(singleAddEmployOrBusinessName.text);
    debugPrint(singleAddEmployOrBusinessAdd.text);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitFadingCircle(color: AppColors.dialogColor),
      ),
    );

    final insertClient = InsertSingleClient();
    final response = await insertClient.uploadSingleClient(clientData);

    Navigator.pop(navigatorKey.currentContext!);

    if (response.statusCode == 200) {
      debugPrint('Client successfully created');
      showSuccessAlertDialog(navigatorKey.currentContext!, 'A new client has been successfully added and is now pending approval by the checker.');
    } else {
      // Handle error case
      String errorMessage = jsonDecode(response.body)['message'];
      showGeneralErrorAlertDialog(navigatorKey.currentContext!, errorMessage);
    }
  }

  ///DIALOGS
  void showSingleAddClientAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialogWidget(
        titleText: "Adding New Client",
        contentText: "A new client will be added to the MFI Whitelist record.",
        positiveButtonText: "Proceed",
        negativeButtonText: "Cancel",
        negativeOnPressed: () {
          Navigator.of(context).pop();
        },
        positiveOnPressed: () async {
          Navigator.of(context).pop();
          submitForm();
        },
        iconData: Icons.info_outline,
        titleColor: AppColors.infoColor,
        iconColor: Colors.white,
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
