part of 'todo_bloc.dart';

@immutable
abstract class TodoState extends Equatable {
  final List<Todo> data;
  const TodoState(this.data);
  @override
  List<Object?> get props => [data];
}

class TodoLoading extends TodoState {
  const TodoLoading(super.data);
  @override
  List<Object?> get props => [data];
}

class TodosFetched extends TodoState {
  const TodosFetched(super.data);
  @override
  List<Object?> get props => [data];
}

class TodoAdded extends TodoState {
  const TodoAdded(super.data);
  @override
  List<Object?> get props => [data];
}

class TodoDeleted extends TodoState {
  const TodoDeleted(super.data);
  @override
  List<Object?> get props => [data];
}

class TodoUpdated extends TodoState {
  const TodoUpdated(super.data);
  @override
  List<Object?> get props => [data];
}

class TaskInProgress extends TodoState {
  const TaskInProgress(super.data);
  @override
  List<Object?> get props => [data];
}
