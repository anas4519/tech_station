import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getComments({
    required String deviceId,
    List<String> types,
    String sortBy,
    int page,
    int limit,
  });

  Future<CommentModel> addComment({
    required String deviceId,
    required String type,
    required String body,
    String? parentId,
  });

  Future<CommentModel> toggleVote(String commentId);

  Future<void> markAsAnswered({
    required String commentId,
    required String bestAnswerId,
  });

  Future<void> deleteComment(String commentId);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final SupabaseClient _supabase;

  CommentRemoteDataSourceImpl({required SupabaseClient supabaseClient})
    : _supabase = supabaseClient;

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  @override
  Future<List<CommentModel>> getComments({
    required String deviceId,
    List<String> types = const [],
    String sortBy = 'created_at',
    int page = 0,
    int limit = 20,
  }) async {
    try {
      // Fetch top-level comments (no parent)
      var query = _supabase
          .from('comments')
          .select()
          .eq('device_id', deviceId)
          .isFilter('parent_id', null);

      if (types.isNotEmpty) {
        query = query.inFilter('type', types);
      }

      final from = page * limit;
      final to = from + limit - 1;

      final data = await query.order(sortBy, ascending: false).range(from, to);

      // Get current user's votes
      Set<String> votedIds = {};
      if (_currentUserId != null) {
        final commentIds = (data as List)
            .map((c) => c['id'] as String)
            .toList();
        if (commentIds.isNotEmpty) {
          final votes = await _supabase
              .from('comment_votes')
              .select('comment_id')
              .eq('user_id', _currentUserId!)
              .inFilter('comment_id', commentIds);
          votedIds = (votes as List)
              .map((v) => v['comment_id'] as String)
              .toSet();
        }
      }

      // Fetch replies for these comments
      final parentIds = (data as List).map((c) => c['id'] as String).toList();
      List repliesData = [];
      if (parentIds.isNotEmpty) {
        repliesData = await _supabase
            .from('comments')
            .select()
            .inFilter('parent_id', parentIds)
            .order('created_at', ascending: true);
      }

      // Get votes for replies too
      Set<String> replyVotedIds = {};
      if (_currentUserId != null && repliesData.isNotEmpty) {
        final replyIds = repliesData.map((r) => r['id'] as String).toList();
        final replyVotes = await _supabase
            .from('comment_votes')
            .select('comment_id')
            .eq('user_id', _currentUserId!)
            .inFilter('comment_id', replyIds);
        replyVotedIds = (replyVotes as List)
            .map((v) => v['comment_id'] as String)
            .toSet();
      }

      // Group replies by parent
      final Map<String, List<CommentModel>> repliesByParent = {};
      for (final r in repliesData) {
        final pid = r['parent_id'] as String;
        repliesByParent.putIfAbsent(pid, () => []);
        repliesByParent[pid]!.add(
          CommentModel.fromJson(
            r as Map<String, dynamic>,
            votedByMe: replyVotedIds.contains(r['id']),
          ),
        );
      }

      return (data as List).map((json) {
        final id = json['id'] as String;
        return CommentModel.fromJson(
          json as Map<String, dynamic>,
          votedByMe: votedIds.contains(id),
          replies: repliesByParent[id] ?? [],
        );
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommentModel> addComment({
    required String deviceId,
    required String type,
    required String body,
    String? parentId,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw const ServerException('Not authenticated');

      final payload = {
        'device_id': deviceId,
        'user_id': user.id,
        'user_name':
            user.userMetadata?['full_name'] ??
            user.userMetadata?['name'] ??
            user.email?.split('@').first ??
            'User',
        'user_avatar_url': user.userMetadata?['avatar_url'],
        'type': type,
        'body': body,
        if (parentId != null) 'parent_id': parentId,
      };

      final data = await _supabase
          .from('comments')
          .insert(payload)
          .select()
          .single();

      return CommentModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommentModel> toggleVote(String commentId) async {
    try {
      final userId = _currentUserId;
      if (userId == null) throw const ServerException('Not authenticated');

      // Check if already voted
      final existing = await _supabase
          .from('comment_votes')
          .select()
          .eq('user_id', userId)
          .eq('comment_id', commentId)
          .maybeSingle();

      if (existing != null) {
        // Remove vote
        await _supabase
            .from('comment_votes')
            .delete()
            .eq('user_id', userId)
            .eq('comment_id', commentId);
      } else {
        // Add vote
        await _supabase.from('comment_votes').insert({
          'user_id': userId,
          'comment_id': commentId,
        });
      }

      // Fetch updated comment
      final updated = await _supabase
          .from('comments')
          .select()
          .eq('id', commentId)
          .single();

      return CommentModel.fromJson(
        updated,
        votedByMe: existing == null, // toggled: was not voted → now voted
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markAsAnswered({
    required String commentId,
    required String bestAnswerId,
  }) async {
    try {
      await _supabase
          .from('comments')
          .update({'is_answered': true, 'best_answer_id': bestAnswerId})
          .eq('id', commentId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      await _supabase.from('comments').delete().eq('id', commentId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
