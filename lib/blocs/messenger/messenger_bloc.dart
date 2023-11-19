import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/bloc.dart';
import 'package:restaurant_flutter/models/client/client_conversation.dart';
import 'package:restaurant_flutter/models/service/message.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/utils/utils.dart';

import '../../models/client/client_message.dart';

part 'messenger_event.dart';
part 'messenger_state.dart';

class MessengerBloc extends Bloc<MessengerEvent, MessengerState> {
  static String tagRequestMessages =
      Api.buildIncreaseTagRequestWithID("messengerBloc_messages");
  static String tagRequestConversations =
      Api.buildIncreaseTagRequestWithID("messengerBloc_conversations");
  static String tagRequestAcceptConversation =
      Api.buildIncreaseTagRequestWithID("messengerBloc_acceptConversation");
  static String tagRequestCreateConversation =
      Api.buildIncreaseTagRequestWithID("messengerBloc_createConversation");
  static String tagRequestSendMessage =
      Api.buildIncreaseTagRequestWithID("messengerBloc_sendMessage");

  static bool isClientJoinedToSocket = false;

  MessengerBloc(MessengerState state) : super(state) {
    on<OnSelectConversation>(_onSelectConversation);
    on<OnLoadMessage>(_onLoadMessages);
    on<OnLoadConversation>(_onLoadConversations);
    on<OnAcceptConversation>(_onAcceptConversation);
    on<OnSendMessage>(_onSendMessage);
    on<OnReceiveMessageFromSocket>(_onReceiveMessageFromSocket);
  }

  Future<void> _onSelectConversation(
      OnSelectConversation event, Emitter emit) async {
    int selectedConversationId =
        event.params.containsKey("id") ? event.params["id"] : 0;
    if (!isClosed) {
      emit(state.copyWith(
        messageState: BlocState.loading,
      ));
      if (selectedConversationId == 0) {
        emit(state.copyWith(
          messageState: BlocState.loadFailed,
          selectedConversation: ClientConversationModel(),
        ));
      } else {
        ClientConversationModel selectedConversation =
            ClientConversationModel();
        for (var conversation in state.conversations) {
          if (selectedConversationId ==
              conversation.conversation!.conversationId) {
            selectedConversation = conversation;
            break;
          }
        }
        emit(state.copyWith(
          messageState: BlocState.loadCompleted,
          selectedConversation: selectedConversation,
        ));
        if (selectedConversation.conversation!.acceptManager) {
          add(OnLoadMessage(params: {
            "conversationId": selectedConversation.conversation!.conversationId
          }));
        } else {
          emit(state.copyWith(
            messageState: BlocState.noData,
            selectedConversation: selectedConversation,
            messages: [],
          ));
        }
      }
    }
  }

  Future<void> _onLoadMessages(OnLoadMessage event, Emitter emit) async {
    if (UserRepository.userModel.isManager) {
      int conversationId = event.params.containsKey("conversationId")
          ? event.params["conversationId"]
          : 0;
      BlocState? messageState = event.params["messageState"];
      if (conversationId == 0) {
        if (!isClosed) {
          emit(state.copyWith(
            messageState: BlocState.loadFailed,
            msg: "CONVERSATION_NOT_FOUND",
          ));
        }
      } else {
        if (!isClosed) {
          emit(state.copyWith(
            messageState: messageState ?? BlocState.loading,
          ));
          ResultModel result = await Api.requestDetailConversation(
            conversationId: conversationId,
            tagRequest: tagRequestMessages,
          );
          if (result.isSuccess) {
            ClientMessageModel clientMessageModel =
                ClientMessageModel.fromJson(result.data);
            emit(state.copyWith(
              messages:
                  MessageDetailModel.parseListItem(result.data["allMessage"]),
              messageState: clientMessageModel.messages.isEmpty
                  ? BlocState.noData
                  : BlocState.loadCompleted,
            ));
          } else {
            emit(state.copyWith(
              messageState: BlocState.loadFailed,
              msg: result.message,
            ));
          }
        }
      }
    } else if (UserRepository.userModel.isClient) {
      BlocState? messageState = event.params["messageState"];
      if (!isClosed) {
        emit(state.copyWith(
          messageState: messageState ?? BlocState.loading,
        ));
        ResultModel result = await Api.requestClientMessage(
          tagRequest: tagRequestMessages,
        );
        if (result.isSuccess) {
          List<MessageDetailModel> messages =
              MessageDetailModel.parseListItem(result.data["allMessage"]);
          if (messages.isNotEmpty) {
            if (!isClientJoinedToSocket) {
              isClientJoinedToSocket = true;
              SocketClient.socket!.emit("join", {
                jsonEncode({
                  "conversationId": messages.first.conversationId,
                })
              });
            }
          }
          emit(state.copyWith(
            messages: messages,
            messageState:
                messages.isEmpty ? BlocState.noData : BlocState.loadCompleted,
          ));
        } else {
          emit(state.copyWith(
            messageState: BlocState.loadFailed,
            msg: result.message,
          ));
        }
      }
    }
  }

  Future<void> _onLoadConversations(
      OnLoadConversation event, Emitter emit) async {
    if (!isClosed) {
      emit(state.copyWith(
        conversationState: BlocState.loading,
      ));
      ResultModel result = await _loadConversationList();
      if (result.isSuccess) {
        List<ClientConversationModel> clientConversationModel =
            ClientConversationModel.parseListItem(result.data["conversations"]);
        clientConversationModel.forEach((element) {
          SocketClient.socket!.emit("join", {
            jsonEncode({
              "conversationId": element.conversation!.conversationId,
            })
          });
        });
        emit(state.copyWith(
          conversations: clientConversationModel,
          conversationState: clientConversationModel.isEmpty
              ? BlocState.noData
              : BlocState.loadCompleted,
        ));
      } else {
        emit(state.copyWith(
          conversationState: BlocState.loadFailed,
          msg: result.message,
        ));
      }
    }
  }

  Future<ResultModel> _loadConversationList() async {
    Api.cancelRequest(tag: tagRequestConversations);
    tagRequestConversations =
        Api.buildIncreaseTagRequestWithID("messengerBloc_conversations");
    ResultModel result = await Api.requestListConversation(
      tagRequest: tagRequestConversations,
    );
    return result;
  }

  Future<void> _onAcceptConversation(
      OnAcceptConversation event, Emitter emit) async {
    ClientConversationModel conversationModel =
        event.params["conversationNeedAccept"];
    if (!isClosed) {
      emit(state.copyWith(
        acceptMessageState: BlocState.loading,
        messageState: BlocState.loading,
      ));
      ResultModel result = await Api.requestAcceptConversation(
        conversationId: conversationModel.conversation!.conversationId,
        tagRequest: tagRequestAcceptConversation,
      );
      if (result.isSuccess) {
        for (var conversation in state.conversations) {
          if (conversationModel.conversation!.conversationId ==
              conversation.conversation!.conversationId) {
            conversation.conversation!.acceptManager = true;
            break;
          }
        }
        add(OnSelectConversation(params: {
          "id": conversationModel.conversation!.conversationId,
        }));
        emit(state.copyWith(
          acceptMessageState: BlocState.loadCompleted,
          msg: result.message,
        ));
      } else {
        emit(state.copyWith(
          conversationState: BlocState.loadFailed,
          msg: result.message,
        ));
      }
    }
  }

  Future<void> _onSendMessage(OnSendMessage event, Emitter emit) async {
    if (!isClosed) {
      String content =
          event.params.containsKey("content") ? event.params["content"] : "";
      emit(state.copyWith(
        sendMessageState: BlocState.loading,
      ));
      if (UserRepository.userModel.isClient &&
          state.messages.isEmpty &&
          state.messageState == BlocState.noData) {
        ResultModel result = await Api.requestCreateConversation(
          content: content,
          tagRequest: tagRequestCreateConversation,
        );
        if (result.isSuccess) {
          int conversationId =
              ParseTypeData.ensureInt(result.data["coversationId"]);
          if (!isClientJoinedToSocket) {
            isClientJoinedToSocket = true;
            SocketClient.socket!.emit("join", {
              jsonEncode({
                "conversationId": conversationId,
              })
            });
          }
          SocketClient.socket!.emit('send-message', {
            jsonEncode({
              "conversationId": conversationId,
              "senderId": UserRepository.userModel.userId,
              "message": content,
            })
          });
          emit(state.copyWith(
            sendMessageState: BlocState.loadCompleted,
            msg: result.message,
          ));
          add(OnLoadMessage(params: {
            "conversationId": conversationId,
            "messageState": BlocState.loadingSilent,
          }));
        } else {
          emit(state.copyWith(
            sendMessageState: BlocState.loadFailed,
            msg: result.message,
          ));
        }
      } else {
        ResultModel result = await Api.requestCreateMessage(
          conversationId: UserRepository.userModel.isClient
              ? state.messages.first.conversationId
              : state.selectedConversation!.conversation!.conversationId,
          content: content,
          tagRequest: tagRequestSendMessage,
        );
        if (result.isSuccess) {
          SocketClient.socket!.emit('send-message', {
            jsonEncode({
              "conversationId": UserRepository.userModel.isClient
                  ? state.messages.first.conversationId
                  : state.selectedConversation!.conversation!.conversationId,
              "senderId": UserRepository.userModel.userId,
              "message": content,
            })
          });
          emit(state.copyWith(
            sendMessageState: BlocState.loadCompleted,
            msg: result.message,
          ));
          add(OnLoadMessage(params: {
            "conversationId": UserRepository.userModel.isClient
                ? state.messages.first.conversationId
                : state.selectedConversation!.conversation!.conversationId,
            "messageState": BlocState.loadingSilent,
          }));
        } else {
          emit(state.copyWith(
            sendMessageState: BlocState.loadFailed,
            msg: result.message,
          ));
        }
      }
    }
  }

  void _onReceiveMessageFromSocket(
      OnReceiveMessageFromSocket event, Emitter emit) {
    if (!isClosed) {
      emit(state.copyWith(messageState: BlocState.loadingSilent));
      MessageDetailModel message = event.params.containsKey("message")
          ? event.params["message"]
          : MessageDetailModel();
      emit(state.copyWith(
        messageState: BlocState.loadCompleted,
        messages: [...state.messages, message],
      ));
    }
  }

  @override
  Future<void> close() async {
    super.close();
    Api.cancelRequest(tag: tagRequestMessages);
    Api.cancelRequest(tag: tagRequestConversations);
    Api.cancelRequest(tag: tagRequestAcceptConversation);
    Api.cancelRequest(tag: tagRequestSendMessage);
    Api.cancelRequest(tag: tagRequestCreateConversation);
  }
}
