
class Class {

  int _id;
  String _title;
  String _description;
  String _sdate;
  String _edate;
  int _priority;

  Class(this._title, this._sdate, this._edate, this._priority, [this._description]);

  Class.withId(this._id, this._title, this._sdate, this._edate, this._priority, [this._description]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  int get priority => _priority;

  String get sdate => _sdate;
  String get edate => _edate;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 3) {
      this._priority = newPriority;
    }
  }

  set sdate(String newDate) {
    this._sdate = newDate;
  }
  set edate(String newDate) {
    this._edate = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['sdate'] = _sdate;
    map['edate'] = _edate;

    return map;
  }

  // Extract a Note object from a Map object
  Class.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._sdate = map['sdate'];
    this._edate = map['edate'];
  }
}









