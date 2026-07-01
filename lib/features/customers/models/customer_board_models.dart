import 'package:flutter/material.dart';
import '../../../database/database.dart';

enum CustomerRisk { clear, onTrack, overdue, overLimit }

class CustomerControlRow {
  final PeopleData customer;
  final double total;
  final DateTime? oldestDebtDate;
  final DateTime? dueDate;
  final int daysOverdue;
  final CustomerRisk risk;
  final CustomerMatrix matrix;

  const CustomerControlRow({
    required this.customer,
    required this.total,
    required this.oldestDebtDate,
    required this.dueDate,
    required this.daysOverdue,
    required this.risk,
    required this.matrix,
  });

  Color get riskColor {
    switch (risk) {
      case CustomerRisk.clear:
        return Colors.grey;
      case CustomerRisk.onTrack:
        return Colors.green.shade700;
      case CustomerRisk.overdue:
        return Colors.amber.shade800;
      case CustomerRisk.overLimit:
        return Colors.red.shade700;
    }
  }

  String get riskLabel {
    switch (risk) {
      case CustomerRisk.clear:
        return 'No balance';
      case CustomerRisk.onTrack:
        return 'On track';
      case CustomerRisk.overdue:
        return '$daysOverdue days overdue';
      case CustomerRisk.overLimit:
        return 'Over limit';
    }
  }

  List<MapEntry<String, double>> get topIndicators {
    final entries = matrix.columnTotals.entries
        .where((e) => e.value > 0.01)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.take(2).toList();
  }
}

class CustomerMatrix {
  final List<String> columns;
  final List<CustomerMatrixRow> rows;
  final Map<String, double> columnTotals;
  final double grandTotal;

  const CustomerMatrix({
    required this.columns,
    required this.rows,
    required this.columnTotals,
    required this.grandTotal,
  });
}

class CustomerMatrixRow {
  final String label;
  final String reference;
  final DateTime date;
  final DateTime? dueDate;
  final Map<String, double> values;

  const CustomerMatrixRow({
    required this.label,
    required this.reference,
    required this.date,
    this.dueDate,
    required this.values,
  });

  double get total => values.values.fold(0.0, (sum, v) => sum + v);
}
