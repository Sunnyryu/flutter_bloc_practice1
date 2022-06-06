// cubit을 쓸떄는 필요가 없고 bloc을 쓸 때에는 필요한 dart 파일

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_lecture1/model/todo.dart';

@immutable
abstract class TodoEvent extends Equatable {}

// pagination 등의 작업이 없다면 크게 안바뀔뜻 여기서는?
class ListTodosEvent extends TodoEvent {
  @override
  List<Object> get props => [];
}

class CreateTodoEvent extends TodoEvent {
  // final Todo todo;
  final String title;

  CreateTodoEvent({required this.title});

  @override
  List<Object> get props => [this.title];
}

class DeleteTodoEvent extends TodoEvent {
  final Todo todo;

  DeleteTodoEvent({required this.todo});

  @override
  List<Object> get props => [this.todo];
}
