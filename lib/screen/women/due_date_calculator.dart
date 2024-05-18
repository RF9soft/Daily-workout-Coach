import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DueDateCalculator extends StatefulWidget {
  @override
  _DueDateCalculatorState createState() => _DueDateCalculatorState();
}

class _DueDateCalculatorState extends State<DueDateCalculator> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _firstDayLastPeriod;
  int _cycleLength = 28;

  DateTime? _dueDate;
  int _pregnancyWeek = 0;
  int _pregnancyDays = 0;
  int _pregnancyMonths = 0;
  String _trimester = '';
  double _babyLengthInInches = 0.0;
  double _babyWeightInOunces = 0.0;
  DateTime? _conceptionDate;
  double _pregnancyProgress = 0.0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _firstDayLastPeriod) {
      setState(() {
        _firstDayLastPeriod = picked;
      });
    }
  }

  void calculateDueDate() {
    final estimatedDueDate = _firstDayLastPeriod!.subtract(Duration(days: 90)).add(Duration(days: 7));
    _dueDate = estimatedDueDate;

    final today = DateTime.now();
    final difference = today.difference(_firstDayLastPeriod!).inDays;

    _pregnancyWeek = (difference / 7).floor();
    _pregnancyDays = difference % 7;
    _pregnancyMonths = (difference / 30.44).floor();

    if (_pregnancyWeek < 14) {
      _trimester = 'first trimester';
    } else if (_pregnancyWeek < 28) {
      _trimester = 'second trimester';
    } else {
      _trimester = 'third trimester';
    }

    _babyLengthInInches = _pregnancyWeek < 4
        ? 0.1 + ((_pregnancyWeek * 0.2) + (_pregnancyDays / 7)) * 0.39
        : ((_pregnancyWeek - 4) * 0.2 + (_pregnancyDays / 7)) * 0.39;
    _babyWeightInOunces = _pregnancyWeek < 4 ? 0.035 : (_pregnancyWeek * 1.5) + (_pregnancyDays * 0.215);
    _conceptionDate = _firstDayLastPeriod!.subtract(Duration(days: 90));
    _pregnancyProgress = ((_firstDayLastPeriod!.difference(DateTime.now()).inDays) / 280) * 100;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Due Date Calculator'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    TextFormField(
    readOnly: true,
    decoration: InputDecoration(
    labelText: 'First Day of Your Last Period',
    suffixIcon: IconButton(
    onPressed: () => _selectDate(context),
    icon: Icon(Icons.calendar_today),
    ),
    ),
    validator: (value) {
    if (_firstDayLastPeriod == null) {
    return 'Please select the first day of your last period';
    }
    return null;
    },
    controller: TextEditingController(
    text: _firstDayLastPeriod != null ? DateFormat('MM/dd/yyyy').format(_firstDayLastPeriod!) : '',
    ),
    ),
    TextFormField(
    decoration: InputDecoration(labelText: 'Average Length of Your Cycles (Days)'),
    keyboardType: TextInputType.number,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter the average length of your cycles';
    }
    return null;
    },
    onSaved: (value) {
    _cycleLength = int.parse(value!);
    },
    ),
    SizedBox(height: 20),


    ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    calculateDueDate();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Result'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('The estimated due date is ${DateFormat('MMM dd, yyyy').format(_dueDate!)}'),
                              Text('You are currently at week #$_pregnancyWeek ($_pregnancyMonths months $_pregnancyDays days) of pregnancy.'),
                              Text('You are in the $_trimester.'),
                              Text('You are ${(_pregnancyProgress).abs().toStringAsFixed(0)}% of the way through your pregnancy.'),


                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
