import 'package:restaurant_flutter/models/service/message.dart';
import 'package:restaurant_flutter/utils/utils.dart';

class ClientMessageModel {
  final List<MessageDetailModel> messages;
  final bool isSuccess;

  ClientMessageModel({
    this.messages = const [],
    this.isSuccess = false,
  });

  factory ClientMessageModel.fromJson(Map<String, dynamic> json) {
    return ClientMessageModel(
      messages: MessageDetailModel.parseListItem(json["allMessage"]),
      isSuccess: ParseTypeData.ensureBool(json["isSuccess"]),
    );
  }
}
