import 'dart:convert';

import 'package:flutter/foundation.dart';

class Job {
  final String name;
  final double payments;
  final int trips;
  final double tips;
  final double tipsCash;

  double get totalEarnings => payments + tips + tipsCash;

  const Job({
    @required this.name,
    @required this.payments,
    this.trips,
    this.tips = 0,
    this.tipsCash = 0,
  }): assert(name!=null,payments!=null);
}

class JobsDecoder extends Converter<List<dynamic>, List<Job>> {
  const JobsDecoder();

  @override
  List<Job> convert(List<dynamic> raw) {
    return raw==null? [] :
      raw.map((dynamic obj)=> Job(
          name:obj['name'],
          payments:obj['payments'].toDouble(),
          tips:obj['tips'].toDouble(),
          tipsCash:obj['tipsCash'].toDouble(),
          trips:obj['trips'].toDouble().floor(),
        ),
      ).toList();
  }
}