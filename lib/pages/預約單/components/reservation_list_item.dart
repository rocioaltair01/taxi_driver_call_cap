import 'package:flutter/material.dart';

class ReservationListItem extends StatelessWidget {
  final String label;
  final String value;
  final bool twoValue;
  final int statusValue;

  const ReservationListItem({
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
