import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// "By continuing, you agree to our Terms of Service and Privacy Policy."
///
/// Both names are tappable. The documents are not published yet, so by default
/// a tap shows a "coming soon" message; pass [onTerms] / [onPrivacy] once they
/// have somewhere to go.
class LegalNotice extends StatefulWidget {
  const LegalNotice({
    required this.prefix,
    this.onTerms,
    this.onPrivacy,
    super.key,
  });

  /// Start of the sentence, for example `By continuing`.
  final String prefix;
  final VoidCallback? onTerms;
  final VoidCallback? onPrivacy;

  @override
  State<LegalNotice> createState() => _LegalNoticeState();
}

class _LegalNoticeState extends State<LegalNotice> {
  late final TapGestureRecognizer _terms;
  late final TapGestureRecognizer _privacy;

  @override
  void initState() {
    super.initState();
    _terms = TapGestureRecognizer()
      ..onTap = widget.onTerms ?? () => _comingSoon('Terms of Service');
    _privacy = TapGestureRecognizer()
      ..onTap = widget.onPrivacy ?? () => _comingSoon('Privacy Policy');
  }

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  void _comingSoon(String document) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$document will be available soon.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final link = AppTextStyles.kTextBodySmall.copyWith(
      color: AppColors.kColorPrimary,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.kColorPrimary,
    );
    return Text.rich(
      TextSpan(
        style: AppTextStyles.kTextBodySmall,
        children: [
          TextSpan(text: '${widget.prefix}, you agree to our '),
          TextSpan(
            text: 'Terms\u00A0of\u00A0Service',
            style: link,
            recognizer: _terms,
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy\u00A0Policy',
            style: link,
            recognizer: _privacy,
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
