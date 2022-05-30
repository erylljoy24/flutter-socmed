class FeedItemModel {

  late final int? id;
  late final String? title;
  late final String? description;

  FeedItemModel({
    this.id,
    this.title,
    this.description
  });

  FeedItemModel.fromMap(Map map) {
    id = map[id];
    title = map[title];
    description = map[description];
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
  };
}