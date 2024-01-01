import 'package:flutter/material.dart';

class OfflineCountPricePage extends StatefulWidget {
  const OfflineCountPricePage({super.key});

  @override
  State<OfflineCountPricePage> createState() => _OfflineCountPricePageState();
}

class _OfflineCountPricePageState extends State<OfflineCountPricePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Text("跳表金額:100"),
              Text("分鐘數:0.8分"),
              Text("里程數:0公里"),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Adjust the value as needed
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () {
                              },
                              child: const Text(
                                '估算金額',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(width: 30,),
                    Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5), // Adjust the value as needed
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),

                                onPressed: () {

                                },
                                child: const Text(
                                  '結束計費',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              )
            ],
          )
        ],
      )
      // Container(
      //   child: Column(
      //     //mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       //Expanded(child: Container()),
      //       Text("跳表金額:100"),
      //       Text("分鐘數:0.8分"),
      //       Text("里程數:0公里"),
      //       // Expanded(child: Container(
      //       //   height: 50,
      //       //   child: Row(
      //       //     children: [
      //       //       ElevatedButton(
      //       //         style: ElevatedButton.styleFrom(
      //       //           shape: RoundedRectangleBorder(
      //       //             borderRadius: BorderRadius.circular(5), // Adjust the value as needed
      //       //           ),
      //       //           minimumSize: Size(double.infinity, 50),
      //       //         ),
      //       //         onPressed: () {
      //       //           Navigator.push(
      //       //             context,
      //       //             MaterialPageRoute(
      //       //                 builder: (context) => OfflineCountPricePage()
      //       //             ),
      //       //           );
      //       //         },
      //       //         child: const Text(
      //       //           '離線計費',
      //       //           style: TextStyle(
      //       //             fontSize: 18,
      //       //             fontWeight: FontWeight.bold,
      //       //           ),
      //       //         ),
      //       //       ),
      //       //       ElevatedButton(
      //       //         style: ElevatedButton.styleFrom(
      //       //           shape: RoundedRectangleBorder(
      //       //             borderRadius: BorderRadius.circular(5), // Adjust the value as needed
      //       //           ),
      //       //           minimumSize: Size(double.infinity, 50),
      //       //         ),
      //       //         onPressed: () {
      //       //           Navigator.push(
      //       //             context,
      //       //             MaterialPageRoute(
      //       //                 builder: (context) => OfflineCountPricePage()
      //       //             ),
      //       //           );
      //       //         },
      //       //         child: const Text(
      //       //           '離線計費',
      //       //           style: TextStyle(
      //       //             fontSize: 18,
      //       //             fontWeight: FontWeight.bold,
      //       //           ),
      //       //         ),
      //       //       ),
      //       //     ],
      //       //   ),
      //       // )),
      //
      //     ],
      //   ),
      // ),
    );
  }
}
