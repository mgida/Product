import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_task/model/task.dart';
import 'package:my_task/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  // final int id;

  TaskDetailScreen(this.task);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  int num = 0;
  double remain ;

  Future<void> addPaidNumToSF(int num, double remain, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('$id', num);
      print('added $num');
      prefs.setDouble('${id}K', remain);
    });
  }

  Future<int> readPaidNumFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      num = prefs.getInt('${widget.task.id}') ?? 0;
      print('readed $num');
    });
    return num;
  }

  Future<double> readRemainedPriceFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      remain = prefs.getDouble('${widget.task.id}K') ?? widget.task.price;
      print('remain $remain');
    });
    return remain;
  }

  _onBasicAlertPressed(context, String name) {
    Alert(
      context: context,
      title: "$name",
      desc: "تم الدفع",
    ).show();
  }

  @override
  void initState() {
    super.initState();
    readPaidNumFromSF().then((value) {
      return num = value ?? 0;
    });
    readRemainedPriceFromSF().then((value) => remain = value ?? widget.task.price);
    print('id is ${widget.task.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(right: 6.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(

                      '${widget.task.name}',
                      textAlign: TextAlign.end,
                      style: kTextDetailEnteredStyle,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    ':الاسم',
                    textAlign: TextAlign.end,
                    style: kTextDetailStyle.copyWith(
                        color: Colors.lightBlueAccent),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${widget.task.phone}',
                    style: kTextDetailEnteredStyle,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    ':التليفون',
                    textAlign: TextAlign.end,
                    style: kTextDetailStyle.copyWith(
                        color: Colors.lightBlueAccent),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${widget.task.product}',
                    textAlign: TextAlign.end,
                    style: kTextDetailEnteredStyle,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    ':المنتج',
                    textAlign: TextAlign.end,
                    style: kTextDetailStyle.copyWith(
                        color: Colors.lightBlueAccent),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${widget.task.price}',
                    style: kTextDetailEnteredStyle,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    ':المبلغ الكلى',
                    textAlign: TextAlign.end,
                    style: kTextDetailStyle.copyWith(
                        color: Colors.lightBlueAccent),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${widget.task.duration != null ? widget.task.duration : 0}',
                    textAlign: TextAlign.end,
                    style: kTextDetailEnteredStyle,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    ':عدد الدفعات',
                    textAlign: TextAlign.end,
                    style: kTextDetailStyle.copyWith(
                        color: Colors.lightBlueAccent),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  Text(
                    '${widget.task.amount}',
                    textAlign: TextAlign.end,
                    style: kTextDetailEnteredStyle,
                  ),
                  SizedBox(
                    width: 0.0,
                  ),
                  Text(
                    ':قدر القسط',
                    textAlign: TextAlign.end,
                    style: kTextDetailStyle.copyWith(
                        color: Colors.lightBlueAccent),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  MaterialButton(
                    minWidth: 5.0,
                    height: 5.0,
                    color: Colors.white,
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      print('index is ${widget.task.id}');
                      if (num < widget.task.duration) {
                        setState(() {
                          num++;
                          remain =
                              widget.task.price - (num * widget.task.amount);
                          addPaidNumToSF(num, remain, widget.task.id);
                          print('added from onPressed $num');
                        });
                      } else {
                        _onBasicAlertPressed(context, widget.task.name);
                      }
                    },
                  ),


                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '$num',
                    style: kTextDetailEnteredStyle,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    ':الاقساط المدفوعة',
                    textAlign: TextAlign.end,
                    style: kTextDetailStyle.copyWith(
                        color: Colors.lightBlueAccent),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$remain',
                    style: kTextDetailEnteredStyle.copyWith(color: Colors.red),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'الباقى',
                    textAlign: TextAlign.end,
                    style: kTextDetailStyle.copyWith(
                        color: Colors.lightBlueAccent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

   double getPrice() {
    return widget.task.price;
  }
}
