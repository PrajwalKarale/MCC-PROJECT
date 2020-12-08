// import 'dart:async';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
class CurrentLocation extends StatefulWidget 
{
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> 
{
  String latitudeData;
  String longitudeData;
  double latitude;
  double longitude;
  String addr1 = "";
  String addr2 = "";
  var geoposition;
  @override
  void initState()
  {
    super.initState();
    getCurrentLocation();
    // getAddressBasedOnLocation();
  }
  getCurrentLocation()async
  {
    geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = double.parse('${geoposition.latitude}');
    longitude = double.parse('${geoposition.longitude}');
    print(geoposition);
    final coordinates = new Coordinates(latitude , longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print(address);
    setState(() {
      addr1 = address.first.featureName;
      addr2 = address.first.addressLine;
    });
    // setState(() {
    //   latitudeData = '${geoposition.latitude}';
    //   longitudeData ='${geoposition.longitude}';
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CURRENT LOCATION ADDRESS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor
              ),
              padding: EdgeInsets.symmetric(horizontal:16 , vertical : 8),
              child: Column(
                children:<Widget> [
                  Row(
                    children:<Widget> [
                                          
                    Icon(
                      Icons.location_pin,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget> [
                          Text(
                            'LOCATION',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            addr2,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}