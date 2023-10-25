import 'package:restaurant_flutter/utils/utils.dart';

class ConversationDetailModel {
  final int conversationId;
  bool acceptManager;
  final String createdAt;
  final String updatedAt;

  ConversationDetailModel({
    this.conversationId = 0,
    this.acceptManager = false,
    this.createdAt = "",
    this.updatedAt = "",
  });
  factory ConversationDetailModel.fromJson(Map<String, dynamic> json) {
    return ConversationDetailModel(
      conversationId: ParseTypeData.ensureInt(json["conversationId"]),
      acceptManager: ParseTypeData.ensureBool(json["accept_manager"]),
      createdAt: ParseTypeData.ensureString(json["createdAt"]),
      updatedAt: ParseTypeData.ensureString(json["updatedAt"]),
    );
  }
}
