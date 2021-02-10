import 'package:flutter/material.dart';

class Alert {
  BuildContext context;

  Alert(this.context);

  Future<void> showInfo(String message) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
              content: Text(
                message,
                style: TextStyle(fontSize: 16),
              ));
        });
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).accentColor,
      margin: EdgeInsets.only(bottom: 100, right: 100, left: 100),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ));
  }

  Future<void> delete({Function fnc}) {
    bool loader = false;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    loader
                        ? Container(
                            margin: EdgeInsets.all(16),
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue)))
                        : TextButton(
                            child: Text(
                              'delete',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () => fnc(),
                          ),
                    SizedBox(width: 8)
                  ],
                  content: Text(
                    'Are you sure you want to delete this item',
                    style: TextStyle(fontSize: 16),
                  ));
            },
          );
        });
  }
}
