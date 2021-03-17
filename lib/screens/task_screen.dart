import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_task/model/task.dart';
import 'package:my_task/screens/add_task_screen.dart';
import 'package:my_task/screens/task_detail_screen.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Widget _buildListView() {
    final contactsBox = Hive.box('myBox');

    return ValueListenableBuilder(
      valueListenable: Hive.box('myBox').listenable(),
      builder: (context, tasksBox, _) {
        return ListView.builder(
          itemCount: tasksBox.length,
          itemBuilder: (context, index) {
            final task = tasksBox.getAt(index) as Task;

            return Card(
              child: ListTile(
                title: Text(
                  task.name,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                subtitle: Text(
                  task.phone,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 16.0),
                ),
                leading: GestureDetector(
                  onTap: () {
                    contactsBox.deleteAt(index);
                    setState(() {});
                  },
                  child: Icon(
                    Icons.delete_forever,
                    size: 35.0,
                  ),
                ),
                onTap: () {
                  print('id from home is ${task.id}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(task)));
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'Product',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 6.0, right: 6.0),
        child: Column(
          children: [
            Expanded(
              child: _buildListView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
