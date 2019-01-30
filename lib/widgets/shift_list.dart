
import 'package:flutter/material.dart';
import 'mileage.dart';
import 'date_range.dart';
import 'job_list.dart';
import '../types/Shift.dart';

class ShiftList extends StatefulWidget {
  ShiftList({this.shifts = const [], this.selected=''});

  final List<Shift> shifts;
  final String selected;

  @override
  State<StatefulWidget> createState() => _ShiftListState(shifts, selected);
}

class _ShiftListState extends State<ShiftList> {
  _ShiftListState(this.shifts, this.selected);
  final List<Shift>shifts;
  String selected;

  @override
  void initState() {
    super.initState();
    setState(() {
      selected = widget.selected;
    });
  }

  @override
  Widget build(BuildContext context) {

  return
      Flexible(
        child: ListView.builder(
          itemBuilder: (context, position){
            Shift shift = widget.shifts[position];
            return Card(
              margin: EdgeInsets.only(left:7,right:7,top:3,bottom:3),
              child: RaisedButton(
                color: selected==shift.id? Colors.amberAccent.shade100 : Theme.of(context).cardColor,
                onPressed: (){
                  setState(() {
                    selected = shift.id;
                  });
                  print("Selected: "+selected+", "+shift.toString());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:[
                    TimeRangeDisplay(
                      startTime: shift.startTime,
                      endTime: shift.endTime
                    ),
                    JobList(shift),
                    ShiftSummary(shift),
                  ],
                ),
              ),
            );
          },
          itemCount: widget.shifts.length,
        ),
      );
  }
}

class ShiftSummary extends StatelessWidget {
  const ShiftSummary(this.shift);
  final Shift shift;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Row(
        children: <Widget>[
          Expanded(child: Mileage(shift.startMileage,shift.endMileage)),
//          Expanded(child: Text("\$"+shift.totalEarnings.toString(),textScaleFactor: 1.5,)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(shift.estimatedMpg.toStringAsFixed(1)+" mpg"),
              Text("\$"+shift.currentGasPrice.toStringAsFixed(3)+"/gal"),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
//              Text("\$"+shift.totalEarnings.toString(),textScaleFactor: 1.5,),
              Row(
                children: <Widget>[
                  Text("Total Earnings "),
                  Text(_dollarString(shift.totalEarnings),
                      textScaleFactor: 1.3,
                      style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Fuel Cost "),
                  Text(_dollarString(shift.estimatedGasExpense),
                      textScaleFactor: 1.3,
                      style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Net Earnings "),
                  Text(_dollarString(shift.netEarnings),
                    textScaleFactor: 1.5,
                    style: TextStyle(color: shift.netEarnings!=null&&shift.netEarnings>0? Colors.green : Colors.red),
                  ),
                ],
              ),
            ]
          ),
        ],
      ),
    );
  }
}

var _dollarString = (double s)=> s==null? "\$ - " :
  "\$"+s.toStringAsFixed(2);

