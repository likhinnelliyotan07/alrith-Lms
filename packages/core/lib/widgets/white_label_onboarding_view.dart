import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_gradients.dart';

class OnboardingPageData {
  final String title;
  final String description;
  final String lottieAsset;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.lottieAsset,
  });
}

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);
  void setPage(int index) => emit(index);
}

class WhiteLabelOnboardingView extends StatelessWidget {
  final List<OnboardingPageData> pages;
  final VoidCallback onFinish;
  final PageController _pageController = PageController();

  WhiteLabelOnboardingView({
    super.key,
    required this.pages,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) => context.read<OnboardingCubit>().setPage(index),
              itemBuilder: (context, index) {
                final page = pages[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        page.lottieAsset,
                        height: 300.h,
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        page.title,
                        style: AppTextStyles.h1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        page.description,
                        style: AppTextStyles.bodyM.secondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<OnboardingCubit, int>(
              builder: (context, currentPage) {
                return Positioned(
                  bottom: 50.h,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            height: 8.h,
                            width: currentPage == index ? 24.w : 8.w,
                            decoration: BoxDecoration(
                              color: currentPage == index 
                                ? Theme.of(context).primaryColor 
                                : AppColors.textTertiary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Container(
                          height: 56.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (currentPage == pages.length - 1) {
                                onFinish();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                              style: AppTextStyles.button,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
