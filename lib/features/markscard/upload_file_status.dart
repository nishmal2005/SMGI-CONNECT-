import 'package:flutter/material.dart';

class UploadFileStatusCard extends StatelessWidget {
  const UploadFileStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// File row
          Row(
            children: [
              Image.asset("assets/images/fileicon.png", height: 22),
              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  "No file selected yet.",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9BA3B0),
                  ),
                ),
              ),

              const Icon(Icons.close, color: Color(0xFF9BA3B0)),
            ],
          ),

          /// Blue line INSIDE the card (full left start)
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 2,
            width: width * 0.45,
            color: const Color(0xFF0A4D9F),
          ),
        ],
      ),
    );
  }
}
