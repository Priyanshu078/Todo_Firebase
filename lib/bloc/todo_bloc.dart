import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../data/todos.dart';
part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoLoading([])) {
    on<FetchTodos>((event, emit) => fetchTodos(event, emit));
    on<AddTodo>((event, emit) => addTodos(event, emit));
    on<DeleteTodo>((event, emit) => deleteTodos(event, emit));
    on<UpdateTodo>((event, emit) => updateTodos(event, emit));
  }

  Future<void> fetchTodos(FetchTodos event, Emitter emit) async {
    print("hello");
    final todos = await FirebaseFirestore.instance.collection("todos").get();
    List<QueryDocumentSnapshot> docsList = todos.docs;
    List<Todo> todoList = [];
    for (int i = 0; i < docsList.length; i++) {
      todoList.add(Todo(docsList[i]["name"], docsList[i]['id']));
    }
    emit(TodosFetched(todoList));
  }

  void addTodos(AddTodo event, Emitter emit) {
    List<Todo> list = List.from(state.data);
    emit(TaskInProgress(list));
    List<Todo> todosData = List.from(state.data);
    todosData.add(event.todo);
    emit(TodoAdded(todosData));
  }

  void deleteTodos(DeleteTodo event, Emitter emit) {
    List<Todo> list = List.from(state.data);
    emit(TaskInProgress(list));
    List<Todo> todosData = List.from(state.data);
    todosData.removeAt(event.index);
    emit(TodoDeleted(todosData));
  }

  void updateTodos(UpdateTodo event, Emitter emit) {
    List<Todo> list = List.from(state.data);
    emit(TaskInProgress(list));
    List<Todo> todosData = List.from(state.data);
    todosData[event.index] = event.todo;
    emit(TodoUpdated(todosData));
  }
}
