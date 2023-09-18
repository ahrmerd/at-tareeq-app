import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/repositories/livestream_repository.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/pages/pagination_builder.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/lecture.dart';

class MyLivesPage extends StatelessWidget {
  const MyLivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Livestreams'),
        ),
        body: PaginationBuilder(
          paginator: getPaginator(),
          onSuccess: (scrollController, data, isFetchingMore, toRefresh) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,
                      itemCount: data.length,
                      itemBuilder: (_, index) {
                        final livestream = data[index] as Livestream;
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(Routes.HOSTLIVE,
                                  arguments: {'livestream': livestream});
                            },
                            leading: Text(livestream.status.getString()),
                            trailing:
                                Text(formatDateTime(livestream.startTime)),
                            title: Text(livestream.title),
                            subtitle: Text(livestream.description),
                          ),
                        );
                      }),
                ),
                if (isFetchingMore) CircularProgressIndicator(),
              ],
            );
          },
        ));
  }

  Paginator<Livestream> getPaginator() {
    return LivestreamRepository().paginator(
        customPath: 'livestreams/user',
        perPage: 10,
        query: {"include": "user"});
  }
}
