import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/class.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:flutter_app/screens/class_detail.dart';
import 'package:sqflite/sqflite.dart';


class ClassList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return ClassListState();
  }
}

class ClassListState extends State<ClassList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Class> classList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (classList == null) {
      classList = List<Class>();
      updateListView();
    }

    return Scaffold(

      appBar: AppBar(
        title: Text('Classes'),
        centerTitle: true,
      ),

      body: getNoteListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Class('', '', '', 1), 'Add Class');
        },

        tooltip: 'Add Class',

        child: Icon(Icons.add),

      ),

    );
  }

  ListView getNoteListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.classList[position].priority),
              child: getPriorityIcon(this.classList[position].priority),
            ),

            title: Text(this.classList[position].title, style: titleStyle,),

            subtitle: Text(this.classList[position].sdate.toString()+'    -    '+this.classList[position].edate.toString()),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, classList[position]);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.classList[position],'Edit Class');
            },

          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.group);
        break;
      case 2:
        return Icon(Icons.person);
        break;
      case 3:
        return Icon(Icons.all_inclusive);
        break;

      default:
        return Icon(Icons.group);
    }
  }

  void _delete(BuildContext context, Class note) async {

    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Class note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ClassDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Class>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.classList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}







