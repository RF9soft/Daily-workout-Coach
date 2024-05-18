import 'package:flutter/material.dart';

class PregnancyWeightTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pregnancy Weight Gain Table',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(3),
                },
                border: TableBorder.all(),
                children: [
                  _buildTableRow(['Prepregnancy BMI (kg/m²)', 'Category', 'Total Weight Gain Range', 'Total Weight Gain Range for Pregnancy with Twins']),
                  _buildTableRow(['<18.5', 'Underweight', '28-40 lbs', '-']),
                  _buildTableRow(['18.5-24.9', 'Normal Weight', '25-35 lbs', '37-54 lbs']),
                  _buildTableRow(['25.0-29.9', 'Overweight', '15-25 lbs', '31-50 lbs']),
                  _buildTableRow(['>30.0', 'Obese', '11-20 lbs', '25-42 lbs']),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells) {
    return TableRow(
      children: cells
          .map(
            (cell) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: Center(
            child: Text(
              cell,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}
