import 'package:restaurant_flutter/models/service/conversation.dart';
import 'package:restaurant_flutter/models/service/user.dart';
import 'package:restaurant_flutter/utils/utils.dart';

class MessageDetailModel {
  final int messageId;
  final int conversationId;
  final int userId;
  final String content;
  final String createdAt;
  final String updatedAt;
  final UserModel? user;
  final ConversationDetailModel? conversation;
  MessageDetailModel({
    this.messageId = 0,
    this.conversationId = 0,
    this.userId = 0,
    this.content = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.user,
    this.conversation,
  });

  factory MessageDetailModel.fromJson(Map<String, dynamic> json) {
    return MessageDetailModel(
      messageId: ParseTypeData.ensureInt(json["messageId"]),
      conversationId: ParseTypeData.ensureInt(json["conversationId"]),
      userId: ParseTypeData.ensureInt(json["userId"]),
      content: ParseTypeData.ensureString(json["content"]),
      createdAt: ParseTypeData.ensureString(json["createdAt"]),
      updatedAt: ParseTypeData.ensureString(json["updatedAt"]),
      user: UserModel.fromJson(json["User"] ?? {}),
      conversation:
          ConversationDetailModel.fromJson(json["Conversation"] ?? {}),
    );
  }

  static List<MessageDetailModel> parseListItem(dynamic data) {
    List<MessageDetailModel> list = [];
    if (data is List) {
      for (var item in data) {
        MessageDetailModel model = MessageDetailModel.fromJson(item);
        list.add(model);
      }
    }
    return list;
  }
}
