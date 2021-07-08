import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'custom_rect_twenn.dart';
import 'package:geocoder/geocoder.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  static const String _LOCATIONPOPUP = 'LOCATION';
TextEditingController cityAddress = new TextEditingController();

  Future<LocationData> getLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    _locationData = await location.getLocation();
    return _locationData;
  }

  Future<String> getRegion(double xAxis, double yAxis) async {
    final coordinates = new Coordinates(xAxis,yAxis);

    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address localRecord = addresses.first;
    String addr = localRecord.addressLine;
    print(addr);
    List<String> addressExploded = addr.split(",");
    List<String> citySplit =  addressExploded[2].trim().split(" ");
    String locale = addressExploded[1].trim() +", "+ citySplit[0];
    cityAddress.text =locale;
    return localRecord.addressLine;

  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<LocationData>(
            future: getLocation(),
            builder:
                (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
              //await Geocoder.local.findAddressesFromCoordinates(Coordinates(: snapshot.data.latitude,snapshot.data.longitude))
              return Hero(
                  tag: _LOCATIONPOPUP,
                  createRectTween: (begin, end) {
                    return CustomRectTween(begin: begin, end: end);
                  },
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                      child: Material(
                          elevation: 3,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: snapshot.hasData
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                      Padding(
                                          padding: EdgeInsets.only(top: 6),
                                          child: Text(
                                            "Share my location",
                                            style: TextStyle(fontSize: 16),
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text("X:")),
                                          Container(
                                              width: 70,
                                              child: TextFormField(
                                                initialValue: snapshot
                                                    .data.latitude
                                                    .toString(),
                                                readOnly: true,
                                                style: TextStyle(fontSize: 14),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text("Y:")),
                                          Container(
                                              width: 70,
                                              child: TextFormField(
                                                  initialValue: snapshot
                                                      .data.longitude
                                                      .toString(),
                                                  readOnly: true,
                                                  style:
                                                      TextStyle(fontSize: 14)))
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 6),
                                          child: Text("Shared As",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600]))),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          width: 250,
                                          child: FutureBuilder<String>(
                                              future: getRegion(
                                                  snapshot.data.latitude,
                                                  snapshot.data.longitude),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      cityData) {
                                                return TextFormField(
                                                  textAlign: TextAlign.center,
                                                    controller: cityAddress,
                                                    readOnly: true,
                                                    style: TextStyle(
                                                        fontSize: 14,color: Colors.black87));
                                              })),
                                      ElevatedButton.icon(
                                          icon: Icon(Icons.add_box_rounded),
                                          label: Text("Share"),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.black87
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context,{"locale": cityAddress.value.text});
                                          })
                                    ])
                              : (snapshot.connectionState == ConnectionState.waiting) ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(top: 6,left: 3,right: 3),
                                    child: Text(
                                      "Fetching Location",
                                      style: TextStyle(fontSize: 16),
                                    )),
                                Padding(padding: EdgeInsets.all(10),child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),)),
                              ]) :  Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                      Padding(
                                          padding: EdgeInsets.only(top: 6),
                                          child: Text(
                                            "Share my location",
                                            style: TextStyle(fontSize: 16),
                                          )),
                                      Text("Location not found"),
                                    ]))));
            }));
  }
}
