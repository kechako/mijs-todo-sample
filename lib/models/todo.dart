import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mijs_todo/models/user.dart';

CollectionReference<Todo> todosRef(String uid) {
  return usersRef.doc(uid).collection("todos").withConverter<Todo>(
        fromFirestore: (snapshots, _) =>
            Todo.fromJson(snapshots.id, snapshots.data()!),
        toFirestore: (todo, _) => todo.toJson(),
      );
}

@immutable
class Todo {
  const Todo(
      {this.id = "",
      required this.title,
      this.description,
      this.deadline,
      this.hasDeadlineTime = false});

  Todo.fromJson(String id, Map<String, Object?> json)
      : this(
            id: id,
            title: json['title']! as String,
            description: json['description'] as String?,
            deadline: (json['deadline'] as Timestamp?)?.toDate(),
            hasDeadlineTime: json['hasDeadlineTime'] as bool? ?? false);

  final String id;
  final String title;
  final String? description;
  final DateTime? deadline;
  final bool hasDeadlineTime;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline,
      'hasDeadlineTime': deadline == null ? false : hasDeadlineTime,
    };
  }
}
