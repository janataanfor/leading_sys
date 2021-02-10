import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final Function onChanged;

  SearchBox({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 2.0,
        shadowColor: Color(0x66BCB0AC),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: TextField(
          style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(fontSize: 16, color: Color(0xFFC1C1C1)),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 24, left: 24),
              child: Icon(
                Icons.search,
                color: Color(0xFFC1C1C1),
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
            border: OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.none, width: 0.0),
            ),
          ),
        ));
  }
}
