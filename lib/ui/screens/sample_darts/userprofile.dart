// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../../../core/provider/user_provider.dart';
// import '../../shared/sessionmanagement/getuserinfo/getuserinfo.dart';
// import '../../shared/values/colors.dart';
// import '../../shared/values/styles.dart';
// import '../../shared/widget/containers/container.dart';
// import '../user_management/ui/screen_bases/full_screen.dart';
//
// class UserProfile extends StatefulWidget {
//   const UserProfile({Key? key}) : super(key: key);
//
//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }
//
// class _UserProfileState extends State<UserProfile> {
//   final fname = getFname();
//   final lname = getLname();
//   final urole = getUrole();
//   final insti = getInstitution();
//
//   File? _image;
//
//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _image = File(pickedImage.path);
//       });
//     }
//   }
//
//   Future<String?> _getImageBase64() async {
//     if (_image == null) return null;
//     final bytes = await _image!.readAsBytes();
//     return base64Encode(bytes);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FullScreen(
//       screenText: 'USER PROFILE',
//       content: SingleChildScrollView(
//         child: Wrap(
//           spacing: 10,
//           children: [
//             Column(
//               children: [
//                 profileWithPhotoContainer(),
//                 const SizedBox(height: 10),
//                 profileWithInstitutionContainer(),
//               ],
//             ),
//             // const SizedBox(width: 10),
//             profileWithInfoContainer()
//           ],
//         ),
//       ),
//       // content: Responsive(
//       //   desktop: Expanded(
//       //     child: Row(
//       //       children: [
//       //         Column(
//       //           children: [
//       //             Expanded(flex: 5, child: profileWithPhotoContainer()),
//       //             const SizedBox(height: 10),
//       //             Expanded(flex: 4, child: profileWithInstitutionContainer()),
//       //           ],
//       //         ),
//       //         const SizedBox(width: 10),
//       //         Expanded(flex: 8, child: profileWithInfoContainer())
//       //       ],
//       //     ),
//       //   ),
//       //   mobile: SingleChildScrollView(
//       //     child: Expanded(
//       //       child: Column(
//       //         children: [
//       //           Expanded(flex: 6, child: profileWithPhotoContainer()),
//       //           const SizedBox(height: 10),
//       //           Expanded(flex: 2, child: profileWithInstitutionContainer()),
//       //           const SizedBox(width: 10),
//       //           Expanded(flex: 2, child: profileWithInfoContainer()),
//       //         ],
//       //       ),
//       //     ),
//       //   ),
//       // ),
//       children: const [Spacer()],
//     );
//   }
//
//   //Upper Container with Profile Picture
//   Widget profileWithPhotoContainer() {
//     final userInfo = Provider.of<UserProvider>(context);
//     final screenWidth = MediaQuery.of(context).size;
//     List<Map<String, dynamic>> contactInfo = [
//       {'icon': Icons.work_outline, 'title': userInfo.position},
//       {'icon': Icons.email_outlined, 'title': userInfo.email},
//       {'icon': Icons.phone, 'title': userInfo.contact},
//     ];
//     return Card(
//       surfaceTintColor: AppColors.dialogColor,
//       shadowColor: AppColors.ngoColor,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5.0),
//       ),
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 300),
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 15),
//               Stack(
//                 children: [
//                   const CircleAvatar(
//                     backgroundImage: AssetImage('images/peralta.jpg'),
//                     maxRadius: 60,
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: InkWell(
//                       onTap: () {
//                         debugPrint('camera');
//                         pickImage();
//                       },
//                       child: Container(
//                           decoration: const BoxDecoration(
//                             color: Colors.white70,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Container(
//                             margin: const EdgeInsets.all(3),
//                             decoration: const BoxDecoration(
//                               color: AppColors.maroon3,
//                               shape: BoxShape.circle,
//                             ),
//                             child: IconButton(
//                               icon: const Icon(Icons.photo_camera),
//                               onPressed: () {},
//                               color: Colors.white,
//                               iconSize: 20,
//                             ),
//                           )),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               Text(
//                 '$fname $lname',
//                 style: const TextStyle(fontFamily: 'RobotoThin', color: Colors.black, letterSpacing: 0.5, fontSize: 13, fontWeight: FontWeight.bold),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: contactInfo.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ListTile(
//                         tileColor: Colors.teal,
//                         dense: true,
//                         leading: Icon(contactInfo[index]['icon'], color: AppColors.maroon3, size: 15),
//                         title: Text(contactInfo[index]['title'], style: TextStyles.dataTextStyle),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   //Lower Container with Contacts
//   Widget profileWithInstitutionContainer() {
//     final userInfo = Provider.of<UserProvider>(context);
//     final screenWidth = MediaQuery.of(context).size;
//     List<Map<String, dynamic>> titles = [
//       {'title': 'Institution', 'data': userInfo.institution},
//       {'title': 'Branch', 'data': userInfo.brCode},
//       {'title': 'Unit', 'data': userInfo.unitCode},
//       {'title': 'Center', 'data': userInfo.centerCode},
//     ];
//     return Card(
//       surfaceTintColor: AppColors.dialogColor,
//       shadowColor: AppColors.ngoColor,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5.0),
//       ),
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 300),
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: ListView.builder(
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             itemCount: titles.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     titles[index]['title'],
//                     textAlign: TextAlign.left,
//                     style: TextStyles.dataTextStyle,
//                   ),
//                   ContainerWidget(
//                       color: Colors.grey,
//                       borderRadius: 2,
//                       width: MediaQuery.of(context).size.width,
//                       height: 30,
//                       content: Text(
//                         titles[index]['data'],
//                         style: TextStyles.dataTextStyle,
//                       )),
//                   const SizedBox(height: 10),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget profileWithInfoContainer() {
//     return Card(
//       surfaceTintColor: AppColors.dialogColor,
//       shadowColor: AppColors.ngoColor,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5.0),
//       ),
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 300),
//         child: Column(
//           children: [
//             Container(
//               width: 100,
//               height: 250,
//               color: Colors.pink,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
