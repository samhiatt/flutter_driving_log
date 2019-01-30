import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeRangeDisplay extends StatelessWidget {
  TimeRangeDisplay({this.startTime, this.endTime});
  final Timestamp startTime;
  final Timestamp endTime;

  final DateFormat dateFormat = DateFormat('MMM d, y');
  final DateFormat timeFormat = DateFormat('hh:mma');
  
  @override
  Widget build(BuildContext context) {
//    String duration = endTime==null? '' :
//      endTime.toDate().difference(startTime.toDate()).toString();
//    if (duration!='') duration = duration.substring(0, duration.lastIndexOf(':'));
    return Container(
      padding: EdgeInsets.all(7),
      child: Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: [
          Text(dateFormat.format(startTime.toDate().toLocal())),
          Text(timeFormat.format(startTime.toDate().toLocal())+
                (endTime!=null?
                " to "+ timeFormat.format(endTime.toDate().toLocal()) :
                  "")
          ),
//          Text(duration, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}