import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_task/model/task.dart';
import 'package:my_task/screens/task_screen.dart';
import 'package:my_task/constants.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String mName;
  String mPhone;
  String mProduct;
  double mPrice;
  double mDuration;
  double mAmount;
  bool toggle = false;
  String wayPaid = '';
  String weekly;
  String monthly;
  String year;
  String time;

  // id to distinguish between items in listview
  int id = 0;


  List<String> checked = [];

  String x = 'اسبوعى';

  void addTask(Task task) {
    final tasksBox = Hive.box('myBox');
    tasksBox.add(task);
  }

  double calAmount() {
    if (mPrice != null && mDuration != null) {
      mAmount = mPrice / mDuration;
      return mAmount;
    }
  }

  _onBasicAlertPressed(context) {
    Alert(
      context: context,
      title: "من فضلك",
      desc: "ادخل جميع البيانات",
    ).show();
  }

  @override
  void initState() {
    super.initState();
    readFromSF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add product'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                textAlign: TextAlign.end,
                onChanged: (newValue) {
                  mName = newValue;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'ادخل الاسم',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                textAlign: TextAlign.end,
                onChanged: (newValue) {
                  mPhone = newValue;
                },
                keyboardType: TextInputType.number,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'ادخل رقم التليفون',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                textAlign: TextAlign.end,
                onChanged: (newValue) {
                  mProduct = newValue;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'ادخل المنتج',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                textAlign: TextAlign.end,
                onChanged: (newValue) {
                  mPrice = double.parse(newValue);
                },
                keyboardType: TextInputType.number,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'المبلغ الكلى',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CheckboxGroup(
                    orientation: GroupedButtonsOrientation.HORIZONTAL,
                    labels: <String>[
                      'سنوى',
                      'شهرى',
                      'اسبوعى',
                    ],
                    checked: checked,
                    onChange: (bool isChecked, String label, int index) {
                      if (index == 0) {
                        wayPaid = 'سنة';
                      } else if (index == 1) {
                        wayPaid = 'شهر';
                      } else if (index == 2) {
                        wayPaid = 'اسبوع';
                      } else {
                        wayPaid = '';
                      }
                      print(
                          "isChecked: $isChecked   label: $label  index: $index");
                    },
                    onSelected: (List selected) => setState(() {
                      if (selected.length > 1) {
                        selected.removeAt(0);
                        print('selected length  ${selected.length}');
                      } else {
                        print("only one");
                      }
                      checked = selected;
                    }),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'نظام التقسيط',
                    style: kTextFieldTitleStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 60.0),
                child: TextField(
                  textAlign: TextAlign.end,
                  onChanged: (newValue) {
                    mDuration = double.parse(newValue);
                  },
                  keyboardType: TextInputType.number,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'مدة القسط',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 6.0),
                child: Text('$wayPaid'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                visible: toggle == true ? true : false,
                child: Text(
                  ' ${calAmount()}:قدر القسط',
                  style: kTextFieldTitleStyle.copyWith(color: Colors.red),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                alignment: Alignment.center,
                child: Material(
                  elevation: 6.0,
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () {
                      if (mName == null ||
                          mPhone == null ||
                          mProduct == null ||
                          mPrice == null ||
                          mDuration == null) {
                        _onBasicAlertPressed(context);
                        return;
                      }
                      setState(() {
                        toggle = true;
                      });
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'قدر القسط',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                alignment: Alignment.center,
                child: Material(
                  elevation: 6.0,
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () {
                      if (mName == null ||
                          mPhone == null ||
                          mProduct == null ||
                          mPrice == null ||
                          mDuration == null) {
                        _onBasicAlertPressed(context);
                        return;
                      }
                      setState(() {
                        id++;
                      });
                      saveIdToSF(id);

                      // each item has id when we clicked in listView items

                      final task = Task(id, mName, mPhone, mProduct, mPrice,
                          mDuration, mAmount);
                      addTask(task);

                      print('id ... $id');
                      Navigator.pop(context);
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'حفظ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveIdToSF(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('itemId', id) ;
  }

  Future<int> readFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('itemId') ?? 0;
    });
    return id;
  }
}
