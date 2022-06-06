import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_lecture1/bloc/todo_event.dart';
import 'package:flutter_bloc_lecture1/bloc/todo_state.dart';
import 'package:flutter_bloc_lecture1/model/todo.dart';
import 'package:flutter_bloc_lecture1/repository/todo_repository.dart';

// generic 하게 써주기 위해 선언
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(
      // 안에다가 넣고 this를 해줘야 밖에서 선언할 떄보다 tdd가 편함
      {required this.repository})
      : super(Empty());
  // 가장 기본이 되는 state를 우측에 넣어줌 => 첨에 todoList를 만들면 아무것도 들어 있지 않음 => 그래서 여기선 기본이 Empty임

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    // 모든 함수들이 이 함수를 통해 실행??
    if (event is ListTodosEvent) {
      yield* _mapListTodosEvent(event);
    } else if (event is CreateTodoEvent) {
      yield* _mapCreateTodosEvent(event);
    } else if (event is DeleteTodoEvent) {
      yield* _mapDeleteTodosEvent(event);
    }
  }

// TodosEvent event로 써도 되지만 여기서는 이렇게 써도 굿!
  Stream<TodoState> _mapListTodosEvent(ListTodosEvent event) async* {
    //_mapListTodosEvent, _mapCreateTodosEvent, _mapDeleteTodosEvent가 ui와 가장 먼저 부딪히는 로직들임!
    try {
      yield (Loading());
      // yield를 이용해 state를 받을 수 있음
      // 먼저 로딩을 먼저하므로
      final resp = await this.repository.listTodo();

      final todos = resp.map<Todo>((e) => Todo.fromJson(e)).toList();

      yield Loaded(todos: todos);
    } catch (e) {
      // 어떤 에러가 발생할 지 자세히 처리하면 되며, 여기서는 이렇게 처리함
      yield Error(message: e.toString());
    }
  }

  Stream<TodoState> _mapCreateTodosEvent(CreateTodoEvent event) async* {
    try {
      if (state is Loaded) {
        final parseState = (state as Loaded);

        final newTodo = Todo(
          // 밑에서 서버요청이 끝나고 난 후에 id, createAt은 server가 끝나는 시간으로 바꿔줘야하므로 .. 밑에서 loaded를 한번더 선언하여 맞춤
          id: parseState.todos[parseState.todos.length - 1].id + 1,
          title: event.title,
          createAt: DateTime.now().toString(),
        );
        // await this.repository보다 newtodo를 빠르게 선언하고자 한다면,
        final prevTodos = [...parseState.todos];

        final newTodos = [...prevTodos, newTodo];

        yield Loaded(todos: newTodos);
        final resp = await this.repository.createTodo(newTodo);
        // JSON으로 넘어옴

        yield Loaded(todos: [...prevTodos, Todo.fromJson(resp)]);
        // await this.repository.createTodo(newTodo);
      }
    } catch (e) {
      yield Error(message: e.toString());
    }
  }

  Stream<TodoState> _mapDeleteTodosEvent(DeleteTodoEvent event) async* {
    try {
      if (state is Loaded) {
        final newTodos = (state as Loaded)
            .todos
            .where((todo) => todo.id != event.todo.id)
            .toList();
        //지우기전에 값을 보여주고 싶어서 whare.tolist사용
        yield Loaded(todos: newTodos);

        await repository.deleteTodo(event.todo);
        // 삭제는 삭제후에 100% 다 되기에 create 처럼 추가적으로 작업을 안해도 돼요!
      }
    } catch (e) {
      yield Error(message: e.toString());
    }
  }
}
