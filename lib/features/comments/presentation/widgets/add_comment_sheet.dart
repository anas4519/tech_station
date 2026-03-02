import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/comment_entity.dart';

class AddCommentSheet extends StatefulWidget {
  final String deviceId;
  final String? parentId;
  final void Function(String type, String body) onSubmit;

  const AddCommentSheet({
    super.key,
    required this.deviceId,
    this.parentId,
    required this.onSubmit,
  });

  @override
  State<AddCommentSheet> createState() => _AddCommentSheetState();
}

class _AddCommentSheetState extends State<AddCommentSheet> {
  CommentType _selectedType = CommentType.generalExperience;
  final _bodyController = TextEditingController();
  static const int _minChars = 20;

  bool get _isValid => _bodyController.text.trim().length >= _minChars;

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ──
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey700 : AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            widget.parentId != null ? 'Write a Reply' : 'Share Your Experience',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // ── Type picker (only for top-level comments) ──
          if (widget.parentId == null) ...[
            Text(
              'Category',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: CommentType.values.map((type) {
                final isSelected = type == _selectedType;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = type),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : AppColors.primarySurface)
                          : (isDark
                                ? AppColors.darkElevated
                                : AppColors.grey100),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? (isDark
                                  ? AppColors.accentLight
                                  : AppColors.primary)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      '${type.emoji} ${type.label}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? (isDark
                                  ? AppColors.accentLight
                                  : AppColors.primary)
                            : (isDark ? AppColors.grey400 : AppColors.grey600),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // ── Body field ──
          TextField(
            controller: _bodyController,
            maxLines: 4,
            minLines: 3,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: widget.parentId != null
                  ? 'Write your reply...'
                  : 'Share your experience with this device...',
              hintStyle: TextStyle(
                color: isDark ? AppColors.grey600 : AppColors.grey400,
              ),
              filled: true,
              fillColor: isDark ? AppColors.darkElevated : AppColors.grey100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 8),

          // ── Character count ──
          Row(
            children: [
              Text(
                '${_bodyController.text.trim().length}/$_minChars min characters',
                style: TextStyle(
                  fontSize: 11,
                  color: _isValid
                      ? (isDark ? AppColors.grey500 : AppColors.grey600)
                      : Colors.red.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_isValid)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: Colors.green.shade400,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Submit button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValid
                  ? () {
                      widget.onSubmit(
                        _selectedType.dbValue,
                        _bodyController.text.trim(),
                      );
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: isDark
                    ? AppColors.grey800
                    : AppColors.grey200,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.parentId != null ? 'Post Reply' : 'Post Comment',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
