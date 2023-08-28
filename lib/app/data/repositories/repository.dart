import 'package:at_tareeq/app/dependancies.dart';
import 'package:dio/dio.dart';

abstract class Repository<T> {
  abstract final String resource;
  List<T> transformModels(data);
  T transformModel(data);
  Dio apiClient = Dependancies.apiClient().req;
  // Future<List<T>> fetchModels(Map<String, dynamic>? query);
  // Future<T> fetchModel(int id, Map<String, dynamic>? query);

  // Future allRequest(String path, query) async {
  //   return (await (apiClient.get(path, queryParameters: query))).data['data'];
  // }

  Future<List<T>> fetchModels(
      {Map<String, dynamic>? query,
      List<T> Function(dynamic)? customTransformer}) async {
    final data =
        (await (apiClient.get(resource, queryParameters: query))).data['data'];
    if (customTransformer != null) {
      return customTransformer(data);
    }
    return transformModels(data);
  }

  Future<T> fetchModel(int id,
      {Map<String, dynamic>? query,
      T Function(dynamic)? customTransformer}) async {
    final data =
        (await (apiClient.get('$resource/$id', queryParameters: query)))
            .data['data'];
    if (customTransformer != null) {
      return customTransformer(data);
    }
    return transformModel(data);
  }

  Future<T> fetchModelFromCustomPath(String path,
      {Map<String, dynamic>? query,
      String? mapKey,
      T Function(dynamic)? customTransformer}) async {
    var data =
        (await (apiClient.get(path, queryParameters: query))).data['data'];
    if (mapKey != null) {
      data = data[mapKey];
    }
    if (customTransformer != null) {
      return customTransformer(data);
    }
    return transformModel(data);
  }

  Future<List<T>> fetchModelsFromCustomPath(String path,
      {Map<String, dynamic>? query,
      List<T> Function(List<dynamic>)? customTransformer,
      String? mapKey}) async {
    var data =
        (await (apiClient.get(path, queryParameters: query))).data['data'];
    if (mapKey != null) {
      data = data[mapKey];
    }
    if (customTransformer != null) {
      return customTransformer(data);
    }
    print(data);
    return transformModels(data);
  }
}
