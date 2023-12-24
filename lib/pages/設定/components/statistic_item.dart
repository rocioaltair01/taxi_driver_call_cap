import 'package:flutter/material.dart';

class StatisticItem extends StatelessWidget {
  final String title;
  final String content;
  const StatisticItem({
    Key? key,
    required this.title,
    required this.content
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          children: [
            SizedBox(
                height: 30,
                child: Center(
                  child: Text(//"成功數"
                    title,
                    style: TextStyle(
                        fontSize: 18.0
                    ),
                  ),
                )
            ),
            SizedBox(
                height: 40,
                child: Center(
                  child: Text(//statisticsData!.transactionSuccessCount.toString(),
                    content,
                    style: const TextStyle(
                      fontSize: 28, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            )
          ],
        )
    );
  }
}
