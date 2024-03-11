import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mijs_todo/models/todo.dart';
import 'package:mijs_todo/todo/todo_form.dart';
import 'package:mijs_todo/utils/utils.dart';

class NewTodo extends StatelessWidget {
  const NewTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return TodoForm(
      onSave: _addTodo,
    );
  }

  Future<void> _addTodo(BuildContext context, Todo todo) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      await doProgress(context, () => todosRef(uid).add(todo));
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, "Unknown error");
      }
    }
  }
}
