import 'package:desktop_test_app/componants/Alert.dart';
import 'package:desktop_test_app/model/target.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../database_helper.dart';

class TargetDetails extends StatefulWidget {
  final Target target;
  TargetDetails({this.target});
  @override
  _TargetDetails createState() => _TargetDetails();
}

class _TargetDetails extends State<TargetDetails> {
  Target target;
  Color activeColor = Color(0xFFFE903F);
  Color inActiveColor = Color(0xFFBCB0AC);
  final dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  bool showMessage = false;
  String message = '';
  TextEditingController nameCnt = TextEditingController();
  TextEditingController latCnt = TextEditingController();
  TextEditingController lngCnt = TextEditingController();

  void hideMessage() async {
    await Future.delayed(Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      showMessage = false;
    });
  }

  @override
  void initState() {
    target = widget.target;
    nameCnt.text = widget.target.name;
    latCnt.text = widget.target.lat.toString();
    lngCnt.text = widget.target.lng.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.target.name,
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          color: Theme.of(context).primaryColor,
          child: Container(
            child: Stack(children: [
              Container(
                padding: EdgeInsets.only(top: 30, left: 40, right: 40),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    AnimatedOpacity(
                        opacity: showMessage ? 1 : 0,
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          message,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                    SizedBox(
                      height: 0,
                    ),
                    setupContent()
                  ],
                ),
              ),
            ]),
          ),
        ));
  }

  Widget setupContent() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 12),
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xFFE1E5E9),
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.location_searching,
                      color: activeColor,
                      // size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.target.name,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 35,
                    ),
                    Container(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: 'Lat', border: InputBorder.none),
                        readOnly: true,
                        controller: TextEditingController(
                            text: widget.target.lat.toString()),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: 'Lng', border: InputBorder.none),
                        readOnly: true,
                        controller: TextEditingController(
                            text: widget.target.lng.toString()),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: inActiveColor,
                    ),
                    onPressed: () =>
                        _settingModalBottomSheet(context: context)),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: inActiveColor,
                    ),
                    onPressed: () => Alert(context).delete(fnc: _delete))
              ],
            )
          ],
        ),
      ),
    );
  }

  // void _insert({Map<String, dynamic> row}) async {
  //   // row to insert
  //   final id = await dbHelper.insert('Target', row);
  //   message = 'inserted row id: $id successfully';
  //   setState(() {
  //     showMessage = true;
  //   });
  //   hideMessage();
  // }

  void _update({Map<String, dynamic> row}) async {
    // row to update
    final rowsAffected = await dbHelper.update('Target', row);
    message = 'updated $rowsAffected row(s)';
    print(message);
    setState(() {
      showMessage = true;
    });
    hideMessage();
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete('Target', target.id);
    message = 'this item was deleted';
    print(message);
    setState(() {
      showMessage = true;
    });
    Navigator.of(context).pop();
    hideMessage();
    await Future.delayed(Duration(milliseconds: 2000));
    Navigator.of(context).pop();
  }

  void _settingModalBottomSheet({BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Divider(
                          color: activeColor,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Edit Target Info',
                            style: TextStyle(
                                color: activeColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        child: Divider(
                          color: activeColor,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 250,
                    child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        controller: nameCnt),
                  ),
                  Container(
                    width: 250,
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return null;
                          }
                          final n = num.tryParse(value);
                          if (n == null) {
                            return '"$value" is not a valid number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Lat',
                        ),
                        controller: latCnt),
                  ),
                  Container(
                    width: 250,
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return null;
                          }
                          final n = num.tryParse(value);
                          if (n == null) {
                            return '"$value" is not a valid number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Lng',
                        ),
                        controller: lngCnt),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          showSpinner = true;
                        });

                        Map<String, dynamic> row = {
                          'id': widget.target.id,
                          'name': nameCnt.text,
                          'lat': latCnt.text,
                          'lng': lngCnt.text,
                        };
                        _update(row: row);
                        setState(() {
                          target.name = nameCnt.text;
                          target.lat = latCnt.text;
                          target.lng = lngCnt.text;
                          showSpinner = false;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
