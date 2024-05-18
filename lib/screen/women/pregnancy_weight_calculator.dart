import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import '../../widget/pregnancy_weight_table.dart';



class PregnancyWeightCalculator extends StatefulWidget {
  @override
  _PregnancyWeightCalculatorState createState() => _PregnancyWeightCalculatorState();
}

class _PregnancyWeightCalculatorState extends State<PregnancyWeightCalculator> {
  final _formKey = GlobalKey<FormState>();

  int _pregnancyWeek = 1;
  bool _isTwins = false;
  double _height = 0.0;
  double _prePregnancyWeight = 0.0;
  double _currentWeight = 0.0;

  List<Map<String, dynamic>> _weightChart = [];

  void _generateWeightChart() {
    _weightChart = [];
    double baseWeight = _prePregnancyWeight;

    for (int week = 1; week <= 40; week++) {
      double lowerBound = baseWeight + ((week - 1) * 0.5);
      double upperBound = baseWeight + ((week - 1) * 0.9);
      _weightChart.add({
        "week": week,
        "range": [lowerBound, upperBound],
      });
    }
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 24.9) return 'Normal Weight';
    if (bmi < 29.9) return 'Overweight';
    return 'Obese';
  }

  Map<String, double> calculateResults() {
    double bmi = _prePregnancyWeight / ((_height / 100) * (_height / 100));

    Map<String, dynamic> currentWeekData = _weightChart.firstWhere((weekData) => weekData["week"] == _pregnancyWeek);
    double lowerBound = currentWeekData["range"][0];
    double upperBound = currentWeekData["range"][1];

    double weightDifference = _currentWeight - upperBound;

    Map<String, dynamic> deliveryWeekData = _weightChart.firstWhere((weekData) => weekData["week"] == 40);
    double deliveryLowerBound = deliveryWeekData["range"][0];
    double deliveryUpperBound = deliveryWeekData["range"][1];

    return {
      "currentWeightDiff": weightDifference,
      "deliveryLowerBound": deliveryLowerBound,
      "deliveryUpperBound": deliveryUpperBound,
      "bmi": bmi,
    };
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pregnancy Weight Gain'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: PregnancyWeightTable(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SpinBox(
                min: 1,
                max: 40,
                value: _pregnancyWeek.toDouble(),
                onChanged: (value) => setState(() => _pregnancyWeek = value.toInt()),
              ),
              CheckboxListTile(
                title: Text("Pregnancy with twins"),
                value: _isTwins,
                onChanged: (bool? value) {
                  setState(() {
                    _isTwins = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
                onSaved: (value) => _height = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pre-pregnancy Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pre-pregnancy weight';
                  }
                  return null;
                },
                onSaved: (value) => _prePregnancyWeight = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Current Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current weight';
                  }
                  return null;
                },
                onSaved: (value) => _currentWeight = double.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      _generateWeightChart();
                    });
                    Map<String, double> results = calculateResults();
                    String bmiCategory = getBMICategory(results["bmi"]!);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                          'Recommended weight range for week $_pregnancyWeek: ${_weightChart[_pregnancyWeek - 1]["range"][0]} - ${_weightChart[_pregnancyWeek - 1]["range"][1]} kgs.\n'
                              'Your current weight is ${results["currentWeightDiff"]!.toStringAsFixed(1)} kgs higher than the upper bound.\n\n'
                              'Recommended weight range when delivering (40th week): ${results["deliveryLowerBound"]} - ${results["deliveryUpperBound"]} kgs.\n'
                              'Your BMI before pregnancy: ${results["bmi"]!.toStringAsFixed(1)} kg/m² ($bmiCategory).',
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
