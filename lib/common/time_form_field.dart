import 'package:flutter/material.dart';

class TimeFormField extends FormField<TimeOfDay> {
  TimeFormField({
    super.key,
    TimeOfDay? initialTime,
    required this.onChanged,
    super.onSaved,
    super.validator,
    super.restorationId,
  }) : super(
          initialValue: initialTime,
          builder: (field) {
            final context = field.context;
            final state = field as _TimeFormFieldState;
            final currentTime = state.value ?? TimeOfDay.now();

            return Row(
              children: [
                Expanded(
                  child: Text(
                      MaterialLocalizations.of(context)
                          .formatTimeOfDay(currentTime),
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: currentTime,
                    );
                    if (time != null) {
                      field.didChange(time);
                    }
                  },
                ),
              ],
            );
          },
        );

  final ValueChanged<TimeOfDay?>? onChanged;

  @override
  FormFieldState<TimeOfDay> createState() => _TimeFormFieldState();
}

class _TimeFormFieldState extends FormFieldState<TimeOfDay> {
  TimeFormField get _timeFormField => super.widget as TimeFormField;

  @override
  initState() {
    super.initState();
  }

  @override
  void didChange(TimeOfDay? value) {
    super.didChange(value);
    _timeFormField.onChanged!(value);
  }

  @override
  void reset() {
    super.reset();
    _timeFormField.onChanged!(value);
  }
}
