import 'package:flutter/material.dart';
import 'package:signova/features/translation/widgets/custom_toggle_switch.dart';
import 'package:signova/features/translation/widgets/input_field_voice.dart';
import 'package:signova/features/translation/widgets/sign_to_text_widget.dart';
import 'package:signova/features/translation/widgets/text_to_sign_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:signova/features/translation/service/translation_service.dart';
import 'dart:io';
import 'package:signova/features/chat/screens/video_recording_screen.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:signova/features/translation/service/gloss_service.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  bool _isTextToSign = true;

  final Color primaryPurple = const Color(0xFF6B4CF4);
  final Color lightGreyBackground = const Color(0xFFF7F8FA);
  final TextEditingController _controller = TextEditingController();
  String? videoUrl;
  bool isLoading = false;
  String translatedText = "";
  final SpeechToText speechToText = SpeechToText();

  Future<void> translateText() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final glossJson = await GlossService().textToGlossJson(text);

      debugPrint("GLOSS JSON = $glossJson");

      setState(() {
        translatedText = glossJson;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Glosses ready: $glossJson")),
      );
    } catch (e) {
      debugPrint("Gloss error: $e");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gloss error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> translateVideo(File videoFile) async {
    setState(() {
      isLoading = true;
    });

    try {
      final res = await TranslationService().standaloneSignToText(
        videoFile,
      );

      setState(() {
        translatedText =
            res.data['data']['text'] ?? '';
      });
    } catch (e) {
      debugPrint("Sign to text error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> startListening() async {
    final available = await speechToText.initialize();

    if (!available) return;

    await speechToText.listen(
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: CustomToggleSwitch(
                isTextToSignInitial: true,
                onChanged: (bool value) {
                  setState(() => _isTextToSign = value);
                },
              ),
            ),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isTextToSign
                    ? buildTextToSignView(videoUrl, isLoading: isLoading)
                    : buildSignToTextView(
                  translatedText: translatedText,
                  isLoading: isLoading,
                  onRecordTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoRecordingScreen(),
                      ),
                    );

                    if (result != null) {
                      await translateVideo(
                        File(result),
                      );
                    }
                  },
                ),
              ),
            ),

            if (_isTextToSign)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: buildInputField(
                  controller: _controller,
                  onMicTap: startListening,
                  translateText: translateText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
