import 'package:budget_manager/services/database_service.dart';
import 'package:flutter/material.dart';

class MonthPage extends StatefulWidget {
  const MonthPage({super.key, required this.monthId});
  final monthId;
  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: DatabseService.instance.getCategoriesForMonth(widget.monthId),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }else if(snapshot.hasError){
              return Text('Błąd: ${snapshot.error}');
            }else if(!snapshot.hasData || snapshot.data == null){
              return Text('Brak danych');
            }else{
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index)=>ListTile(
                    title: Text(snapshot.data![index]['month_id'].toString()),
                  ));
            }
          }),
    );
  }
}
