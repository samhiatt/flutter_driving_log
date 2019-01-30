import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';

class Mileage extends StatelessWidget {
  
  Mileage(this.startMileage, this.endMileage);
  final int startMileage;
  final int endMileage;
  
  @override
  Widget build(BuildContext context) {
    return Column( // mileage
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(startMileage.toString()+" mi"),
        Text(endMileage==null? "":
                              endMileage.toString()+" mi"
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(top:BorderSide(color:Colors.black)),
          ),
          child: Text(endMileage==null? "  ":
          "total "+(endMileage - startMileage).toString()+" mi"
          ),
        ),
      ],
    );
    
  }
}