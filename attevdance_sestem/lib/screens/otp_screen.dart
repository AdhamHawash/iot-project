import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../api.dart';
import '../../catoger_model.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final int otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool isLoading = false;
  bool isResending = false; // لمؤشر إعادة الإرسال

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  String getOtpCode() {
    return _controllers.map((c) => c.text).join();
  }

  Future<void> verify() async {
    final code = getOtpCode();
    final instructorId = CatogerModel.selected?.id;
    if (instructorId == null) return;

    setState(() => isLoading = true);

    final success = await verifyCode(instructorId: instructorId, code: code);

    setState(() => isLoading = false);

    if (success) {
      Navigator.pushNamed(context, AppRoutes.section);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code. Please try again.')),
      );
    }
  }

  Future<void> resendCode() async {
    final instructorId = CatogerModel.selected?.id;
    if (instructorId == null) return;

    setState(() => isResending = true);

    final success = await sendCode(instructorId: instructorId);

    setState(() => isResending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Code resent successfully.' : 'Failed to resend code.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/1-Select Instructor Screen.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(otpLength, (i) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(counterText: ''),
                      onChanged: (value) {
                        if (value.isNotEmpty && i < otpLength - 1) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[i + 1]);
                        }
                        if (value.isEmpty && i > 0) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[i - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : FilledButton(
                    onPressed: verify,
                    child: const Text('Verify'),
                  ),
              const SizedBox(height: 12),
              isResending
                  ? const CircularProgressIndicator()
                  : TextButton(
                    onPressed: resendCode,
                    child: const Text('Resend Code'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
