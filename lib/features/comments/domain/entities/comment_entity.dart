import 'package:equatable/equatable.dart';

/// The 8 structured comment types.
enum CommentType {
  firstImpression('first_impression', '🔥', 'First Impression'),
  batteryReport('battery_report', '🔋', 'Battery Report'),
  heatingIssue('heating_issue', '🌡️', 'Heating Issue'),
  bug('bug', '🐞', 'Bug'),
  cameraFeedback('camera_feedback', '📸', 'Camera Feedback'),
  performance('performance', '🧠', 'Performance'),
  generalExperience('general_experience', '👍', 'General Experience'),
  question('question', '❓', 'Question');

  final String dbValue;
  final String emoji;
  final String label;

  const CommentType(this.dbValue, this.emoji, this.label);

  static CommentType fromDb(String value) {
    return CommentType.values.firstWhere(
      (e) => e.dbValue == value,
      orElse: () => CommentType.generalExperience,
    );
  }
}

/// Sort options for the comments list.
enum CommentSort {
  newest('created_at', 'Newest'),
  mostHelpful('helpful_count', 'Most Helpful');

  final String column;
  final String label;
  const CommentSort(this.column, this.label);
}

/// Filter presets for the tab chips.
enum CommentFilter {
  all('All', null),
  issues('Issues', null), // bug + heating_issue
  battery('Battery', null), // battery_report
  camera('Camera', null), // camera_feedback
  questions('Questions', null); // question

  final String label;
  final CommentType? singleType;
  const CommentFilter(this.label, this.singleType);

  List<String> get dbValues {
    switch (this) {
      case CommentFilter.all:
        return [];
      case CommentFilter.issues:
        return ['bug', 'heating_issue'];
      case CommentFilter.battery:
        return ['battery_report'];
      case CommentFilter.camera:
        return ['camera_feedback'];
      case CommentFilter.questions:
        return ['question'];
    }
  }
}

class CommentEntity extends Equatable {
  final String id;
  final String deviceId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final CommentType type;
  final String body;
  final int helpfulCount;
  final bool isAnswered;
  final String? bestAnswerId;
  final String? parentId;
  final bool isVotedByMe;
  final DateTime createdAt;
  final List<CommentEntity> replies;

  const CommentEntity({
    required this.id,
    required this.deviceId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.type,
    required this.body,
    this.helpfulCount = 0,
    this.isAnswered = false,
    this.bestAnswerId,
    this.parentId,
    this.isVotedByMe = false,
    required this.createdAt,
    this.replies = const [],
  });

  @override
  List<Object?> get props => [id, helpfulCount, isVotedByMe, isAnswered];
}
