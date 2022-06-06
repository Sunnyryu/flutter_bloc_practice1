import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  factory Todo({
    required int id,
    required String title,
    required String createAt,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
