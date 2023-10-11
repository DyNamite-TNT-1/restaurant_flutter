part of 'messenger_bloc.dart';

class MessengerState extends Equatable {
  final List<ClientConversationModel> clientConversationModel;
  final BlocState conversationState;
  final ClientMessageModel? clientMessageModel;
  final BlocState messageState;

  const MessengerState({
    this.clientConversationModel = const [],
    this.conversationState = BlocState.init,
    this.clientMessageModel,
    this.messageState = BlocState.init,
  });

  MessengerState copyWith({
    List<ClientConversationModel>? clientConversationModel,
    BlocState? conversationState,
    ClientMessageModel? clientMessageModel,
    BlocState? messageState,
  }) {
    return MessengerState(
      clientConversationModel:
          clientConversationModel ?? this.clientConversationModel,
      conversationState: conversationState ?? this.conversationState,
      clientMessageModel: clientMessageModel ?? this.clientMessageModel,
      messageState: messageState ?? this.messageState,
    );
  }

  @override
  List<Object> get props => [
        clientConversationModel,
        conversationState,
        messageState,
      ];
}
