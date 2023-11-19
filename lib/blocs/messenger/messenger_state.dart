part of 'messenger_bloc.dart';

class MessengerState extends Equatable {
  final ClientConversationModel? selectedConversation;
  final List<ClientConversationModel> conversations; // conversation list
  final BlocState conversationState;
  final List<MessageDetailModel>
      messages; // message list of selectedConversation
  final BlocState messageState;
  final BlocState acceptMessageState;
  final BlocState sendMessageState;
  final String msg;

  const MessengerState({
    this.selectedConversation,
    this.conversations = const [],
    this.conversationState = BlocState.init,
    this.messages = const [],
    this.messageState = BlocState.init,
    this.acceptMessageState = BlocState.init,
    this.sendMessageState = BlocState.init,
    this.msg = "",
  });

  MessengerState copyWith({
    ClientConversationModel? selectedConversation,
    List<ClientConversationModel>? conversations,
    BlocState? conversationState,
    List<MessageDetailModel>? messages,
    BlocState? messageState,
    BlocState? acceptMessageState,
    BlocState? sendMessageState,
    String? msg,
  }) {
    return MessengerState(
      selectedConversation: selectedConversation ?? this.selectedConversation,
      conversations: conversations ?? this.conversations,
      conversationState: conversationState ?? this.conversationState,
      messages: messages ?? this.messages,
      messageState: messageState ?? this.messageState,
      acceptMessageState: acceptMessageState ?? this.acceptMessageState,
      sendMessageState: sendMessageState ?? this.sendMessageState,
      msg: msg ?? this.msg,
    );
  }

  @override
  List<Object> get props => [
        conversations,
        conversationState,
        messageState,
        acceptMessageState,
        sendMessageState,
        msg,
      ];
}
