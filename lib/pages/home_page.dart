import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_lecture1/bloc/todo_bloc.dart';
import 'package:flutter_bloc_lecture1/bloc/todo_cubit.dart';
import 'package:flutter_bloc_lecture1/bloc/todo_event.dart';
import 'package:flutter_bloc_lecture1/bloc/todo_state.dart';
import 'package:flutter_bloc_lecture1/repository/todo_repository.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoCubit(repository: TodoRepository()),
      child: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String title = '';

  @override
  void initState() {
    super.initState();
    // ListTodosEvent
    BlocProvider.of<TodoCubit>(context).listTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "todo app",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(children: <Widget>[
            TextField(
              onChanged: (val) {
                this.title = val;
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: BlocBuilder<TodoCubit, TodoState>(builder: (_, state) {
                if (state is Empty) {
                  return Container();
                } else if (state is Loading) {
                  return Container(
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is Error) {
                  return Container(
                    child: Text(state.message),
                  );
                } else if (state is Loaded) {
                  final items = state.todos;
                  return ListView.separated(
                      itemBuilder: (_, index) {
                        final item = items[index];
                        return Row(
                          children: <Widget>[
                            Expanded(child: Text(item.title)),
                            GestureDetector(
                              child: const Icon(Icons.delete),
                              onTap: () {
                                BlocProvider.of<TodoCubit>(context)
                                    .deleteTodo(item);
                              },
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (_, index) => const Divider(),
                      itemCount: items.length);
                }
                return Container();
              }),
            ),
            // 어떤 bloc을 가져올지, 어떤 상태인지,
            // blocprovider를 불러오기 위해 사용
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TodoCubit>().createTodo(this.title);
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
