import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoDriverAvailableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Container(
        margin: EdgeInsets.all(0.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "No Driver Found",
                  style: TextStyle(fontSize: 22.0, fontFamily: "Brand-Bold"),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "No available Driver Available in the nearby,Try again shortly",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: EdgeInsets.all(17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Close",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Icon(
                            Icons.car_repair,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}