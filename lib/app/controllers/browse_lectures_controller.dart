import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:at_tareeq/app/data/models/user.dart';
import 'package:at_tareeq/app/data/models/user_type.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/data/repositories/section_interest_repository.dart';
import 'package:at_tareeq/app/data/repositories/user_organization_repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrowseLecturesController extends GetxController {
  final _status = ProcessingStatus.initial.obs;
  ProcessingStatus get status => _status.value;
  final RxList<User> organizations = <User>[].obs;
  final RxList<SectionOrInterest> sections = <SectionOrInterest>[].obs;
  Paginator<User>? organizationsPaginator;
  ScrollController organizationsScrollController = ScrollController();
  RxBool isLoadingMoreOrganizations = false.obs;

  @override
  void onInit() {
    fetchInitialData();
    super.onInit();
  }

  Future fetchInitialData() async {
    try {
      _status.value = ProcessingStatus.loading;
      sections.clear();
      organizations.clear();
      await fetchSections();
      // sections.addAll(await fetchSections());
      await fetchOrganizations();

      _status.value = ProcessingStatus.success;
      // recomendedLectures.refresh();
      attachScrollListener();
    } on Exception catch (e) {
      Dependancies.errorService.addErrorWithCallback(
          callback: () => _status.value = ProcessingStatus.error, exception: e);
    }
  }

  Future<void> fetchOrganizations([bool refresh = false]) async {
    final query = {
      'filter': {
        'type':
            '${ServerUserTypes.host},${ServerUserTypes.verifiedHost},${ServerUserTypes.admin}'
        // 'type': '${ServerUserTypes.host},${ServerUserTypes.'
      }
    };

    if (organizationsPaginator != null && !refresh) {
      // organizationsPaginator!.fetchNext();
      isLoadingMoreOrganizations.value = true;
      organizations.addAll(await organizationsPaginator!.fetchNext());
      isLoadingMoreOrganizations.value = false;
    } else {
      organizations.clear();
      organizationsPaginator =
          UserOrOrganizationTepository().paginator(query: query, perPage: 8);
      organizations.addAll(await organizationsPaginator!.start());
    }
    // return UserOrOrganizationTepository().fetchModels(query: query);
  }

  Future<void> fetchSections() async {
    sections.clear();
    sections.addAll(await SectionOrInterestRepository().fetchModels());
  }

  void attachScrollListener() {
    // print(organizationsScrollController);
    // if (organizationsScrollController.hasClients) {
    organizationsScrollController.addListener(() {
      if (organizationsScrollController.position.maxScrollExtent ==
          organizationsScrollController.position.pixels) {
        fetchOrganizations();
      }
    });
    // } else {
  }

  // @override
  // Future<void> onEndScroll() {
  //   // TODO: implement onEndScroll
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> onTopScroll() {
  //   // TODO: implement onTopScroll
  //   throw UnimplementedError();
  // }
}
