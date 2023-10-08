part of 'messenger_bloc.dart';

class MessengerState extends Equatable {
  final ClientConversationModel? conversation;
  final BlocState conversationState;

  const MessengerState({
    this.conversation,
    this.conversationState = BlocState.init,
  });

  MessengerState copyWith({
    ClientConversationModel? conversation,
    BlocState? conversationState,
  }) {
    return MessengerState(
      conversation: conversation ?? this.conversation,
      conversationState: conversationState ?? this.conversationState,
    );
  }

  @override
  List<Object> get props => [
        conversationState,
      ];
}
