import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar header(context, {bool isAppTitle=false, String titleText}) {
  return AppBar(
    title:Text(isAppTitle? 'BeSocial': titleText,style: GoogleFonts.sourceSansPro(
      textStyle: TextStyle(fontSize: 50.0, color: Colors.white),
    ),
    overflow: TextOverflow.ellipsis,

    ),
    centerTitle: true,
    backgroundColor: Colors.teal,
    actions: <Widget>[],
  );
}
