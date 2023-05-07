class Todo {
  String id;
  String name;
  Todo(this.name, this.id);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(json['name'], json['id']);
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "id": id};
  }
}
