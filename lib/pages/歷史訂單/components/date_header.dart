import 'package:flutter/material.dart';

class DateHeader extends StatelessWidget {
  final int year;
  final int month;
  final VoidCallback onPressed;

  const DateHeader({
    Key? key,
    required this.year,
    required this.month,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Text(
              '${year.toString()}年${month.toString()}月',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: Container()),
            TextButton(
              onPressed: onPressed,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Border color
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Text(
                    '選擇月份',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18// Text color
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
