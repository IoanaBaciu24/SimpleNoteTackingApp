import 'package:flutter/material.dart';
import 'test1Obj.dart';
import 'dart:async';
import 'db_helper.dart';

class DBThing extends StatefulWidget{

  final String title;

  DBThing({Key key, this.title}): super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DBThingPageState();
  }
}

class _DBThingPageState extends State<DBThing> {

  Future <List<test1Obj>> boyes;
  TextEditingController controller = TextEditingController();
  String name;
  int curUserId;
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;



  clearName() {
    controller.text = '';
  }


  @override
  void initState() {
    super.initState();
    dbHelper = db_helper();
    isUpdating = false;
    refreshList();
  }


  void refreshList() {
    setState(() {
      boyes = dbHelper.getAll();
    });

  }
  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => name = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  validate(){
    if(formKey.currentState.validate())
      {
        formKey.currentState.save();
        if(isUpdating)
          {
            test1Obj test1obj = test1Obj(curUserId, name);
            dbHelper.update(test1obj);
            setState(() {
              isUpdating = false;
            });
          }
        else{
          test1Obj test1obj = test1Obj(null, name);
          dbHelper.save(test1obj);
        }
        clearName();
        refreshList();
      }
  }

  SingleChildScrollView dataTable(List<test1Obj> employees) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('NAME'),
          ),
          DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: employees
            .map(
              (employee) => DataRow(cells: [
            DataCell(
              Text(employee.name),
              onTap: () {
                setState(() {
                  isUpdating = true;
                  curUserId = employee.id;
                });
                controller.text = employee.name;
              },
            ),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                dbHelper.delete(employee.id);
                refreshList();
              },
            )),
          ]),
        )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: boyes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }


  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter SQLITE CRUD DEMO'),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }

}