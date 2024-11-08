import 'dart:convert';

class Task {
  final int status;
  final int id;
  final String content;

  Task({
    required this.status,
    required this.id,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'task_status': status,
      'id': id,
      'task_conteudo': content,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      status: map['task_status']?.toInt() ?? 0,
      id: map['id']?.toInt() ?? 0,
      content: map['task_conteudo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
