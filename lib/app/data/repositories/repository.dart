import 'package:at_tareeq/app/data/models/pagination_info.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';



class Paginator<T> {
  // final Future<List<T>>  datafetcher();
  final Future<Response> Function(int page) datafetcher;
  final List<T> Function(dynamic) modelTransformer;
  // int currentPage;
  PaginationInfo paginationInfo = PaginationInfo.createEmpty();

  bool get hasRemainingData =>
      !(paginationInfo.currentPage == paginationInfo.lastPage);

  List<T> allFetched = [];
  List<T> lastFetched = [];

  Paginator({required this.modelTransformer, required this.datafetcher});

  Future<List<T>> start() async {
    final res = await datafetcher(1);
    paginationInfo = PaginationInfo.fromJson(res.data['meta']);
    lastFetched = modelTransformer(res.data['data']);
    return allFetched = lastFetched;
    // return lastFetched;
  }

  Future<List<T>> fetchNext() async {

    if (hasRemainingData) {
      final nextPage = paginationInfo.currentPage + 1;
      final res = await datafetcher(nextPage);
      lastFetched = modelTransformer(res.data['data']);
      paginationInfo = PaginationInfo.fromJson(res.data['meta']);
      allFetched.addAll(lastFetched);
      return lastFetched;
    } else {
      return [];
    }
  }
}

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

  Paginator<T> paginate({
    Map<String, dynamic>? query,
    List<T> Function(dynamic)? customTransformer,
    int? perPage,
  }) {
    query = Map<String, dynamic>.from(query??{});
    // query ??= {};
    perPage != null ? (query['perPage'] = perPage) : {};
    Future<Response> dataFetcher(pageToFetch) async {
      print(pageToFetch);
      query!['page'] = pageToFetch;
      return await apiClient.get(resource, queryParameters: query);
    }

    return Paginator<T>(
        modelTransformer: customTransformer ?? transformModels,
        datafetcher: dataFetcher);

    // final data =
    //     (await (apiClient.get(resource, queryParameters: query))).data['data'];
    // if (customTransformer != null) {
    //   return customTransformer(data);
    // }
    // return transformModels(data);
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
