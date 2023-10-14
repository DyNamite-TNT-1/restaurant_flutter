part of 'messenger_bloc.dart';

class MessengerState extends Equatable {
  final ClientConversationModel? selectedConversation;
  final List<ClientConversationModel> conversations; // conversation list
  final BlocState conversationState;
  final ClientMessageModel? messages; // message list of selectedConversation
  final BlocState messageState;
  final BlocState acceptMessageSate;
  final BlocState sendMessageState;
  final String msg;

  const MessengerState({
    this.selectedConversation,
    this.conversations = const [],
    this.conversationState = BlocState.init,
    this.messages,
    this.messageState = BlocState.init,
    this.acceptMessageSate = BlocState.init,
    this.sendMessageState = BlocState.init,
    this.msg = "",
  });

  MessengerState copyWith({
    ClientConversationModel? selectedConversation,
    List<ClientConversationModel>? clientConversationModel,
    BlocState? conversationState,
    ClientMessageModel? clientMessageModel,
    BlocState? messageState,
    BlocState? acceptMessageSate,
    BlocState? sendMessageState,
    String? msg,
  }) {
    return MessengerState(
      selectedConversation: selectedConversation ?? this.selectedConversation,
      conversations: clientConversationModel ?? this.conversations,
      conversationState: conversationState ?? this.conversationState,
      messages: clientMessageModel ?? this.messages,
      messageState: messageState ?? this.messageState,
      acceptMessageSate: acceptMessageSate ?? this.acceptMessageSate,
      sendMessageState: sendMessageState ?? this.sendMessageState,
      msg: msg ?? this.msg,
    );
  }

  @override
  List<Object> get props => [
        conversations,
        conversationState,
        messageState,
        acceptMessageSate,
        sendMessageState,
        msg,
      ];
}
