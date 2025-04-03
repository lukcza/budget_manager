import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ElementOfSummary extends StatefulWidget {
  ElementOfSummary({
    super.key,
    required this.title,
    required this.percentValue,
    required this.value,
    required this.color,
  });

  String title;
  double percentValue;
  double value;
  Color color;

  @override
  State<ElementOfSummary> createState() => _ElementOfSummaryState();
}

class _ElementOfSummaryState extends State<ElementOfSummary> {
  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      progressColor: widget.color,
      padding: EdgeInsets.all(4),
      width: MediaQuery.of(context).size.width,
      percent: widget.percentValue,
      lineHeight: 50,
      center: Text(
        "${widget.title} ${widget.value}",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      barRadius: Radius.circular(13),
    );
  }
}
