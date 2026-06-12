import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/src.dart';

class DatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final provider = context.read<HistoryOrderSupplier>();
        final range = provider.selectedRange;
        final picked = await showDateRangePicker(
          context: context,
          initialDateRange: range,
          firstDate: DateTime(2019),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          provider.selectedRange = picked;
        }
      },
      child: const Icon(Icons.date_range),
    );
  }
}
