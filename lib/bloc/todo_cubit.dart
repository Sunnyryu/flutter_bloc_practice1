import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_lecture1/bloc/todo_state.dart';
import 'package:flutter_bloc_lecture1/model/todo.dart';
import 'package:flutter_bloc_lecture1/repository/todo_repository.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository repository;

  TodoCubit({required this.repository}) : super(Empty());

  // cubit은 일반 메소드를 사용해서 이벤트를 호출 할 수 있음

  listTodo() async {
    try {
      emit(Loading());
      // cubit의 emit은 yield와 비슷
      final resp = await this.repository.listTodo();

      final todos = resp.map<Todo>((e) => Todo.fromJson(e)).toList();

      emit(Loaded(todos: todos));
    } catch (e) {
      // 어떤 에러가 발생할 지 자세히 처리하면 되며, 여기서는 이렇게 처리함
      emit(Error(message: e.toString()));
    }
  }

  createTodo(String title) async {
    try {
      if (state is Loaded) {
        final parseState = (state as Loaded);

        final newTodo = Todo(
          // 밑에서 서버요청이 끝나고 난 후에 id, createAt은 server가 끝나는 시간으로 바꿔줘야하므로 .. 밑에서 loaded를 한번더 선언하여 맞춤
          id: parseState.todos[parseState.todos.length - 1].id + 1,
          title: title,
          createAt: DateTime.now().toString(),
        );
        // await this.repository보다 newtodo를 빠르게 선언하고자 한다면,
        final prevTodos = [...parseState.todos];

        final newTodos = [...prevTodos, newTodo];

        emit(Loaded(todos: newTodos));
        final resp = await this.repository.createTodo(newTodo);
        // JSON으로 넘어옴

        emit(Loaded(todos: [...prevTodos, Todo.fromJson(resp)]));
        // await this.repository.createTodo(newTodo);
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  deleteTodo(Todo todo) async {
    try {
      if (state is Loaded) {
        final newTodos = (state as Loaded)
            .todos
            .where((item) => item.id != item.id)
            .toList();
        //지우기전에 값을 보여주고 싶어서 whare.tolist사용
        emit(Loaded(todos: newTodos));

        await repository.deleteTodo(todo);
        // 삭제는 삭제후에 100% 다 되기에 create 처럼 추가적으로 작업을 안해도 돼요!
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
