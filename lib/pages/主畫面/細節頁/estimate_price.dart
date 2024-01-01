import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../../constants/constants.dart';
import '../../../model/主畫面/estimate_price_model.dart';
import '../../../respository/主畫面/directions_api_request.dart';
import '../../../util/dialog_util.dart';
import 'count_price.dart';

class EstimatePrice extends StatefulWidget {
  const EstimatePrice({super.key});

  @override
  State<EstimatePrice> createState() => _EstimatePriceState();
}

class _EstimatePriceState extends State<EstimatePrice> {
  TextEditingController _addressStartFieldController = TextEditingController();
  TextEditingController _addressEndFieldController = TextEditingController();
  List<TextEditingController> addressFieldControllers = [];
  final DirectionsAPIRequest apiRequest = DirectionsAPIRequest();
  int stop_num = 2;
  List<List<Place>> places = [[],[],[],[],[]];

  @override
  void initState() {
    addressFieldControllers.add(_addressStartFieldController);
    addressFieldControllers.add(_addressEndFieldController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('估算金額')),
      body: Container(
        child: Stack(
          children: [
            ListView.builder(
              itemCount: stop_num,
              itemBuilder: (context, index) {
                if (index == 0) { // 第一
                  return Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 10),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/pin.png',
                                width: 10,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(left: 16,right: 16),
                                  child: TextField(
                                    controller: addressFieldControllers[0],
                                    decoration: const InputDecoration(
                                      labelText: '請輸入查詢地址',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) async {
                                      if (value == "")
                                      {
                                        setState(() {
                                          places[index] = [];
                                        });
                                      }
                                      else
                                        searchPlaces(value,index);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.transparent,
                                width: 20,
                                height: 20,
                              ),
                            ],
                          )
                      ),
                      (places.isEmpty || places[index].isEmpty) ? Container() :
                      SizedBox(
                        height: (places[index].length == 1) ? 65 : 130,
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, idx) {
                                  return GestureDetector(
                                      onTap: () {
                                        addressFieldControllers[index].text = places[index][idx].name;
                                        setState(() {
                                          places[index] = [];
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(45, 6, 45, 6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              places[index][idx].name, // Set the maximum number of lines before it truncates
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              places[index][idx].formattedAddress,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                      )
                                  );
                                },
                                childCount: places[index].length,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                else if (index == stop_num - 1) { // 最後
                  return Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/dot.png',
                                width: 10,
                                height: 10,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(left: 16,right: 16),
                                  child: TextField(
                                    controller: addressFieldControllers[index],
                                    decoration: const InputDecoration(
                                      labelText: '請輸入查詢地址',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) async {
                                      if (value == "")
                                      {
                                        setState(() {
                                          places[index] = [];
                                        });
                                      }
                                      else
                                        searchPlaces(value,index);
                                    },
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  bool _empty = false;
                                  addressFieldControllers.forEach((element) {
                                    print("object $element");
                                    if (element.text == '')
                                      _empty = true;
                                  });
                                  setState(() {
                                    if (stop_num <= 5 && !_empty)
                                      stop_num += 1;
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/add.png',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          )
                      ),
                      (places.isEmpty || places[index].isEmpty) ? Container() :
                      SizedBox(
                        height: (places[index].length == 1) ? 65 : 130,
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, idx) {
                                  return GestureDetector(
                                      onTap: () {
                                        addressFieldControllers[index].text = places[index][idx].name;
                                        setState(() {
                                          places[index] = [];
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(45, 6, 45, 6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              places[index][idx].name, // Set the maximum number of lines before it truncates
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              places[index][idx].formattedAddress,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                      )
                                  );
                                },
                                childCount: places[index].length,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                else { // 其他
                  _updateAddressFieldControllers(stop_num);
                  return Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/dot.png',
                                width: 10,
                                height: 10,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(left: 16,right: 16),
                                  child: TextField(
                                    controller: addressFieldControllers[index],
                                    decoration: const InputDecoration(
                                      labelText: '請輸入查詢地址',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    addressFieldControllers.removeAt(index);
                                    setState(() {
                                      if (0 < stop_num)
                                        stop_num -= 1;
                                    });
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/minus.png',
                                  width: 20,
                                  height: 20,
                                ),
                              )
                            ],
                          )
                      ),
                      (places.isEmpty || places[index].isEmpty) ? Container() :
                      SizedBox(
                        height: (places[index].length == 1) ? 65 : 130,
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, idx) {
                                  return GestureDetector(
                                      onTap: () {
                                        addressFieldControllers[index].text = places[index][idx].name;
                                        setState(() {
                                          places[index] = [];
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(45, 6, 45, 6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              places[index][idx].name, // Set the maximum number of lines before it truncates
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              places[index][idx].formattedAddress,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                      )
                                  );
                                },
                                childCount: places[index].length,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
              },
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(color: Colors.black, width: 1),// Adjust the value as needed
                              ),
                              primary: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () {
                              bool _contain = false;
                              addressFieldControllers.forEach((element) {
                                if (element.text == '')
                                  _contain = true;
                              });
                              if (_contain || _addressEndFieldController.text == '') {
                                DialogUtils.showErrorDialog("查詢失敗", "請先確定所有地址或地點名稱皆有填寫後，再重新查詢", context);
                              } else {
                                // getDirections();
                                //   if (!addressFieldControllers.contains(_addressEndFieldController))
                                //     addressFieldControllers.add(_addressEndFieldController);
                                print("推 `${addressFieldControllers.length}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CountPricePage(addressFieldControllers:addressFieldControllers)
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/money.png',
                                  width: 30,
                                  height: 30,
                                ),
                                Expanded(child: Container()),
                                const Text('計算金額',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                      Container(width: 30,),
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(color: Colors.black, width: 1),// Adjust the value as needed
                                ),
                                primary: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                setState(() {
                                  bool _contain = false;
                                  addressFieldControllers.forEach((element) {
                                    if (element.text == '')
                                      _contain = true;
                                  });
                                  if (_contain || _addressEndFieldController.text == '') {
                                    DialogUtils.showErrorDialog("查詢失敗", "請先確定所有地址或地點名稱皆有填寫後，再重新查詢", context);
                                  } else {
                                    openGoogleMap();
                                  }
                                });
                              },
                              child: const Row(
                                children: [
                                  // Image.asset(
                                  // 'assets/images/map.png',
                                  // width: 20,
                                  // height: 20,
                                  // ),
                                  //  Container(width: 12,),
                                  Text(
                                    'Google map',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black
                                    ),
                                  ),
                                ],
                              )
                          )
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  void openGoogleMap() async {
    String startAddress = _addressStartFieldController.text;
    String endAddress = _addressEndFieldController.text;

    if (startAddress.isNotEmpty && endAddress.isNotEmpty) {
      String url = 'https://www.google.com/maps/dir/?api=1&origin=$startAddress&destination=$endAddress';
      final Uri uri = Uri.file(url);
      launchUrl(uri);
    } else {
      print('Please enter start and end addresses');
    }
  }

  Future<void> searchPlaces(String keyword,int index) async {
    String country = "TW"; // Country code for Taiwan
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$keyword&key=$debug_google_api_key&region=$country";
    print("url $url");
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
       print("response.body ${response.body}");
      Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        List<dynamic> results = data['results'];
        List<Place> fetchedPlaces = results.map((placeData) => Place.fromJson(placeData)).toList();

        setState(() {
          print("index: $index");
          places[index] = fetchedPlaces;
          //print("oo ${ places[index]}");
        });
        //print("Fetched ${fetchedPlaces.length} places");
      } else {
        print("Error: ${data['status']}");
      }
    } else {
      print("Failed to fetch places. Error: ${response.statusCode}");
    }

  }

  void _updateAddressFieldControllers(int newStopNum) {
    if (newStopNum >= addressFieldControllers.length) {
      addressFieldControllers.add(TextEditingController());
    } else if (newStopNum < addressFieldControllers.length) {
      addressFieldControllers.removeLast();
    }
  }
}