import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mijs_todo/common/error.dart';
import 'package:mijs_todo/common/loading.dart';
import 'package:mijs_todo/models/todo.dart';
import 'package:mijs_todo/todo/edit_todo.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final todoStream = todosRef(uid).snapshots();

    return StreamBuilder<QuerySnapshot<Todo>>(
      stream: todoStream,
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot<Todo>> snapshot) {
        if (snapshot.hasError) {
          return ErrorPage(error: snapshot.error!);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }

        final todos = snapshot.data?.docs ?? [];

        return ListView(
          children: todos.map((e) {
            return Dismissible(
              key: Key(e.id),
              onDismissed: (direction) async {
                await todosRef(uid).doc(e.id).delete();
              },
              confirmDismiss: (direction) async {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete TODO"),
                      content: const Text(
                          "Are you sure you want to delete this todo item?"),
                      actions: [
                        SimpleDialogOption(
                          child: const Text("Yes"),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                        SimpleDialogOption(
                          child: const Text("No"),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                      ],
                    );
                  },
                );
              },
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
              ),
              child: ListTile(
                title: Text(e.data().title),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => EditTodo(todo: e.data()),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
