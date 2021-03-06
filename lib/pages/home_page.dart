import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_lecture1/bloc/todo_bloc.dart';
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
      create: (_) => TodoBloc(repository: TodoRepository()),
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
    BlocProvider.of<TodoBloc>(context).add(
      ListTodosEvent(),
    );
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
              child: BlocBuilder<TodoBloc, TodoState>(builder: (_, state) {
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
                                BlocProvider.of<TodoBloc>(context).add(
                                  DeleteTodoEvent(todo: item),
                                );
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
            // ?????? bloc??? ????????????, ?????? ????????????,
            // blocprovider??? ???????????? ?????? ??????
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TodoBloc>().add(
                CreateTodoEvent(title: this.title),
              );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
