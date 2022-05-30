class StoryItemModel {

  late final int? id;
  late final String? title;
  late final String? description;

  StoryItemModel({
    this.id,
    this.title,
    this.description
  });

  StoryItemModel.fromMap(Map map) {
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