import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'Job.dart';

const JobsDecoder _jobsDecoder = JobsDecoder();

class Shift extends Object {
  final String id;
  final Timestamp startTime;
  final Timestamp endTime;
  final int startMileage;
  final int endMileage;
  final double estimatedMpg;
  final double currentGasPrice;
  final List<Job> jobs;

  const Shift({
    @required this.startTime,
    @required this.startMileage,
    this.endTime,
    this.endMileage,
    this.id,
    this.estimatedMpg,
    this.currentGasPrice,
    this.jobs=const[],
  }): assert(startTime!=null,startMileage!=null);

  Shift.fromDocumentSnapshot(DocumentSnapshot doc):
    assert(doc.data['startTime']!=null),
    assert(doc.data['startMileage']!=null),
    this.id =  doc.documentID,
    this.startTime = doc.data['startTime'],
    this.endTime = doc.data['endTime'],
    this.startMileage = doc.data['startMileage'],
    this.endMileage = doc.data['endMileage'],
    this.estimatedMpg = doc.data['estimatedMpg'],
    this.currentGasPrice = doc.data['currentGasPrice'],
    this.jobs = doc.data['jobs']=_jobsDecoder.convert(doc.data['jobs']);

  double get totalPayments {
    var payments = jobs.map((Job j)=>j.payments);
    return payments.length==0? 0 :
      payments.reduce((double val, double element)=>element+val);
  }
  double get totalTips {
    var _tips = jobs.map((Job j)=>j.tips);
    return _tips.length==0? 0 :
      _tips.reduce((double val, double element)=>element+val);
  }
  double get totalTipsCash {
    var _tips = jobs.map((Job j)=>j.tipsCash);
    return _tips.length==0? 0 :
    _tips.reduce((double val, double el)=>el+val);
  }
  double get totalEarnings {
    return totalPayments + totalTips + totalTipsCash;
  }
  int get totalTrips {
    var _tips = jobs.map((Job j)=>j.trips);
    return _tips.length==0? 0 :
    _tips.reduce((int val, int element)=>element+val);
  }
  Duration get duration {
    return endTime==null? null: endTime.toDate().difference(startTime.toDate());
  }
  int get totalMiles {
    return endMileage==null? null :
      endMileage - startMileage;
  }
  double get estimatedGasExpense {
    return totalMiles==null || estimatedMpg==null || currentGasPrice==null? null :
      (totalMiles/estimatedMpg)*currentGasPrice;
  }
  double get netEarnings {
    if (totalEarnings==null||estimatedGasExpense==null) return null;
    return totalEarnings - estimatedGasExpense;
  }

  @override
  String toString() {

    return "Shift(id: "+id+
      ", startTime: "+startTime.toDate().toString()+
      ", endTime: "+(endTime==null?'':endTime.toDate().toString())+
      ", earnings: \$"+totalEarnings.toStringAsFixed(2)+
      ", duration: "+duration.toString()+
      ")";
  }
}