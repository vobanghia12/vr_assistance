import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/helper.dart';
import '../provider/helpers.dart';
multipleCalling(String token, List <Assister> helpers) async{
  Helpers helper1 = new Helpers(token, helpers[0].id);
  for(int i = 0; i <= helpers.length - 1; i++ )
  {
    await helper1.updateSignal(helpers[i].id, helpers);
    helpers[i].isSignal = true;
  }
}