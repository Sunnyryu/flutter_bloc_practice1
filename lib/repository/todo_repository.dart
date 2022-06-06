import 'package:flutter_bloc_lecture1/model/todo.dart';

/// GET - ListTodo
/// POST - CreateTodo
/// DELETE - DeleteTodo

class TodoRepository {
  Future<List<Map<String, dynamic>>> listTodo() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        'id': 1,
        'title': 'Flutter learning',
        'createAt': DateTime.now().toString()
      },
      {
        'id': 2,
        'title': 'Dart learning',
        'createAt': DateTime.now().toString()
      },
    ];
  }

  Future<Map<String, dynamic>> createTodo(Todo todo) async {
    await Future.delayed(const Duration(seconds: 1));

    /// body - request - response - return 구조
    return todo.toJson();
  }

  Future<Map<String, dynamic>> deleteTodo(Todo todo) async {
    await Future.delayed(const Duration(seconds: 1));
    return todo.toJson();
  }
}
