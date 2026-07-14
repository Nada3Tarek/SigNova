import 'package:flutter/material.dart';
import 'package:signova/core/constants/colors.dart';
import 'package:sizer/sizer.dart';

class TextMessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final String time;
  final String avatarUrl;

  const TextMessageBubble({
    super.key,
    required this.isMe,
    required this.text,
    required this.time,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty ? const Icon(Icons.person, size: 14) : null,
            ),
            SizedBox(width: 2.w),
          ],

          Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 65.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFFF2F0FF) : Colors.black,
                  borderRadius: BorderRadius.circular(25.sp),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isMe ? const Color(0xFF1A1A1A) : Colors.white,
                    fontSize: 14.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                time,
                style: TextStyle(color: AppColors.hintColor, fontSize: 12.sp),
              ),
            ],
          ),

          if (isMe) ...[
            SizedBox(width: 2.w),
            CircleAvatar(
              radius: 12,
              backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty ? const Icon(Icons.person, size: 14) : null,
            ),
          ],
        ],
      ),
    );
  }
}
