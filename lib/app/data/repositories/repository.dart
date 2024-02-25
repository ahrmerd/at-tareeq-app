import 'package:at_tareeq/app/data/models/pagination_info.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum Sorts { asc, desc }

class Query {
  final Set<String> _sorts = {};
  final Set _includes = <String>{};
  final _filters = <String, dynamic>{};
  int? _limit;
  int? _page;
  int? _perPage;
  int? _offset;

  Query({
    List<String>? sorts,
    List<String>? includes,
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
    int? page,
    int? perPage,
  })  : _offset = offset,
        _limit = limit,
        _perPage = perPage,
        _page = page {
    _sorts.addAll(sorts ?? <String>[]);
    _includes.addAll(includes ?? <String>[]);
    _filters.addAll(filters ?? {});
    // this.sorts??=sorts;
  }

  addSort(String field, Sorts direction) {
    switch (direction) {
      case Sorts.asc:
        _sorts.add(field);
        break;
      case Sorts.desc:
        _sorts.add("-$field");
        break;
    }
    return this;
  }

  addInclude(String field) {
    _includes.add(field);
    return this;
  }

  addFilter(String field, dynamic value) {
    _filters[field] = value;
    return this;
  }

  addLimit(int newLimit) {
    _limit = newLimit;
    return this;
  }

  addPage(int newPage) {
    _page = newPage;
    return this;
  }

  addPerPage(int newPerPage) {
    _perPage = newPerPage;
    return this;
  }

  addOffset(int newOffset) {
    _offset = newOffset;
    return this;
  }

  clearQuery() {
    clearFilters();
    clearSort();
    clearIncludes();
    clearLimit();
    clearOffset();
    clearPage();
    clearPerPage();
  }

  clearSort() {
    _sorts.clear();
  }

  clearIncludes() {
    _includes.clear();
  }

  clearFilters() {
    _filters.clear();
  }

  clearLimit() {
    _limit = null;
  }

  clearOffset() {
    _offset = null;
  }

  clearPage() {
    _page = null;
  }

  clearPerPage() {
    _perPage = null;
  }

  Map<String, dynamic> getQuery() {
    final query = <String, dynamic>{};
    if (_sorts.isNotEmpty) {
      query["sorts"] = _sorts.toList();
    }
    if (_includes.isNotEmpty) {
      query["include"] = _includes.toList();
    }
    if (_filters.isNotEmpty) {
      query["filter"] = _filters;
    }
    _limit != null ? query['limit'] = _limit : {};
    _offset != null ? query['offset'] = _offset : {};
    _page != null ? query['page'] = _page : {};
    _perPage != null ? query['perPage'] = _perPage : {};
    return query;
  }
}

class Paginator<T> {
  // final Future<List<T>>  datafetcher();
  final Future<Response> Function(int page) datafetcher;
  final List<T> Function(dynamic) modelTransformer;
  // int currentPage;
  PaginationInfo paginationInfo = PaginationInfo.createEmpty();

  bool get hasRemainingData =>
      !(paginationInfo.currentPage >= paginationInfo.lastPage);

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
      {Query? query, List<T> Function(dynamic)? customTransformer}) async {
    final data =
        (await (apiClient.get(resource, queryParameters: query?.getQuery())))
            .data['data'];
    if (customTransformer != null) {
      return customTransformer(data);
    }
    return transformModels(data);
  }

  Paginator<T> paginator({
    String? customPath,
    Query? query,
    List<T> Function(dynamic)? customTransformer,
    int? perPage,
  }) {
    query ??= Query(perPage: perPage);
    // query = Map<String, dynamic>.from(query ?? {});
    // query ??= {};
    // perPage != null ? (query['perPage'] = perPage) : {};
    Future<Response> dataFetcher(pageToFetch) async {
      query!.addPage(pageToFetch);
      // query!['page'] = pageToFetch;
      return await apiClient.get(customPath ?? resource,
          queryParameters: query.getQuery());
    }

    return Paginator<T>(
        modelTransformer: customTransformer ?? transformModels,
        datafetcher: dataFetcher);
  }

  Future<T> fetchModel(int id,
      {Query? query, T Function(dynamic)? customTransformer}) async {
    final data = (await (apiClient.get('$resource/$id',
            queryParameters: query?.getQuery())))
        .data['data'];
    if (customTransformer != null) {
      return customTransformer(data);
    }
    return transformModel(data);
  }

  Future<T> fetchModelFromCustomPath(String path,
      {Query? query,
      String? mapKey,
      T Function(dynamic)? customTransformer}) async {
    var data = (await (apiClient.get(path, queryParameters: query?.getQuery())))
        .data['data'];
    if (mapKey != null) {
      data = data[mapKey];
    }
    if (customTransformer != null) {
      return customTransformer(data);
    }
    return transformModel(data);
  }

  Future<List<T>> fetchModelsFromCustomPath(String path,
      {Query? query,
      List<T> Function(List<dynamic>)? customTransformer,
      String? mapKey}) async {
    var data = (await (apiClient.get(path, queryParameters: query?.getQuery())))
        .data['data'];
    if (mapKey != null) {
      data = data[mapKey];
    }
    if (customTransformer != null) {
      return customTransformer(data);
    }
    if (kDebugMode) {
      print(data);
    }
    return transformModels(data);
  }
}
