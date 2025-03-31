import 'package:flutter/material.dart';
class ItemInSummaryPage extends StatefulWidget {
  ItemInSummaryPage({super.key, required this.prefixText, required this.text});
  String prefixText;
  String text;
  @override
  State<ItemInSummaryPage> createState() => _ItemInSummaryPageState();
}

class _ItemInSummaryPageState extends State<ItemInSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title:RichText(text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(text:'${widget.prefixText} ',style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
            TextSpan(text:'${widget.text}',),
          ],
        )),
        )
      ),
    );
  }
}
