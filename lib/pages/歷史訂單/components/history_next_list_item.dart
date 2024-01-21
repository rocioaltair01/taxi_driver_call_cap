import 'package:flutter/material.dart';

import '../history_detail_map.dart';

class HistoryNextListItem extends StatelessWidget {
  final String label;
  final String value;
  final List<num> currentPosition;

  const HistoryNextListItem({
    Key? key,
    required this.label,
    required this.value,
    required this.currentPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HistoryDetailMapPage(
              currentPosition: currentPosition,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          label,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            value,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images/arrow_right.png', // Replace this with the correct path to your image asset
                    width: 14, // Set the image width
                    height: 14, // Set the image height
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            height: 1,
          ),
        ],
      ),
    );
  }
}
