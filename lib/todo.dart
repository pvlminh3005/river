import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

@immutable //read-only
class Todo {
  const Todo({
    required this.id,
    required this.description,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList(List<Todo>? initialTodo) : super(initialTodo ?? []);

  void add(String description) {
    state = [
      ...state,
      Todo(
        id: _uuid.v4(),
        description: description,
      ),
    ];
  }

  void toggle(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return Todo(
          id: todo.id,
          description: todo.description,
          completed: !todo.completed,
        );
      } else {
        return todo;
      }
    }).toList();
  }

  void edit({
    required String id,
    required String description,
  }) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
  }

  void remove(Todo target) =>
      state = state.where((todo) => todo.id != target.id).toList();
}
