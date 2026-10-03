import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';

/// One line of text with the part that matches [query] in bold, so a
/// suggestion shows what the renter's typing was matched against. Matching
/// ignores case but the text keeps its own capitals. With no match, the text
/// is shown plain.
class MatchHighlightText extends StatelessWidget {
  const MatchHighlightText({
    required this.text,
    required this.query,
    super.key,
  });

  final String text;
  final String query;

  @override
  Widget build(BuildContext context) {
    final needle = query.trim();
    final start = needle.isEmpty
        ? -1
        : text.toLowerCase().indexOf(needle.toLowerCase());
    if (start < 0) {
      return Text(
        text,
        style: AppTextStyles.kTextBodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    final end = start + needle.length;
    return Text.rich(
      TextSpan(
        style: AppTextStyles.kTextBodyMedium,
        children: [
          TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: text.substring(start, end),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: text.substring(end)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
