List<SectionOrInterest> sectionOrInterestListFromJson(List<dynamic> json) =>
    json.map((data) => SectionOrInterest.fromJson(data)).toList();

class SectionOrInterest {
  SectionOrInterest({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.thumb,
  });

  int id;
  String name;
  String? description;
  DateTime createdAt;
  DateTime updatedAt;
  String? thumb;

  factory SectionOrInterest.fromJson(Map<String, dynamic> json) =>
      SectionOrInterest(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        thumb: json["thumb"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "thumb": thumb,
      };
}
