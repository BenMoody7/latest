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
  List<Class> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (noteList == null) {
      noteList = List<Class>();
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
          navigateToDetail(Class('', '', 2), 'Add CLASS');
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
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),

            title: Text(this.noteList[position].title, style: titleStyle,),

            subtitle: Text(this.noteList[position].date),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList[position],'Edit Class');
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
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}







