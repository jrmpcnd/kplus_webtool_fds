import 'package:flutter/material.dart';

import '../../values/colors.dart';
import '../../values/styles.dart';

class ContainerWidget extends StatelessWidget {
  final EdgeInsets? margin;
  final Color? color;
  final Color? shadowColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final Widget? content;
  final Color? borderColor;
  final double? borderWidth;
  const ContainerWidget({super.key, this.margin, required this.color, this.width, this.height, required this.borderRadius, this.content, this.shadowColor, this.borderColor, this.borderWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(0.0),
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(borderRadius), border: Border.all(color: borderColor ?? Colors.transparent, width: borderWidth ?? 1.0), boxShadow: [
        BoxShadow(
          color: shadowColor ?? Colors.transparent,
          offset: const Offset(0, 4), // Adjust the offset to have the shadow only at the bottom
          blurRadius: 12.0,
          spreadRadius: 2.0,
        )
      ]),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: content,
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget content;
  final double? width;
  final double? height;
  final Color? color;
  final VoidCallback? onTap;
  final double? padding;

  const CustomCard({Key? key, required this.content, this.width, this.height, this.color, this.onTap, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color ?? AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: content,
        ),
      ),
    );
  }
}

class MainBodyContainer extends StatelessWidget {
  final Widget? content;
  const MainBodyContainer({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    Size screenWidth = MediaQuery.of(context).size;
    // Size screenHeight = MediaQuery.of(context).size;

    return ContainerWidget(
      width: screenWidth.width * 0.91,
      height: 550,
      borderRadius: 5.0,
      color: AppColors.whiteColor,
      shadowColor: Colors.grey.shade400,
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.ngoColor, width: 5)),
          child: content,
        ),
      ),
    );
  }
}

class NoDataFound extends StatelessWidget {
  final String title;
  final String message;
  final String imagePath;

  const NoDataFound({
    super.key,
    required this.title,
    required this.message,
    this.imagePath = 'images/no_list.png', // Default image path
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = MediaQuery.of(context).size.width;
              double targetSize = screenWidth * 0.1; // 10% of screen width as the target size
              double size = constraints.maxWidth.clamp(targetSize, screenWidth * 0.18);
              return SizedBox(
                width: size,
                height: 150,
                child: Image(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
          Text(title, style: TextStyles.headingTextStyle),
          const SizedBox(height: 5),
          Center(child: Text(message, style: TextStyles.dataTextStyle)),
        ],
      ),
    );
  }
}

class NoUserFound extends StatelessWidget {
  const NoUserFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoDataFound(
      title: 'No User List Yet',
      message: 'Please add new user.',
    );
  }
}

class NoClientsFound extends StatelessWidget {
  const NoClientsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoDataFound(
      title: 'No List To Display Yet',
      message: 'You must select first the file of list to be displayed.',
    );
  }
}

class NoFileFound extends StatelessWidget {
  const NoFileFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoDataFound(
      title: 'File Not Found',
      message: 'There seems to be no file in the records.',
    );
  }
}

class NoRecordsFound extends StatelessWidget {
  const NoRecordsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoDataFound(
      title: 'Record Not Found',
      message: 'There seems to be no records.',
    );
  }
}
