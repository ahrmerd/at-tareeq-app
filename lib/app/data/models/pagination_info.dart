// To parse this JSON data, do
//
//     final paginationInfo = paginationInfoFromJson(jsonString);

import 'dart:convert';

import 'package:at_tareeq/core/utils/helpers.dart';

PaginationInfo paginationInfoFromJson(String str) =>
    PaginationInfo.fromJson(json.decode(str));

String paginationInfoToJson(PaginationInfo data) => json.encode(data.toJson());

class PaginationInfo {
  int currentPage;
  int from;
  int lastPage;
  // List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  PaginationInfo({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    // required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) => PaginationInfo(
        currentPage: dynamicIntParsing(json["current_page"]),
        // currentPage: dynamicIntParsing(["current_page"]),
        from: dynamicIntParsing(json["from"]),
        lastPage: dynamicIntParsing(json["last_page"]),
        // links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: dynamicIntParsing(json["per_page"]),
        to: dynamicIntParsing(json["to"]),
        total: dynamicIntParsing(json["total"]),
      );

  factory PaginationInfo.createEmpty() => PaginationInfo(
      currentPage: 0,
      from: 1,
      lastPage: 1,
      path: '',
      perPage: 20,
      to: 1,
      total: 1);

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        // "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

// class Link {
//     String? url;
//     String label;
//     bool active;

//     Link({
//         required this.url,
//         required this.label,
//         required this.active,
//     });

//     factory Link.fromJson(Map<String, dynamic> json) => Link(
//         url: json["url"],
//         label: json["label"],
//         active: json["active"],
//     );

//     Map<String, dynamic> toJson() => {
//         "url": url,
//         "label": label,
//         "active": active,
//     };
// }