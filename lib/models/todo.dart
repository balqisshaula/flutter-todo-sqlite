class Todo {
  final int? id;
  final String title;
  final String description;
  final String createdAt;
  final bool isDone;
  final int? categoryId;
  final String? categoryName;

  const Todo({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isDone = false,
    this.categoryId,
    this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'isDone': isDone ? 1 : 0,
      'categoryId': categoryId,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      createdAt: map['createdAt'] as String,
      isDone: map['isDone'] == 1,
      categoryId: map['categoryId'] as int?,
      categoryName: map['categoryName'] as String?,
    );
  }

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    String? createdAt,
    bool? isDone,
    int? categoryId,
    String? categoryName,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isDone: isDone ?? this.isDone,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
