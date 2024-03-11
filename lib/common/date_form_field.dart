import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mijs_todo/extensions/date_time.dart';

class DateFormField extends FormField<DateTime> {
  DateFormField({
    super.key,
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    required this.onChanged,
    super.onSaved,
    super.validator,
    super.restorationId,
  }) : super(
          initialValue: initialDate,
          builder: (field) {
            final context = field.context;
            final state = field as _DateFormFieldState;
            final currentTime = state.value ?? DateTime.now().toDate();

            return Row(
              children: [
                Expanded(
                  child: Text(intl.DateFormat.yMMMEd().format(currentTime),
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final time = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      currentDate: currentDate,
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

  final ValueChanged<DateTime?>? onChanged;

  @override
  FormFieldState<DateTime> createState() => _DateFormFieldState();
}

class _DateFormFieldState extends FormFieldState<DateTime> {
  DateFormField get _dateFormField => super.widget as DateFormField;

  @override
  initState() {
    super.initState();
  }

  @override
  void didChange(DateTime? value) {
    super.didChange(value);
    _dateFormField.onChanged!(value!);
  }

  @override
  void reset() {
    super.reset();
    _dateFormField.onChanged!(value);
  }
}
