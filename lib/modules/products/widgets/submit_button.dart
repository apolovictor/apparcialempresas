import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubmitButton extends HookConsumerWidget {
  const SubmitButton({
    super.key,
    required this.buttonName,
    required this.animation,
  });

  final String buttonName;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  register button
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      child: ScaleTransition(
        scale: animation,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                backgroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(60)),
            icon: const Icon(Icons.done_outline, color: Colors.white, size: 32),
            label: const Text(
              'Enviar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              // final isValid = formKey.currentState!.validate();
              // if (!isValid) return;

              // Utils.showSnackBar(getErrorCode(e.message.toString()))
              // print("errorCode $errorCode");
            }

            // signUp
            ),
      ),
    );
  }
}
