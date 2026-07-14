import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signova/core/constants/colors.dart';
import 'package:signova/core/data/user.dart';
import 'package:signova/features/chat/screens/video_recording_screen.dart';
import 'package:signova/features/chat/service/chat_service.dart';
import 'package:signova/features/chat/widgets/audio_message_bubble.dart';
import 'package:signova/features/chat/widgets/date_header.dart';
import 'package:signova/features/chat/widgets/text_message_bunddle.dart';
import 'package:signova/features/chat/widgets/video_message_bunddle.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.sessionId,
    required this.receiverUsername,
    this.isReceiverDeaf = false,
  });

  final String sessionId;
  final String receiverUsername;
  final bool isReceiverDeaf;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SpeechToText speechToText = SpeechToText();
  final ImagePicker imagePicker = ImagePicker();
  final TextEditingController messageController = TextEditingController();

  List messages = [];
  bool isLoadingMessages = false;

  final Color primaryPurple = const Color(0xFF6B4CF4);
  final Color lightPurpleBg = const Color(0xFFF2F0FF);

  bool get isCurrentUserDeaf => User().isDeaf == true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    setState(() => isLoadingMessages = true);

    try {
      final response = await ChatService().getChatHistory(widget.sessionId);
      messages = response.data['data']['messages'] ?? [];
    } catch (e) {
      debugPrint("History Error: $e");
    }

    setState(() => isLoadingMessages = false);
  }

  Future<void> startListening() async {
    final available = await speechToText.initialize(
      onStatus: (status) => debugPrint("Speech status: $status"),
      onError: (error) => debugPrint("Speech error: $error"),
    );

    if (!available) return;

    await speechToText.listen(
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      onResult: (result) {
        setState(() {
          messageController.text = result.recognizedWords;
          messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: messageController.text.length),
          );
        });
      },
    );
  }

  Future<void> pickAndUploadImage() async {
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    await ChatService().uploadChatImage(
      sessionId: widget.sessionId,
      file: File(pickedImage.path),
    );

    await loadHistory();
  }

  Future<void> pickAndUploadAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) return;

    await ChatService().uploadChatAudio(
      sessionId: widget.sessionId,
      file: File(result.files.single.path!),
    );

    await loadHistory();
  }
  Future<void> pickAndUploadVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) return;

    await ChatService().uploadChatVideo(
      sessionId: widget.sessionId,
      file: File(result.files.single.path!),
    );

    await loadHistory();
  }
  Future<void> pickAndHandleDeafVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) return;

    await handleDeafVideo(File(result.files.single.path!));
  }

  Future<void> handleDeafVideo(File file) async {
    try {
      if (widget.isReceiverDeaf == true) {
        // Deaf -> Deaf: send video as it is
        await ChatService().uploadChatVideo(
          sessionId: widget.sessionId,
          file: file,
        );
      } else {
        // Deaf -> Non Deaf: translate video to text
        await ChatService().signToTextChat(
          sessionId: widget.sessionId,
          file: file,
        );
      }

      await loadHistory();
    } catch (e) {
      debugPrint("Handle Deaf Video Error: $e");
    }
  }

  void showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Image"),
                onTap: () {
                  Navigator.pop(context);
                  pickAndUploadImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.audiotrack),
                title: const Text("Audio"),
                onTap: () {
                  Navigator.pop(context);
                  pickAndUploadAudio();
                },
              ),

              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text("Video"),
                onTap: () {
                  Navigator.pop(context);
                  pickAndUploadVideo();
                },
              ),            ],
          ),
        );
      },
    );
  }

  Widget buildMessage(Map message) {
    debugPrint("AAAA_FULL_MESSAGE: $message");
    debugPrint("AAAA_USER_ID: ${User().id}");

    final senderId =
    message['sender_id'] is Map
        ? message['sender_id']['_id']
        : message['sender_id'] ?? message['sender']?['_id'];

    final receiverId =
    message['receiver_id'] is Map
        ? message['receiver_id']['_id']
        : message['receiver_id'];

    final isMe = senderId.toString() == User().id.toString();

    debugPrint("senderId: $senderId");
    debugPrint("myId: ${User().id}");
    debugPrint("isMe: $isMe");
    final type = message['type'];
    final content = message['content'] ?? '';
    final videoUrl = message['video_url'];

    if (isCurrentUserDeaf) {
      final shownVideo = videoUrl ?? (type == 'video' ? content : null);

      if (shownVideo == null || shownVideo.toString().isEmpty) {
        return const SizedBox.shrink();
      }

      return VideoMessageBubble(
        isMe: isMe,
        time: "Now",
        avatarUrl: '',
        primaryColor: primaryPurple,
        videoUrl: shownVideo,
      );
    }

    if (type == 'image') {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              content,
              width: 55.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    if (type == 'audio') {
      return AudioMessageBubble(
        isMe: isMe,
        audioUrl: content,
        primaryColor: primaryPurple,
      );
    }

    if (type == 'video') {
      return VideoMessageBubble(
        isMe: isMe,
        time: "Now",
        avatarUrl: '',
        primaryColor: primaryPurple,
        videoUrl: content,
      );
    }

    return TextMessageBubble(
      isMe: isMe,
      time: "Now",
      avatarUrl: '',
      text: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.receiverUsername),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isLoadingMessages
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                children: [
                  buildDateHeader("TODAY"),
                  SizedBox(height: 2.h),
                  ...messages.map((message) => buildMessage(message)),
                ],
              ),
            ),
            isCurrentUserDeaf ? _buildDeafBottomActions() : _buildChatInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      margin: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h, top: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F9),
        borderRadius: BorderRadius.circular(25.sp),
      ),
      child: Row(
        children: [
          SizedBox(width: 2.w),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(
                  color: AppColors.hintColor,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.mic_none, color: primaryPurple, size: 22.sp),
            onPressed: startListening,
          ),
          IconButton(
            icon: Icon(Icons.attach_file, color: primaryPurple, size: 22.sp),
            onPressed: showAttachmentOptions,
          ),
          Container(
            decoration: BoxDecoration(
              color: primaryPurple,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white, size: 22.sp),
              onPressed: () async {
                if (messageController.text.trim().isEmpty) return;

                await ChatService().sendTextMessage(
                  sessionId: widget.sessionId,
                  content: messageController.text.trim(),
                );

                messageController.clear();
                await loadHistory();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeafBottomActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: pickAndHandleDeafVideo,
            child: Container(
              width: 13.w,
              height: 13.w,
              decoration: BoxDecoration(
                color: lightPurpleBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.attach_file,
                color: primaryPurple,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VideoRecordingScreen(),
                ),
              );

              if (result != null) {
                await handleDeafVideo(File(result));
              }
            },
            child: Container(
              width: 13.w,
              height: 13.w,
              decoration: BoxDecoration(
                color: primaryPurple,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.videocam,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}