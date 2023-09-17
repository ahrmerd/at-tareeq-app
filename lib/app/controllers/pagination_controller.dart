import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:flutter/material.dart';

abstract class PaginationController<T> {
  late Paginator<T> paginator;
  bool get isLoadingMore;
  List<T> models = [];
  ScrollController? scroller;

  Future<void> fetchModels(bool refetchAll);
}
