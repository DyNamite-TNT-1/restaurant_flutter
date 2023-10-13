part of 'messenger_bloc.dart';

class MessengerState extends Equatable {
  final ClientConversationModel? selectedConversation;
  final List<ClientConversationModel> clientConversationModel;
  final BlocState conversationState;
  final ClientMessageModel? clientMessageModel;
  final BlocState messageState;
  final BlocState acceptMessageSate;
  final String msg;

  const MessengerState({
    this.selectedConversation,
    this.clientConversationModel = const [],
    this.conversationState = BlocState.init,
    this.clientMessageModel,
    this.messageState = BlocState.init,
    this.acceptMessageSate = BlocState.init,
    this.msg = "",
  });

  MessengerState copyWith({
    ClientConversationModel? selectedConversation,
    List<ClientConversationModel>? clientConversationModel,
    BlocState? conversationState,
    ClientMessageModel? clientMessageModel,
    BlocState? messageState,
    BlocState? acceptMessageSate,
    String? msg,
  }) {
    return MessengerState(
      selectedConversation: selectedConversation ?? this.selectedConversation,
      clientConversationModel:
          clientConversationModel ?? this.clientConversationModel,
      conversationState: conversationState ?? this.conversationState,
      clientMessageModel: clientMessageModel ?? this.clientMessageModel,
      messageState: messageState ?? this.messageState,
      acceptMessageSate: acceptMessageSate ?? this.acceptMessageSate,
      msg: msg ?? this.msg,
    );
  }

  @override
  List<Object> get props => [
        clientConversationModel,
        conversationState,
        messageState,
        acceptMessageSate,
        msg,
      ];
}
