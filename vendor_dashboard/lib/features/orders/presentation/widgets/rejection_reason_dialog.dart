import 'package:flutter/material.dart';
import 'package:vendor_dashboard/core/theme/vendor_colors.dart';
import 'package:vendor_dashboard/core/theme/vendor_text_styles.dart';

class RejectionReasonDialog extends StatefulWidget {
  const RejectionReasonDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => const RejectionReasonDialog(),
    );
  }

  @override
  State<RejectionReasonDialog> createState() => _RejectionReasonDialogState();
}

class _RejectionReasonDialogState extends State<RejectionReasonDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('سبب رفض الطلب', style: VendorTextStyles.titleMedium),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'يرجى كتابة سبب عدم قبول الطلب...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: VendorColors.error),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'سبب الرفض مطلوب';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: VendorTextStyles.bodyMedium.copyWith(
                color: VendorColors.grey,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: VendorColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context, _controller.text.trim());
              }
            },
            child: Text(
              'تأكيد الرفض',
              style: VendorTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
