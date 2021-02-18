import 'package:desktop_test_app/componants/searchBox.dart';
import 'package:desktop_test_app/model/ourLocations.dart';
import 'package:desktop_test_app/pages/OurLocationDetails.dart';
import 'package:desktop_test_app/utility/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import '../database_helper.dart';

class OurLocationsScreen extends StatefulWidget {
  @override
  _OurLocationsScreen createState() => _OurLocationsScreen();
}

class _OurLocationsScreen extends State<OurLocationsScreen> {
  Color activeColor = Color(0xFFFE903F);
  Color inActiveColor = Color(0xFFBCB0AC);
  final _debouncer = Debouncer(milliseconds: 500);
  final dbHelper = DatabaseHelper.instance;
  List<OurLocations> ourLocations = [];
  List<OurLocations> filteredOurLocations = [];
  bool waiting = false;
  bool showSpinner = false;
  bool showMessage = false;
  String message = '';
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();

  void _updateItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = filteredOurLocations.removeAt(oldIndex);
    filteredOurLocations.insert(newIndex, item);
    saveOrder(rows: filteredOurLocations);
  }

  void hideMessage() async {
    await Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        showMessage = false;
      });
    });
  }

  void updateView() {
    setState(() {
      waiting = true;
    });
    _query(tableName: 'My_location').then((ourLocations) => setState(() {
          waiting = false;
          this.ourLocations = ourLocations;
          filteredOurLocations = ourLocations;
        }));
  }

  @override
  void initState() {
    updateView();
    super.initState();
  }

  @override
  void dispose() {
    //saveOrder(rows: filteredOurLocations);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: showSpinner,
      color: Theme.of(context).primaryColor,
      child: Container(
        child: Stack(children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 40, right: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SearchBox(
                        onChanged: (string) {
                          _debouncer.run(() {
                            setState(() {
                              filteredOurLocations = ourLocations
                                  .where((ourLocation) => (ourLocation.name
                                      .toLowerCase()
                                      .contains(string.toLowerCase())))
                                  .toList();
                            });
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('asset/images/person.jpg'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Admin',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                showMessage
                    ? Text(
                        message,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                setupContent()
              ],
            ),
          ),
          Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
                  backgroundColor: activeColor,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  tooltip: 'Add New Location',
                  onPressed: () => _settingModalBottomSheet(context: context)))
        ]),
      ),
    ));
  }

  Widget setupContent() {
    if (waiting) {
      return CircularProgressIndicator();
    } else {
      return Expanded(
        child: VsScrollbar(
          controller: _scrollController,
          scrollDirection: Axis.vertical, // @REQUIRED
          allowDrag:
              true, // allows to scroll the list using scrollbar [default : true]
          color: Color(0xFFE1E5E9), // sets color of vsScrollBar
          radius: 50, // sets radius of vsScrollBar
          thickness: 8, // sets thickness of vsScrollBar
          isAlwaysShown: false, // default false
          // sets scrollbar fade animation duration [ Default : Duration(milliseconds: 300)]
          scrollbarFadeDuration: Duration(milliseconds: 500),
          // Fades scrollbar after certain duration [ Default : Duration(milliseconds: 600)]
          scrollbarTimeToFade: Duration(milliseconds: 800),
          child: filteredOurLocations.length == 0
              ? Text('No Data!')
              : ReorderableListView(
                  scrollController: _scrollController,
                  padding: EdgeInsets.only(bottom: 20, right: 20),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      _updateItems(oldIndex, newIndex);
                    });
                  },
                  children: [
                    for (final item in filteredOurLocations)
                      Container(
                        key: ValueKey(item),
                        height: 130,
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.only(top: 12),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xFFE1E5E9),
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OurLocationDetails(
                                            ourLocation: item,
                                          ))).then((value) => updateView());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        item.orderIndex.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 150,
                                        child: TextField(
                                          decoration: InputDecoration(
                                              labelText: 'Lat',
                                              border: InputBorder.none),
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: item.lat.toString()),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextField(
                                          decoration: InputDecoration(
                                              labelText: 'Lng',
                                              border: InputBorder.none),
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: item.lng.toString()),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
        ),
      );
    }
  }

  void _insert({Map<String, dynamic> row}) async {
    // row to insert
    final id = await dbHelper.insert('My_location', row);
    message = 'inserted row id: $id successfully';
    setState(() {
      showMessage = true;
    });
    hideMessage();
  }

  Future<List<OurLocations>> _query({String tableName}) async {
    final allRows = await dbHelper.queryAllRows(tableName);
    return List<OurLocations>.from(
        allRows.map((row) => OurLocations.fromJson(row)));
  }

  void saveOrder({List<OurLocations> rows}) async {
    rows.asMap().forEach((key, item) {
      Map<String, dynamic> row = {
        'id': item.id,
        'name': item.name,
        'lat': item.lat,
        'lng': item.lng,
        'order_index': key
      };

      _update(row: row);
    });
    // for (final item in rows) {
    //   Map<String, dynamic> row = {
    //     'id': item.id,
    //     'name': item.name,
    //     'lat': item.lat,
    //     'lng': item.lng,
    //   };
    //
    //   _update(row: row);
    // }
  }

  void _update({Map<String, dynamic> row}) async {
    // row to update
    final rowsAffected = await dbHelper.update('My_location', row);
    message = 'updated $rowsAffected row(s)';
    print(message);
    setState(() {
      showMessage = true;
    });
    hideMessage();
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount('Target');
    print(id);
    final rowsDeleted = await dbHelper.delete('Target', id[0]['COUNT(*)']);
    print('deleted $rowsDeleted row(s): row ${id[0]['COUNT(*)']}');
  }

  void _settingModalBottomSheet({BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          TextEditingController nameCnt = TextEditingController();
          TextEditingController latCnt = TextEditingController();
          TextEditingController lngCnt = TextEditingController();
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
                        child: Text('Add New Location',
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
                          'name': nameCnt.text,
                          'lat': latCnt.text,
                          'lng': lngCnt.text,
                        };
                        _insert(row: row);
                        updateView();
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Save',
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
