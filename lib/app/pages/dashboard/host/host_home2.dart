// import 'package:at_tareeq/app/controllers/host_controller.dart';
// import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
// import 'package:at_tareeq/app/widgets/host_lecture_list.dart';
// import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
// import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
// import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
// import 'package:at_tareeq/app/widgets/widgets.dart';
// import 'package:at_tareeq/core/styles/text_styles.dart';
// import 'package:at_tareeq/core/themes/colors.dart';
// import 'package:expandable/expandable.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// class HostHome extends GetView<HostController> {
//   const HostHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchLectures();
//     });
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: CustomColor.appBlue,
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(12),
//                 bottomRight: Radius.circular(12)),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(12),
//                 bottomRight: Radius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 52, 16, 32),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   BigText(
//                     // controller.animationDuration.toString(),
//                     // "ss",
//                     'Hi ${SharedPreferencesHelper.getName()},',
//                     color: Colors.white,
//                   ),
//                   SizedBox(
//                     height: 32,
//                   ),
//                   ExpandablePanel(
//                     controller: controller.expandableController,
//                     theme: ExpandableThemeData(
//                       tapBodyToExpand: true,
//                       tapBodyToCollapse: false,
//                     ),
//                     collapsed: GestureDetector(
//                       onTap: () {
//                         controller.expandableController.toggle();
//                       },
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           BigText(''),
//                         ],
//                       ),
//                     ),
//                     expanded: GridView(
//                         padding: const EdgeInsets.all(50),
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 70,
//                           mainAxisSpacing: 40,
//                           mainAxisExtent: Get.height / 6,
//                         ),
//                         // alignment: WrapAlignment.spaceEvenly,
//                         // runAlignment: WrapAlignment.spaceEvenly,
//                         children: [
//                           ...List.generate(controller.hostActions.length,
//                               (index) {
//                             final item = controller.hostActions[index];
//                             return GestureDetector(
//                               onTap: item.onTap,
//                               child: Container(
//                                 // height: 90,
//                                 // width: 50,
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     boxShadow: const [
//                                       BoxShadow(
//                                           color: Colors.black,
//                                           blurRadius: 20,
//                                           spreadRadius: .2)
//                                     ],
//                                     borderRadius: BorderRadius.circular(20)),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     item.icon,
//                                     const SizedBox(
//                                       height: 20,
//                                     ),
//                                     Text(item.title)
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }),
//                           // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: []),
//                           // Row(children: []),
//                         ]),
//                     builder: (_, collapsed, expanded) =>
//                         Expandable(collapsed: collapsed, expanded: expanded),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               BigText(
//                 "Recent Upload",
//                 fontSize: 18,
//               ),
//               MyButton(
//                   onTap: () {
//                     controller.expandableController.toggle();
//                   },
//                   child: AnimatedCrossFade(
//                       firstChild: const SmallText('Expand'),
//                       secondChild: const SmallText('Collapse'),
//                       crossFadeState: !controller.expandableController.expanded
//                           ? CrossFadeState.showFirst
//                           : CrossFadeState.showSecond,
//                       duration: controller.animationDuration))
//             ],
//           ),
//         ),
//         const Divider(
//           height: 4,
//         ),
//         /*  Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: controller.obx(
//               (state) => HostLecturesList(
//                 lectures: state!,
//               ),
//               onEmpty: const EmptyScreen(),
//               onError: (error) => const ErrorScreen(),
//               onLoading: const LoadingScreen(),
//             ),
//           ),
//         ),
//       */
//       ],
//     );
//   }
// }
