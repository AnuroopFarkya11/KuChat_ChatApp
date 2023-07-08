import 'package:flutter/material.dart';
import 'package:kuchat/Utils/theme_color/app_colors.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({Key? key, this.currentStep = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepProgressIndicator(
      totalSteps: 4,
      currentStep: currentStep,
      selectedColor: AppColor.kuWhite,
      unselectedColor: AppColor.kuWhite12,
      // gradientColor: LinearGradient(begin: Alignment.topLeft,end: Alignment.topRight,colors: [BrandColors.primaryColor,BrandColors.secondaryColor]),


    );
  }
}