import 'package:flutter/material.dart';

class HistoryListItem extends StatelessWidget {
  final String label;
  final String value;
  final bool twoValue;
  final int statusValue;

  const HistoryListItem({
    Key? key,
    required this.label,
    required this.value,
    this.twoValue = false,
    this.statusValue = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            //height: 50,
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                ),
                (label == "乘客備註:") ? Container() :
                Expanded(
                  flex: 2,
                    child: Container()
                ),
                (label == "乘客備註:") ?
                Expanded(
                  flex: 6,
                  child:
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      //textAlign: TextAlign.right,
                      value,
                      style: const TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                ) : twoValue ?
                Expanded(
                  flex: 2,
                    child: Row(
                      children: [
                        Text(
                          value,
                          style: const TextStyle(fontSize: 16),
                          softWrap: true,
                        ),
                        Text(
                            (statusValue == 4) ? "取消訂單" : "成功訂單",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red, // Set the text color to red
                            )
                        ),
                      ],
                    )
                ) :
                Expanded(
                  flex: 3,
                  child:
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      //textAlign: TextAlign.right,
                      value,
                      style: const TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}
