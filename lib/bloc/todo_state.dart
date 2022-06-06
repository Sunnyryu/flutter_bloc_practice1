import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_lecture1/model/todo.dart';

@immutable
abstract class TodoState extends Equatable {}

// 아무 state가 없을 때
class Empty extends TodoState {
  @override
  List<Object> get props => [];
}

// repository 실행 되었을 때
class Loading extends TodoState {
  @override
  List<Object> get props => [];
}

// error 발생시
class Error extends TodoState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [this.message];
}

// 정상적으로 로드가 될 시 에
class Loaded extends TodoState {
  final List<Todo> todos;

  Loaded({required this.todos});
  List<Object> get props => [this.todos];
}
