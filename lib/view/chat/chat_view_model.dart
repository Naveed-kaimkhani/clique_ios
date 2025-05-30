import 'dart:async';
import 'dart:convert';
import 'package:clique/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ChatViewModel extends GetxController {
  final RxBool isReactionSheetVisible = false.obs;
  OverlayEntry? _reactionOverlay;
// OverlayEntry? _reactionOverlay;

  final Map<String, StreamController<Map<String, int>>> _reactionControllers =
      {};
  final Set<String> startedStreams = {};
  final Map<String, Set<String>> _userReactions =
      {}; // key = "$messageId:$reaction", value = Set of uids
  final Rx<MessageModel?> repliedMessage = Rx<MessageModel?>(null);
  void setReplyMessage(MessageModel message) {
    HapticFeedback.mediumImpact();

    repliedMessage.value = message;
  }

  void clearReplyMessage() {
    repliedMessage.value = null;
  }

  void showReactionSheet(OverlayEntry entry, context) {
    HapticFeedback.mediumImpact();
    _reactionOverlay?.remove();
    _reactionOverlay = entry;
    isReactionSheetVisible.value = true;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  void hideReactionSheet() {
    _reactionOverlay?.remove();
    _reactionOverlay = null;
    isReactionSheetVisible.value = false;
  }

  Future<void> toggleReaction(
      String messageId, String reaction, int uid) async {
    HapticFeedback.mediumImpact();
    final key = "$messageId:$reaction";
    final userIdStr = uid.toString();
    final alreadyReacted = _userReactions[key]?.contains(userIdStr) ?? false;

    if (alreadyReacted) {
      await removeReactionFromMessage(messageId, reaction, uid);
    } else {
      await addReactionToMessage(messageId, reaction, uid);
    }

    // Fetch latest reactions after toggle
    final updated = await fetchReactions(messageId);
    _reactionControllers[messageId]?.add(updated);
  }

  Future<void> addReactionToMessage(
      String messageId, String reaction, int uid) async {
    final url = Uri.parse(
        "https://269435d754e8fd97.api-us.cometchat.io/v3/messages/$messageId/reactions/$reaction");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'apikey': 'f6985bc6a317824cc687e82794955efded6bf2b1',
          'onBehalfOf': uid.toString(),
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final key = "$messageId:$reaction";
        _userReactions.putIfAbsent(key, () => {}).add(uid.toString());
      } else {
        Get.snackbar('Error', 'Failed to add reaction');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> removeReactionFromMessage(
      String messageId, String reaction, int uid) async {
    final url = Uri.parse(
        "https://269435d754e8fd97.api-us.cometchat.io/v3/messages/$messageId/reactions/$reaction");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'apikey': 'f6985bc6a317824cc687e82794955efded6bf2b1',
          'onBehalfOf': uid.toString(),
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        final key = "$messageId:$reaction";
        _userReactions[key]?.remove(uid.toString());
      } else {
        Get.snackbar('Error', 'Failed to remove reaction');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Stream<Map<String, int>> getReactionsStream(String messageId) {
    if (!startedStreams.contains(messageId)) {
      final controller = StreamController<Map<String, int>>.broadcast();
      _reactionControllers[messageId] = controller;
      startedStreams.add(messageId);

      Timer.periodic(const Duration(seconds: 5), (timer) async {
        if (!controller.isClosed) {
          final data = await fetchReactions(messageId);
          controller.add(data);
        } else {
          timer.cancel();
        }
      });
    }
    return _reactionControllers[messageId]!.stream;
  }

  Future<Map<String, int>> fetchReactions(String messageId) async {
    try {
      const String apiKey = 'f6985bc6a317824cc687e82794955efded6bf2b1';
      const String region = 'us';
      const String appId = '269435d754e8fd97';

      final url = Uri.parse(
          'https://$appId.api-$region.cometchat.io/v3/messages/$messageId/reactions');

      final response = await http.get(url, headers: {
        'accept': 'application/json',
        'apikey': apiKey,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List reactions = data['data'] ?? [];

        final Map<String, int> grouped = {};
        for (var r in reactions) {
          final emoji = r['reaction'];
          final uid = r['metadata']?['uid']?.toString();
          if (uid != null) {
            final key = "$messageId:$emoji";
            _userReactions.putIfAbsent(key, () => {}).add(uid);
          }

          grouped[emoji] = (grouped[emoji] ?? 0) + 1;
        }

        return grouped;
      } else {
        print('Failed to fetch reactions: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception fetching reactions: $e');
    }

    return {};
  }

  @override
  void onClose() {
    for (final controller in _reactionControllers.values) {
      controller.close();
    }
    _reactionControllers.clear();
    super.onClose();
  }
}
