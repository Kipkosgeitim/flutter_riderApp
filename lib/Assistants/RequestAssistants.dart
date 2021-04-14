import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistants {

  static Future<dynamic>  getRequest(String url) async{
   // http.Response response = await http.get(url);

    var url1 = Uri.parse(url);
    http.Response response = await http.get(url1) ;

    try{
      if (response.statusCode == 200) {
        String jsonData=response.body;
        var decodeData= jsonDecode(jsonData);
        return decodeData;


      }else{
        return"failed";
      }

    }catch(exp){
      return"failed";


    }
  }
}