import 'package:at_tareeq/app/controllers/onboarding_controller.dart';
import 'package:at_tareeq/app/data/models/onboarding_page_item.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboarding extends StatelessWidget {
  Onboarding({Key? key}) : super(key: key);
  final _controller = OnBoardingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 120),
        child: PageViewBuilder(
          controller: _controller,
        ),
      ),
      bottomSheet: Container(
        color: lightColor,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() {
              return Stack(
                alignment: Alignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          _controller.onBoardingPages.length,
                          (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width:
                                    _controller.isCurrentPage(index) ? 15 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.grey,
                                ),
                                margin: const EdgeInsets.only(right: 6),
                              )),
                    ),
                  ),
                  if (!_controller.isLastPage)
                    Positioned(
                      right: 10,
                      child: GestureDetector(
                        onTap: _controller.navigateToNext,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Row(
                            children: [Text('Skip')],
                          ),
                        ),
                      ),
                    ),
                  // RichText(
                  //   text: TextSpan(
                  //     text: "Skip",
                  //     style: const TextStyle(color: Colors.black),
                  //     children: const [
                  //       WidgetSpan(
                  //           child: SizedBox(
                  //         width: 9,
                  //       )),
                  //       WidgetSpan(
                  //           child: Icon(
                  //         Icons.arrow_forward_ios,
                  //         size: 15,
                  //       ))
                  //     ],
                  //     // recognizer: tapGestureRecognizer..onTap = () {},
                  //   ),
                  // ),
                ],
              );
            }),
            Padding(
              // padding: EdgeInsets.all(0),
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _controller.forward,
                      child: Obx(() {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(9)),
                          child: Center(
                            child: Text(
                              _controller.isLastPage ? 'Get Started' : 'Next',
                              style: bigTextStyle.copyWith(color: Colors.white),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    // return SafeArea(
    //     child: Scaffold(

    //         body: Column(
    //   children: [
    //     Expanded(
    //       child: Container(
    //         child: PageViewBuilder(controller: _controller),
    //       ),
    //     ),
    //     Obx(() {
    //       return Stack(
    //         alignment: Alignment.center,
    //         // mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           // Spacer(),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 30),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: List.generate(
    //                   _controller.onBoardingPages.length,
    //                   (index) => AnimatedContainer(
    //                         duration: const Duration(milliseconds: 250),
    //                         width: _controller.isCurrentPage(index) ? 15 : 6,
    //                         height: 6,
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(3),
    //                           color: Colors.grey,
    //                         ),
    //                         margin: const EdgeInsets.only(right: 6),
    //                       )),
    //             ),
    //           ),
    //           if (!_controller.isLastPage)
    //             Positioned(
    //               right: 10,
    //               child: MyButton(
    //                 onTap: _controller.navigateToNext,
    //                 child: const Row(
    //                   children: [Text('Skip')],
    //                 ),
    //               ),
    //             ),
    //           // RichText(
    //           //   text: TextSpan(
    //           //     text: "Skip",
    //           //     style: const TextStyle(color: Colors.black),
    //           //     children: const [
    //           //       WidgetSpan(
    //           //           child: SizedBox(
    //           //         width: 9,
    //           //       )),
    //           //       WidgetSpan(
    //           //           child: Icon(
    //           //         Icons.arrow_forward_ios,
    //           //         size: 15,
    //           //       ))
    //           //     ],
    //           //     // recognizer: tapGestureRecognizer..onTap = () {},
    //           //   ),
    //           // ),
    //         ],
    //       );
    //     }),
    //     Padding(
    //       padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
    //       child: Row(
    //         children: [
    //           Expanded(
    //             child: GestureDetector(
    //               onTap: _controller.forward,
    //               child: Obx(() {
    //                 return Container(
    //                   padding: const EdgeInsets.all(20),
    //                   decoration: BoxDecoration(
    //                       color: primaryColor,
    //                       borderRadius: BorderRadius.circular(9)),
    //                   child: Center(
    //                     child: Text(
    //                       _controller.isLastPage ? 'Get Started' : 'Next',
    //                       style: bigTextStyle.copyWith(color: Colors.white),
    //                     ),
    //                   ),
    //                 );
    //               }),
    //             ),
    //           ),
    //         ],
    //       ),
    //     )
    //   ],
    // )));
  }
}

class PageViewBuilder extends StatelessWidget {
  const PageViewBuilder({
    super.key,
    required OnBoardingController controller,
  }) : _controller = controller;

  final OnBoardingController _controller;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _controller.pageController,
        onPageChanged: _controller.onPageIndex,
        itemCount: _controller.onBoardingPages.length,
        itemBuilder: (context, index) {
          OnBoardingPageItem pageItem = _controller.onBoardingPages[index];
          return pageItemBuilder(pageItem);
        });
  }

  Widget pageItemBuilder(OnBoardingPageItem item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Container(
          //   alignment: Alignment.center,
          //   // padding: EdgeInsets.all(10),
          //   width: 300,
          //   height: 300,
          //   child: Image.asset(item.imageAsset),
          // ),
          Image.asset(
            item.imageAsset,
            height: 400,
          ),
          const VerticalSpace(32),
          BigText(item.name),
          const VerticalSpace(16),
          SmallText(item.description, color: CustomColor.appBlue)

          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(18.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         item.name,
          //         style: biggestTextStyle,
          //         textWidthBasis: TextWidthBasis.longestLine,
          //       ),
          //       // Row(
          //       //   children: [],
          //       // ),
          //       VerticalSpace(),
          //       Text(
          //         item.description,
          //         style: bigTextStyle,
          //       ),
          //     ],
          //   ),
          // )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: List.generate(
          //       _controller.onBoardingPages.length,
          //       (index) => Obx(() {
          //             return Container(
          //               padding: EdgeInsets.all(10),
          //               margin: EdgeInsets.all(10),
          //               height: 10,
          //               width: 10,
          //               decoration: BoxDecoration(
          //                   color: _controller.onPageIndex.value == index
          //                       ? Colors.black
          //                       : Colors.red,
          //                   borderRadius: BorderRadius.circular(10)),
          //             );
          //           })),
          // ),
        ],
      ),
    );
  }
}
