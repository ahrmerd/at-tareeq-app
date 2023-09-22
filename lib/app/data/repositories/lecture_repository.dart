import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:dio/dio.dart';

class LectureRepository extends Repository<Lecture> {
  @override
  String resource = 'lectures';

  @override
  Lecture transformModel(data) {
    return Lecture.fromJson(data);
  }

  static Future<void> deleteLecture(Lecture lecture) async {
    await Dependancies.http.delete('lectures/${lecture.id}');
  }

  @override
  Paginator<Lecture> paginator({
    String? customPath,
    Query? query,
    List<Lecture> Function(dynamic)? customTransformer,
    int? perPage,
  }) {
    query ??= Query(perPage: perPage);
    query.addInclude("user");
    // query = Map<String, dynamic>.from(query ?? {});
    // query ??= {};
    // perPage != null ? (query['perPage'] = perPage) : {};
    Future<Response> dataFetcher(pageToFetch) async {
      query!.addPage(pageToFetch);
      // query!['page'] = pageToFetch;
      return await apiClient.get(customPath ?? resource,
          queryParameters: query.getQuery());
    }

    return Paginator<Lecture>(
        modelTransformer: customTransformer ?? transformModels,
        datafetcher: dataFetcher);
  }

  // @override
  @override
  Future<List<Lecture>> fetchModels(
      {Query? query,
      List<Lecture> Function(dynamic)? customTransformer}) async {
    query ??= Query();
    query.addInclude("user");
    // final newQuery = {...query, };
    final data =
        (await (apiClient.get(resource, queryParameters: query.getQuery())))
            .data['data'];
    if (customTransformer != null) {
      return customTransformer(data);
    }
    return transformModels(data);
  }

  @override
  List<Lecture> transformModels(data) {
    return lectureListFromJson(data);
  }
}
