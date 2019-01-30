import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../types/Shift.dart';
import '../types/Job.dart';

//var _doubleReducer = (double val, double el)=>(el==null)?val:el+val;

class JobList extends StatelessWidget {
  JobList(this.shift);
//        totalTrips = jobs.length==0? 0 : jobs.map((Job j)=>j.trips).reduce((int val, int el)=>el+val),
//        totalPayments = jobs.length==0? 0 : jobs.map((Job j)=>j.payments).reduce(_doubleReducer),
//        totalTips = jobs.length==0? 0 : jobs.map((Job j)=>j.tips).reduce(_doubleReducer),
//        totalTipsCash = jobs.length==0? 0 : jobs.map((Job j)=>j.tipsCash).reduce(_doubleReducer),
//        grandTotalEarnings = jobs.length==0? 0 : jobs.map((Job j)=>j.totalEarnings).reduce(_doubleReducer);
//  final List<Job> jobs;
//  final int totalTrips;
//  final double totalPayments;
//  final double totalTips;
//  final double totalTipsCash;
//  final double grandTotalEarnings;
    final Shift shift;

  @override
  Widget build(BuildContext context) {
//    return DataTable(
//      columns: [
//        DataColumn(label: Text("")),
//        DataColumn(label: Text("Trips")),
//        DataColumn(label: Text("Payments")),
//        DataColumn(label: Text("Tips")),
//        DataColumn(label: Text("Cash", style: Theme.of(context).textTheme.display2,)),
//        DataColumn(label: Text("Total")),
//      ],
//      rows: jobs.map((Job job) => DataRow(
//        cells: [
//          DataCell(Text(job.name)),
//          DataCell(Text(job.trips.toString())),
//          DataCell(Text("\$"+job.earnings.toStringAsFixed(2))),
//          DataCell(Text("\$"+job.tips.toStringAsFixed(2))),
//          DataCell(Text("\$"+job.tipsCash.toStringAsFixed(2))),
//          DataCell(Text("\$"+job.totalEarnings.toStringAsFixed(2))),
//        ],
//      )).toList(),
//    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(flex: 2, child: Text("")),
              Expanded(flex: 1, child: Text("Trips", textScaleFactor: .6, textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text("Payments", textScaleFactor: .6, textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text("Tips", textScaleFactor: .6, textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text("Cash", textScaleFactor: .6, textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text("Total", textScaleFactor: .6, textAlign: TextAlign.center)),
            ])
          ]+shift.jobs.map((Job job) =>
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 2, child: Text(job.name, textAlign: TextAlign.right, textScaleFactor: .7)),
                Expanded(flex: 1, child: RightAlignText(job.trips.toString())),
                Expanded(flex: 2, child: RightAlignText("\$"+job.payments.toStringAsFixed(2))),
                Expanded(flex: 2, child: RightAlignText("\$"+job.tips.toStringAsFixed(2))),
                Expanded(flex: 2, child: RightAlignText("\$"+job.tipsCash.toStringAsFixed(2))),
                Expanded(flex: 2, child: RightAlignText("\$"+job.totalEarnings.toStringAsFixed(2))),
              ],
            )
          ).toList()+[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 2, child: Text("")),
                Expanded(flex: 1, child: TotalRowValue(shift.totalTrips.toString())),
                Expanded(flex: 2, child: TotalRowValue("\$"+shift.totalPayments.toStringAsFixed(2))),
                Expanded(flex: 2, child: TotalRowValue("\$"+shift.totalTips.toStringAsFixed(2))),
                Expanded(flex: 2, child: TotalRowValue("\$"+shift.totalTipsCash.toStringAsFixed(2))),
//                Expanded(flex: 2, child: TotalRowValue("\$"+shift.totalEarnings.toStringAsFixed(2), textScaleFactor: 1.2,)),
                Expanded(flex: 2, child: TotalRowValue("")),
            ],
          ),
        ]
      ),
    );
  }
}

class TotalRowValue extends StatelessWidget {
  const TotalRowValue(this.value, {
    this.alignment=Alignment.centerRight,
    this.textScaleFactor=1.0,
  });
  final String value;
  final Alignment alignment;
  final double textScaleFactor;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(value, textScaleFactor: textScaleFactor,),
      decoration: BoxDecoration(
        border: Border(top:BorderSide(color:Colors.black)),
      ),
    );
  }
}
class RightAlignText extends StatelessWidget {
  const RightAlignText(this.value);
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(value),
    );
  }
}