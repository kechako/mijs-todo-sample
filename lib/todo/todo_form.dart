import 'package:flutter/material.dart';
import 'package:mijs_todo/common/date_form_field.dart';
import 'package:mijs_todo/common/time_form_field.dart';
import 'package:mijs_todo/extensions/date_time.dart';
import 'package:mijs_todo/models/todo.dart';

typedef SaveTodoCallback = void Function(BuildContext context, Todo todo);

class TodoForm extends StatefulWidget {
  const TodoForm({super.key, this.todo, this.onSave});

  final Todo? todo;
  final SaveTodoCallback? onSave;

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title = "";
  String? _description;
  DateTime? _deadlineDate;
  bool _enableDeadlineDate = false;
  TimeOfDay? _deadlineTime;
  bool _enableDeadlineTime = false;

  @override
  void initState() {
    super.initState();

    final todo = widget.todo;
    if (todo != null) {
      _title = todo.title;
      _description = todo.title;
      final deadline = todo.deadline;
      if (deadline != null) {
        _deadlineDate = deadline.toDate();
        _enableDeadlineDate = true;
        if (todo.hasDeadlineTime) {
          _deadlineTime = TimeOfDay.fromDateTime(deadline);
          _enableDeadlineTime = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void submitSave() {
      _formKey.currentState!.save();
      if (_formKey.currentState!.validate()) {
        widget.onSave?.call(
            context,
            Todo(
              id: widget.todo?.id ?? '',
              title: _title,
              description: _description,
              deadline: _makeDeadline(),
              hasDeadlineTime: _deadlineTime != null,
            ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'New TODO' : 'Edit TODO'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton(
            onPressed: () => submitSave(),
            child: const Text(
              "Save",
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                initialValue: widget.todo?.title ?? '',
                validator: validateTodoTitle,
                onSaved: (String? text) {
                  _title = text ?? "";
                },
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                initialValue: widget.todo?.description ?? '',
                onSaved: (String? text) {
                  _description = text;
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Deadline'),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(child: Text('Date')),
                            Switch(
                              value: _enableDeadlineDate,
                              onChanged: (value) => setState(() {
                                if (value) {
                                  _deadlineDate = defaultDate();
                                } else {
                                  _deadlineDate = null;
                                }
                                _enableDeadlineDate = value;
                              }),
                            ),
                          ],
                        ),
                        if (_enableDeadlineDate)
                          DateFormField(
                            initialDate: _deadlineDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                            onChanged: (value) =>
                                setState(() => _deadlineDate = value),
                          )
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(child: Text('Time')),
                            Switch(
                              value: _enableDeadlineTime,
                              onChanged: (value) => setState(() {
                                if (value) {
                                  _deadlineTime = defaultTime();
                                  _enableDeadlineTime = true;
                                  if (!_enableDeadlineDate) {
                                    _deadlineDate = defaultDate();
                                    _enableDeadlineDate = true;
                                  }
                                } else {
                                  _deadlineTime = null;
                                  _enableDeadlineTime = false;
                                }
                              }),
                            ),
                          ],
                        ),
                        if (_enableDeadlineTime)
                          TimeFormField(
                            initialTime: _deadlineTime,
                            onChanged: (value) =>
                                setState(() => _deadlineTime = value),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime defaultDate() {
    return DateTime.now().toDate();
  }

  TimeOfDay defaultTime() {
    return TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)))
        .replacing(minute: 0);
  }

  DateTime? _makeDeadline() {
    if (_deadlineDate == null) {
      return null;
    }
    final time = _deadlineTime ?? const TimeOfDay(hour: 0, minute: 0);
    return _deadlineDate!.copyWith(hour: time.hour, minute: time.minute);
  }
}

String? validateTodoTitle(String? name) {
  if (name == null) {
    return null;
  }
  if (name.isEmpty) {
    return "Please input title";
  }

  return null;
}
