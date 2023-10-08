import 'package:restaurant_flutter/models/service/message.dart';
import 'package:restaurant_flutter/utils/utils.dart';

class ClientConversationModel {
  final List<MessageDetailModel> messages;
  final bool isSuccess;

  ClientConversationModel({
    this.messages = const [],
    this.isSuccess = false,
  });

  factory ClientConversationModel.fromJson(Map<String, dynamic> json) {
    return ClientConversationModel(
      messages: MessageDetailModel.parseListItem(json["allMessage"]),
      isSuccess: ParseTypeData.ensureBool(json["isSuccess"]),
    );
  }
}
