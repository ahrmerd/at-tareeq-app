import 'package:at_tareeq/app/controllers/pagination_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:flutter/material.dart';

class PaginationBuilder<T> extends StatefulWidget {
  final Widget? onLoading;
  // final Widget? onInitial;
  final Widget? onError;
  // final Widget content;
  // final Future<void> Function() onRefresh;
  final Widget Function(
          ScrollController scrollController, List data, bool isFetchingMore)
      onSuccess;

  final Paginator<T> paginator;
  const PaginationBuilder({
    super.key,
    this.onLoading,
    // this.onInitial,
    this.onError,
    // required this.content,
    // required this.onRefresh,
    required this.paginator,
    required this.onSuccess,
  });

  @override
  State<PaginationBuilder> createState() => _AsyncDataBuilderState<T>();
}

class _AsyncDataBuilderState<T> extends State<PaginationBuilder> {
  ProcessingStatus status = ProcessingStatus.initial;
  List<T> models = [];
  late ScrollController scroller;
  late Paginator<T> paginator;
  bool isLoadingMore = false;

  void setUp() {
    scroller = addOnScollFetchMore(() {
      fetchModels(false);
    });
  }

  @override
  initState() {
    paginator = widget.paginator as Paginator<T>;
    setUp();
    fetchModels(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (_) {
      switch (status) {
        case ProcessingStatus.initial:
        case ProcessingStatus.loading:
          return widget.onLoading ?? const LoadingScreen();
        case ProcessingStatus.error:
          return ErrorScreen(
            onRetry: () {
              fetchModels(true);
            },
          );
        case ProcessingStatus.success:
          return RefreshIndicator(
              // key: Key(widget.filter.toString()),
              onRefresh: () async {
                await fetchModels(true);
              },
              child: widget.onSuccess(scroller, models, isLoadingMore));
      }
    });
  }

  Future<void> fetchModels(bool isAfresh) async {
    try {
      if (isAfresh) {
        setState(() {
          status = ProcessingStatus.loading;
        });
        // change(null, status: RxStatus.loading());
        // List<Lectumodels = [];
        models = await paginator.start();
      } else {
        if (paginator.hasRemainingData) {
          setState(() {
            isLoadingMore = true;
          });
          models.addAll(await paginator.fetchNext());
          setState(() {
            isLoadingMore = false;
          });
        }
        // _isLoadingMore = false;
      }
      setState(() {
        status = ProcessingStatus.success;
      });
      // change(models, status: RxStatus.success());
    } on Exception catch (e) {
      Dependancies.errorService.addError(exception: e);
      setState(() {
        status = ProcessingStatus.success;
      });
    }
  }
}
