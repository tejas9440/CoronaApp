import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:corona_tracker/Model/countryData.dart';
import 'package:corona_tracker/Utilites/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:corona_tracker/Model/WorldStatesModel.dart';
class StateServices{

  Future<WorldStatesModel> fetchWordStatesRecords () async{
    final res = await http.get(Uri.parse(AppUrl.worldStateApi));
    if(res.statusCode == 200){
      var data = jsonDecode(res.body);
      return WorldStatesModel.fromJson(data);
    }
    else{
      throw Exception("Error");
    }
  }

  Future<List<dynamic>> coutriesList () async{
    var data;
    final res = await http.get(Uri.parse(AppUrl.countriesList));

    if(res.statusCode == 200){
       data = jsonDecode(res.body);
      return data;
    }
    else{
      throw Exception("Error");
    }
  }
}