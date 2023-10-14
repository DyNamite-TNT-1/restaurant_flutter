part of 'messenger_bloc.dart';

abstract class MessengerEvent extends Equatable {
  final Map<String, dynamic> params;
  const MessengerEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class OnSelectConversation extends MessengerEvent {
  const OnSelectConversation({required Map<String, dynamic> params})
      : super(params: params);
}

class OnLoadMessage extends MessengerEvent {
  const OnLoadMessage({required Map<String, dynamic> params})
      : super(params: params);
}

class OnLoadConversation extends MessengerEvent {
  const OnLoadConversation({required Map<String, dynamic> params})
      : super(params: params);
}

class OnAcceptConversation extends MessengerEvent {
  const OnAcceptConversation({required Map<String, dynamic> params})
      : super(params: params);
}

class OnSendMessage extends MessengerEvent {
  const OnSendMessage({required Map<String, dynamic> params})
      : super(params: params);
}