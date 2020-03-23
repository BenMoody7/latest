import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/class.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class ClassDetail extends StatefulWidget {

  final String appBarTitle;
  final Class note;

  ClassDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return ClassDetailState(this.note, this.appBarTitle);
  }
}

class ClassDetailState extends State<ClassDetail> {


  DateTime _sDate;
  DateTime _eDate;
  bool isGroup;


  static var _priorities = ['Group', 'Private', 'Circle'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Class note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController sDateController = TextEditingController();
  TextEditingController eDateController = TextEditingController();

  ClassDetailState(this.note, this.appBarTitle);
  @override
  void initState(){
    super.initState();
    sDateController.text = note.sdate;
    eDateController.text = note.edate;
  }
  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    //_sDate = new DateFormat("dd/mm/yyyy").parse(note.sdate);
    //_eDate = new DateFormat("dd/mm/yyyy").parse(note.edate);

    titleController.text = note.title;
    descriptionController.text = note.description;
    isGroup = note.priority==1?true:false;

    return WillPopScope(

        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                // First element
                ListTile(
                  title: DropdownButton(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String> (
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),

                      style: textStyle,

                      value: getPriorityAsString(note.priority),

                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint('User selected $valueSelectedByUser');
                          updatePriorityAsInt(valueSelectedByUser);
                          if (valueSelectedByUser == 'Group'){
                            isGroup = true;}
                          else{
                            isGroup = false;
                            sDateController.clear();
                            eDateController.clear();
                            note.sdate = '';
                            note.edate = '';
                          }

                        });
                      }
                  ),
                ),

                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    enabled: isGroup?true:false,
                    readOnly: true,
                    controller: sDateController,
                    style: textStyle,


                    decoration: InputDecoration(
                        labelText: 'Start Date',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate:  _sDate == null ? DateTime.now():_sDate ,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030)
                      ).then((date){
                        setState(() {
                          if(date!=null){
                            _sDate = date;
                            sDateController.text = (_sDate.day.toString()+'/'+_sDate.month.toString()+'/'+_sDate.year.toString());
                            debugPrint(sDateController.text);
                          }

                        });

                      });


                    },
                  ),
                ),



                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    enabled: isGroup?true:false,
                    readOnly: true,
                    controller: eDateController,
                    style: textStyle,


                    decoration: InputDecoration(
                        labelText: 'End Date',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate:  _eDate == null ? DateTime.now():_eDate ,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030)
                      ).then((date){
                        setState(() {
                          if(date!=null){
                            _eDate = date;
                            eDateController.text = (_eDate.day.toString()+'/'+_eDate.month.toString()+'/'+_eDate.year.toString());
                          }
                        });

                      });


                    },
                  ),
                ),






                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'Group':
        note.priority = 1;
        break;
      case 'Private':
        note.priority = 2;
        break;
      case 'Circle':
        note.priority = 3;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];  // 'Group'
        break;
      case 2:
        priority = _priorities[1];  // 'Private'
        break;
      case 3:
        priority = _priorities[2];  // 'Circle'
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle(){
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();
    updateTitle();

    if (_sDate!=null){
      note.sdate = _sDate.day.toString()+'/'+_sDate.month.toString()+'/'+_sDate.year.toString();

    }
    if (_eDate!=null){
      note.edate = _eDate.day.toString()+'/'+_eDate.month.toString()+'/'+_eDate.year.toString();
    }

    int result;
    if (note.id != null) {  // Case 1: Update operation
      result = await helper.updateNote(note);
    } else { // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Info');
    }

  }

  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'Nothing was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}










