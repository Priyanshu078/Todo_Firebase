import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_firebase/bloc/todo_bloc.dart';
import 'package:todos_firebase/data/todos.dart';
import 'package:uuid/uuid.dart';

import 'widgets/todotext.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: TodoText(
          text: widget.title,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: height,
          width: width,
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodosFetched ||
                  state is TodoAdded ||
                  state is TodoDeleted ||
                  state is TodoUpdated ||
                  state is TaskInProgress) {
                return ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        child: Container(
                          height: height * 0.09,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.indigo,
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TodoText(
                                      text: state.data[index].name,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          String name = state.data[index].name;
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: TextFormField(
                                                      initialValue: name,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText: "todo"),
                                                      onChanged: (val) {
                                                        name = val;
                                                      },
                                                    ),
                                                    actions: [
                                                      BlocBuilder<TodoBloc,
                                                          TodoState>(
                                                        builder:
                                                            (context, state) {
                                                          if (state
                                                              is TaskInProgress) {
                                                            return Container();
                                                          } else {
                                                            return TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const TodoText(
                                                                  text: "Back",
                                                                  color: Colors
                                                                      .indigo,
                                                                ));
                                                          }
                                                        },
                                                      ),
                                                      BlocBuilder<TodoBloc,
                                                          TodoState>(
                                                        builder:
                                                            (context, state) {
                                                          if (state
                                                              is TaskInProgress) {
                                                            return const CircularProgressIndicator();
                                                          } else {
                                                            return TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Todo todo = Todo(
                                                                    name,
                                                                    state
                                                                        .data[
                                                                            index]
                                                                        .id);
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "todos")
                                                                    .doc(state
                                                                        .data[
                                                                            index]
                                                                        .id)
                                                                    .set(todo
                                                                        .toJson());
                                                                if (mounted) {
                                                                  context
                                                                      .read<
                                                                          TodoBloc>()
                                                                      .add(UpdateTodo(
                                                                          todo,
                                                                          index));
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }
                                                              },
                                                              child:
                                                                  const TodoText(
                                                                text: "Update",
                                                                color: Colors
                                                                    .indigo,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ));
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const TodoText(
                                                        text: "Are you sure?",
                                                        color: Colors.indigo),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const TodoText(
                                                            text: "No",
                                                            color:
                                                                Colors.indigo,
                                                          )),
                                                      BlocBuilder<TodoBloc,
                                                          TodoState>(
                                                        builder:
                                                            (context, state) {
                                                          if (state
                                                              is TaskInProgress) {
                                                            return const CircularProgressIndicator();
                                                          } else {
                                                            return TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "todos")
                                                                    .doc(state
                                                                        .data[
                                                                            index]
                                                                        .id)
                                                                    .delete();
                                                                if (mounted) {
                                                                  context
                                                                      .read<
                                                                          TodoBloc>()
                                                                      .add(DeleteTodo(
                                                                          index));
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }
                                                              },
                                                              child:
                                                                  const TodoText(
                                                                text: "Yes",
                                                                color: Colors
                                                                    .indigo,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ),
                    );
                  }),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 25,
        child: const Icon(
          Icons.add,
          color: Colors.indigo,
          size: 30,
        ),
        onPressed: () async {
          String name = "";
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: TextFormField(
                      decoration: const InputDecoration(hintText: "todo"),
                      onChanged: (val) {
                        name = val;
                      },
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const TodoText(
                            text: "Back",
                            color: Colors.indigo,
                          )),
                      TextButton(
                        onPressed: () async {
                          String id = const Uuid().v4();
                          Todo todo = Todo(name, id);
                          await FirebaseFirestore.instance
                              .collection("todos")
                              .doc(id)
                              .set(todo.toJson());
                          if (mounted) {
                            context.read<TodoBloc>().add(AddTodo(todo));
                            Navigator.of(context).pop();
                          }
                        },
                        child: const TodoText(
                          text: "Save",
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ));
        },
      ),
    );
  }
}
