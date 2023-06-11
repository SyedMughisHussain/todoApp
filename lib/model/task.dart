class Task {
  final int id;
  final String title;
  final String? description;
  final DateTime createdAt;
  Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
  });
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
  get userId => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
