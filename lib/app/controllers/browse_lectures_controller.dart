import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:at_tareeq/app/data/models/user.dart';
import 'package:at_tareeq/app/data/models/user_type.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/section_interest_repository.dart';
import 'package:at_tareeq/app/data/repositories/user_organization_repository.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class BrowseLecturesController extends GetxController {
  final _status = ProcessingStatus.initial.obs;
  ProcessingStatus get status => _status.value;
  final RxList<User> organizations = <User>[].obs;
  final RxList<SectionOrInterest> sections = <SectionOrInterest>[].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future fetchData() async {
    try {
      _status.value = ProcessingStatus.loading;
      sections.clear();
      organizations.clear();
      sections.addAll(await getSections());
      organizations.addAll(await getOrganizations());

      _status.value = ProcessingStatus.success;
      // recomendedLectures.refresh();
    } on DioError catch (e) {
      _status.value = ProcessingStatus.error;
      ApiClient.showErrorDialogue(e);
    } catch (err) {
      print(err);
      _status.value = ProcessingStatus.error;
      showErrorDialogue();
    }
  }

  Future<List<User>> getOrganizations() async {
    final query = {
      'filter': {
        'type': '${ServerUserTypes.host},${ServerUserTypes.verifiedHost},${ServerUserTypes.admin}'
        // 'type': '${ServerUserTypes.host},${ServerUserTypes.'
      }
    };
    return UserOrOrganizationTepository().fetchModels(query: query);
  }

  Future<List<SectionOrInterest>> getSections() async {
    return SectionOrInterestRepository().fetchModels();
  }
}
