import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDateTimeRow extends StatelessWidget {
  final String dateText;
  final String timeText;
  final String status;
  final String userName;

  const CustomDateTimeRow({
    Key? key,
    required this.dateText,
    required this.timeText,
    required this.status,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUpload = status == 'upload';
    final containerColor = isUpload ? Color(0xFFE6F4EA) : Color(0xFFFFEBEE);
    final imagePath = isUpload
        ? 'assets/images/excelUpDarck.png'
        : 'assets/images/excelDownDarck.png';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.all(12),
            child: Image.asset(
              imagePath,
              width: 24,
              height: 24,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateText,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xff545f70),
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                userName,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xff7A869A),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(
            timeText,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xff545f70),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}