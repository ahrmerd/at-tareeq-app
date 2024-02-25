import 'package:at_tareeq/app/bindings/add_lecture_binding.dart';
import 'package:at_tareeq/app/bindings/guest_binding.dart';
import 'package:at_tareeq/app/bindings/home_binding.dart';
import 'package:at_tareeq/app/bindings/host_binding.dart';
import 'package:at_tareeq/app/bindings/host_live_binding.dart';
import 'package:at_tareeq/app/bindings/listener_binding.dart';
import 'package:at_tareeq/app/bindings/login_binding.dart';
import 'package:at_tareeq/app/bindings/onboarding_binding.dart';
import 'package:at_tareeq/app/bindings/register_binding.dart';
import 'package:at_tareeq/app/controllers/download_controller.dart';
import 'package:at_tareeq/app/controllers/interest_lectures_controller.dart';
import 'package:at_tareeq/app/controllers/library_controller.dart';
import 'package:at_tareeq/app/controllers/listener_ivestream_controller.dart';
import 'package:at_tareeq/app/controllers/lives_controller.dart';
import 'package:at_tareeq/app/controllers/user_lectures_controller.dart';
import 'package:at_tareeq/app/pages/dashboard/guest/guest_dashboard.dart';
import 'package:at_tareeq/app/pages/dashboard/host/add_lecture_page.dart';
import 'package:at_tareeq/app/pages/dashboard/host/add_livestream.dart';
import 'package:at_tareeq/app/pages/dashboard/host/host_dashboard.dart';
import 'package:at_tareeq/app/pages/dashboard/host/host_livestream_page.dart';
import 'package:at_tareeq/app/pages/dashboard/host/my_lives_page.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/explore/interest_lectures_page.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/explore/user_lectures_page.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/library/download_page.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/library/download_player_page.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/library/library_lectures_page.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/listener_dashboard.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/lives_page.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/listener_livestream_page.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/playlists_page.dart';
import 'package:at_tareeq/app/pages/home.dart';
// import 'package:at_tareeq/app/pages/onboarding.dart';
import 'package:at_tareeq/app/pages/login.dart';
import 'package:at_tareeq/app/pages/register.dart';
import 'package:at_tareeq/app/pages/select_user_type.dart';
import 'package:get/get.dart';

import '../app/pages/onboard/onboarding.dart';

part 'routes.dart';

class Pages {
  Pages._();

  static const initial = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
      // middlewares: [AuthGuard()]
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => Onboarding(),
      binding: OnboardingBinding(),
      // middlewares: [AuthGuard()]
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.SELECTUSER,
      page: () => const SelectUserType(),
      // binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.GUESTDASHBOARD,
      page: () => const GuestDashboard(),
      binding: GuestBinding(),
    ),
    GetPage(
      name: Routes.HOSTDASHBOARD,
      page: () => const HostDashboard(),
      binding: HostBinding(),
    ),
    GetPage(
      name: Routes.LISTENERDASHBOARD,
      page: () => const ListenerDashboard(),
      binding: ListenerBinding(),
    ),
    GetPage(
      name: Routes.ADDLECTURE,
      page: () => const AddLecturePage(),
      binding: AddLectureBinding(),
    ),
    GetPage(
      name: Routes.ADDLIVE,
      page: () => const AddLivestream(),
      binding: HostLiveBinding(),
    ),
    GetPage(
      name: Routes.MYLIVE,
      page: () => const MyLivesPage(),
      binding: HostLiveBinding(),
    ),
    GetPage(
      name: Routes.HOSTLIVE,
      page: () => const HostLivestreamPage(),
      binding: HostLiveBinding(),
    ),
    GetPage(
      name: Routes.LIVES,
      page: () => const LivesPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LivesController>(() => LivesController());
      }),
    ),
    GetPage(
      name: Routes.STREAMPLAYER,
      page: () => const ListenerLivestreamPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ListenerLivestreamController>(
            () => ListenerLivestreamController());
      }),
    ),
    GetPage(
      name: Routes.INTERESTLECTURES,
      page: () => const InterestLecturesPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<InterestLecturesController>(
            () => InterestLecturesController());
      }),
    ),
    GetPage(
      name: Routes.USERLECTURES,
      page: () => const UserLecturesPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UserLecturesController>(() => UserLecturesController());
      }),
    ),
    GetPage(
      name: Routes.LIBRARYLECTURES,
      page: () => const LibraryLecturesPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LibraryController>(() => LibraryController());
      }),
    ),
    GetPage(
      name: Routes.DOWNLOADS,
      page: () => const DownloadsPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DownloadController>(() => DownloadController());
      }),
    ),
    GetPage(
      name: Routes.DOWNLOADSPLAYER,
      page: () => const DownloadPlayerPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DownloadController>(() => DownloadController());
      }),
    ),
    GetPage(
      name: Routes.PLAYLISTS,
      page: () => const PlaylistsPage(),
      // binding: BindingsBuilder(() {
      //   Get.lazyPut<PlaylistController>(() => PlaylistController());
      // }),
    ),
  ];
}
