






import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:riderapp/Assistants/RequestAssistants.dart';
import 'package:riderapp/DataHandler/appData.dart';
import 'package:riderapp/Models/address.dart';
import 'package:riderapp/Models/allUsers.dart';
import 'package:riderapp/Models/directionDetails.dart';

import '../mapsConfig.dart';

class AssistantMethods{

  static Future<String> searchCoordinatesAddress(Position position, context) async{

   String placeAddress ="";
   String st1, st2, st3, st4;
   String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

   var response = await RequestAssistants.getRequest(url);
   if(response!="failed"){

     placeAddress= response["results"][0]["formatted_address"];
     st1= response["results"][0]["address_components"][1]["long_name"];
     st2= response["results"][0]["address_components"][2]["long_name"];
     st3= response["results"][0]["address_components"][3]["long_name"];
     st4= response["results"][0]["address_components"][4]["long_name"];

     placeAddress = st1 + ","+ st2 +"," +st3 + "," +st4;


     Address userPickUpAddress = new Address();
     userPickUpAddress.longitude = position.longitude;
     userPickUpAddress.latitude = position.latitude;
     userPickUpAddress.placeName = placeAddress;


     Provider.of<AppData>(context,listen: false).updatePickUpLocationAddress(userPickUpAddress);


   }
   return placeAddress;

  }

  static Future<DirectionDetails > obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async{

    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    var res = await RequestAssistants.getRequest(directionUrl);

    if(res =="failed"){

      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;



  }

  static int calculateFares(DirectionDetails directionDetails){
    double timeTraveledFare =(directionDetails.durationValue/60)* 0.20;
    double distanceTraveledFare =(directionDetails.distanceValue/1000)* 0.20;
    double totalFareAmount = distanceTraveledFare + timeTraveledFare;

    // converting dollar to ksh
   // double localTotalFareAmount = totalFareAmount*100;
    return totalFareAmount.truncate();

  }

  static void getCurrentOnlineUserInfo() async{
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("user").child(userId);
    
    reference.once().then((DataSnapshot dataSnapShot){

      if(dataSnapShot.value != null){

        currentUserInfo = Users.fromSnapshot(dataSnapShot);
      }

       });

  }
}