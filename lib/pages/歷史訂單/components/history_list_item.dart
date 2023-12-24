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
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (twoValue)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    (statusValue == 4) ? "取消訂單" : "成功訂單",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red, // Set the text color to red
                    ),
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
    );
  }
}
