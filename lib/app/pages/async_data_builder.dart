import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:flutter/material.dart';

class AsyncDataBuilder extends StatefulWidget {
  final ProcessingStatus status;
  final Widget? onLoading;
  final Widget? onInitial;
  final Widget? onError;
  final Widget content;
  final Future<void> Function() onRefresh;
  const AsyncDataBuilder(
      {super.key,
      required this.status,
      this.onLoading,
      this.onInitial,
      this.onError,
      required this.content,
      required this.onRefresh});

  @override
  State<AsyncDataBuilder> createState() => _AsyncDataBuilderState();
}

class _AsyncDataBuilderState extends State<AsyncDataBuilder> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (_) {
      switch (widget.status) {
        case ProcessingStatus.initial:
        // if (widget.onInitial != null){
        // // return widget.onInitial;

        // }
        case ProcessingStatus.loading:
          return widget.onLoading ?? const LoadingScreen();
        case ProcessingStatus.error:
          return ErrorScreen(
            onRetry: widget.onRefresh,
          );
        case ProcessingStatus.success:
          return RefreshIndicator(
              // key: Key(widget.filter.toString()),
              onRefresh: widget.onRefresh,
              child: widget.content);
      }
    });
  }
}
