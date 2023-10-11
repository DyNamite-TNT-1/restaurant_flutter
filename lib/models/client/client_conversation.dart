import 'package:restaurant_flutter/models/service/conversation.dart';
import 'package:restaurant_flutter/models/service/user.dart';

class ClientConversationModel {
  final UserModel? user;
  final ConversationDetailModel? conversation;
  ClientConversationModel({
    this.user,
    this.conversation,
  });

  factory ClientConversationModel.fromJson(Map<String, dynamic> json) {
    return ClientConversationModel(
      user: UserModel.fromJson(json["user"]),
      conversation: ConversationDetailModel.fromJson(json["conversation"]),
    );
  }

  static List<ClientConversationModel> parseListItem(dynamic data) {
    List<ClientConversationModel> list = [];
    if (data is List) {
      for (var item in data) {
        ClientConversationModel model = ClientConversationModel.fromJson(item);
        list.add(model);
      }
    }
    return list;
  }
}

