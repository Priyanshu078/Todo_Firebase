part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;
  AddTodo(this.todo);
  @override
  List<Object?> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  final int index;
  DeleteTodo(this.index);
  @override
  List<Object?> get props => [index];
}

class UpdateTodo extends TodoEvent {
  final Todo todo;
  final int index;
  UpdateTodo(this.todo, this.index);
  @override
  List<Object?> get props => [todo, index];
}
