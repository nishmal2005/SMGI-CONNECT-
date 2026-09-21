import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String title;
  final Map<String, String> data;

  const ReviewCard({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE4E4E4)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE & EDIT BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                "Edit",
                style: TextStyle(
                  color: Color(0xFF0086FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// DIVIDER
          Container(height: 1, color: const Color(0xFFE4E4E4)),
          const SizedBox(height: 35),

          /// DETAILS
          ...data.entries.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${item.key}:",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9BA3B0),
                    ),
                  ),
                  Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
