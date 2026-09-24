class Task {
  final String id;
  final String text;
  final String category;
  bool done;

  Task({
    required this.id,
    required this.text,
    required this.category,
    this.done = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        text: json['text'] as String,
        category: json['category'] as String,
        done: json['done'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'category': category,
        'done': done,
      };
}
