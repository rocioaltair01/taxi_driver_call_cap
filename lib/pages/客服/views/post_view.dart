import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:new_glad_driver/util/dialog_util.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../model/客服/announcement_model.dart';
import '../../../respository/客服/announce_api.dart';
import '../../../util/shared_util.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  AnnounceList? announceList;
  bool isLoading = false;
  bool showHtmlContent = false;
  List<bool> showHtmlContentList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      announceList = await AnnounceApi.getAnnouncement();

      showHtmlContentList = List.generate(
        announceList?.result?.data.length ?? 0,
            (index) => false,
      );
      // if (announceList.statusCode == 200) {
      //   if (response.data.isEmpty) {
      //     setState(() {
      //       isLoading = false;
      //     });
      //   } else {
      //     setState(() {
      //       billList = response.data;
      //     });
      //   }
      // } else {
      //   throw Exception('Failed to fetch data');
      // }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: SpinKitFadingCircle(
      color: Colors.black,
      size: 80.0,
    )) : Scaffold(
      body: ListView.builder(
        itemCount: announceList!.result?.data.length, // Replace this with the actual length of your list
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                // Toggle the flag to show/hide the HTML content
                setState(() {
                  print("jkl $showHtmlContent");
                  showHtmlContentList[index] = !showHtmlContentList[index];
                });
              },
              child: Container(
                //width: 100,
                // height: showHtmlContent ? 200 : 160,
                decoration: BoxDecoration(
                  //color: Colors.red,
                  borderRadius: BorderRadius.circular(12), // Adjust the radius value as needed
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/start.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 16,),
                              Text(
                                DateUtil().getDateYear(announceList!.result?.data[index].createdAt ?? ''),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        announceList!.result?.data[index].subject ?? '',
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                    (showHtmlContentList[index]) ? Html(
                      data: announceList!.result?.data[index].content ?? '',
                      style: {
                        "body": Style(
                          fontSize: FontSize(18.0), // Adjust the font size as needed
                        ),
                      },
                    ) : Container(),
                    // (showHtmlContentList[index]) ? Expanded(
                    //   child: Html(
                    //     data: announceList!.result?.data[index].content ?? '',
                    //   ),
                    // ) : Container(),
                    Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            Text(
                              announceList!.result?.data[index].announcer ?? '',
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18
                              ),
                            ),
                          ],
                        )
                    ),
                    (!showHtmlContentList[index]) ? Container(
                      height: 1,
                      color: Colors.black,
                    ) : Container(),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        children: [
                          (!showHtmlContentList[index]) ?
                          const Text(
                            "查看詳情",
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ) : Container(),
                          //     : Expanded(
                          //   child: Html(
                          //     data: announceList!.result?.data[index].content ?? '',
                          //   ),
                          // ),
                          Expanded(child: Container()),
                          (!showHtmlContentList[index]) ?
                          Image.asset(
                            'assets/images/arrow_right.png',
                            width: 30,
                            height: 30,
                          ) : Image.asset(
                            'assets/images/arrow_down.png',
                            width: 20,
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: Html(
                    //     data: announceList!.result?.data[index].content ?? '',
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          );
          //   ListTile(
          //   title: Text('Item $index'),
          //   subtitle: Text('Subtitle for Item $index'),
          //   leading: Icon(Icons.account_circle), // Replace with your icon or image
          //   onTap: () {
          //     // Do something when the item is tapped
          //     print('Tapped on Item $index');
          //   },
          // );
        },
      ),
    );
  }
}
