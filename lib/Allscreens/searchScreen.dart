import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riderapp/AllWidgets/Divider.dart';
import 'package:riderapp/AllWidgets/progressDialog.dart';
import 'package:riderapp/Assistants/RequestAssistants.dart';
import 'package:riderapp/DataHandler/appData.dart';
import 'package:riderapp/Models/address.dart';
import 'package:riderapp/Models/placePrediction.dart';
import 'package:riderapp/mapsConfig.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController pickUpTextEditingController = new TextEditingController();
  TextEditingController dropOffTextEditingController = new TextEditingController();
  List<PlacePrediction> placePredictionList = [];

  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUpTextEditingController.text= placeAddress;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 215.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow:[
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),

                  ),
                ] ,
              ),
              child: Padding(

                padding: EdgeInsets.only(left: 25.0,top: 40.0,right: 25.0,bottom: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 5.0,),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Stack(
                        children: [
                          Icon(Icons.arrow_back),
                          Center(
                           child: Text("Set Drop Off",style: TextStyle(fontSize: 18.0,fontFamily: "Brand-Bold"),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0,),

                    Row(
                      children: [
                        Image.asset("images/pickicon.png",height: 16.0,width: 16.0,),
                        SizedBox(height: 16.0,),
                        Expanded(
                          child:Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(

                              padding: EdgeInsets.all(5.0),
                              child: TextField(
                                controller: pickUpTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Pick up Location",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11.0,bottom: 8.0,top: 8.0),


                                ),
                              ),
                            ),
                          ) ,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0,),

                    Row(
                      children: [
                        Image.asset("images/desticon1.png",height: 16.0,width: 16.0,),
                        SizedBox(height: 16.0,),
                        Expanded(
                          child:Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(

                              padding: EdgeInsets.all(5.0),
                              child: TextField(
                                controller: dropOffTextEditingController,
                                onChanged: (val){
                                  findPlace(val);
                              },
                                decoration: InputDecoration(
                                  hintText: "Where To",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11.0,bottom: 8.0,top: 8.0),


                                ),
                              ),
                            ),
                          ) ,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

              (placePredictionList.length > 0)
            ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                    itemBuilder:(context,index){
                    return PredictionTile(placePrediction: placePredictionList[index],);
                    },
                  separatorBuilder: (BuildContext context,int index)=> DividerWidget(),
                  itemCount: placePredictionList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  primary: true,

                ),
            )
            : Container(),
          ],
        ),
      ),
    );
  }

  void findPlace(String placeName)async{
    if(placeName.length >1){
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:ke";
      var res = await RequestAssistants.getRequest(autoCompleteUrl);

      if(res=="failed"){
        return;

      }
     // print("Places prediction Response ::");
      //print(res);
      if(res["status"] =="OK"){

        var predictions = res["predictions"];

        var placesList = (predictions as List).map((e) => PlacePrediction.fromJson(e)).toList();
       setState(() {
         placePredictionList = placesList;
       });
      }
    }

  }
}

class PredictionTile extends StatelessWidget {
  final PlacePrediction placePrediction;

PredictionTile({Key key,this.placePrediction}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: (){
        getPlaceAddressDetails(placePrediction.place_id, context);

      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(placePrediction.main_text,style: TextStyle(fontSize: 16.0),overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 4.0,),
                      Text(placePrediction.secondary_text,style: TextStyle(fontSize:12.0,color: Colors.grey),overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),

              ],
            ),
            SizedBox(width: 10.0,),
          ],
        ),

      ),
    );
  }

  void getPlaceAddressDetails(String placeId,context) async{

    showDialog(
      context: context,
      builder: (BuildContext context)=> ProgressDialog(message: "Setting drop off,please wait...",),
    );

    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var res = await RequestAssistants.getRequest(placeDetailsUrl);

    Navigator.pop(context);

    if(res =="failed") {
      return;
    }
    if(res["status"] =="OK"){
      Address address =  Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context,listen: false).updateDropOffLocationAddress(address);
      print("This is drop off location::");
      print(address.placeName);

      Navigator.pop(context,"obtainDirection");

    }
  }


}

