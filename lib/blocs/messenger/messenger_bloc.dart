import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/enum/bloc.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';

import '../../models/client/client_message.dart';

part 'messenger_event.dart';
part 'messenger_state.dart';

class MessengerBloc extends Bloc<MessengerEvent, MessengerState> {
  final String tagRequestDetailConversation =
      Api.buildIncreaseTagRequestWithID("messengerBloc_detailConversation");

  MessengerBloc(MessengerState state) : super(state) {
    on<OnLoadConversation>(_onLoadConversation);
  }

  Future<void> _onLoadConversation(
      OnLoadConversation event, Emitter emit) async {
    if (!isClosed) {
      emit(state.copyWith(
        conversationState: BlocState.loading,
      ));
      ResultModel result = await Api.requestDetailConversation(
        conversationId: 1,
        tagRequest: tagRequestDetailConversation,
      );
      if (result.isSuccess) {
        ClientConversationModel conversationModel =
            ClientConversationModel.fromJson(result.data);
        emit(state.copyWith(
          conversation: conversationModel,
          conversationState: conversationModel.messages.isEmpty
              ? BlocState.noData
              : BlocState.loadCompleted,
        ));
      } else {
        emit(state.copyWith(
          conversationState: BlocState.loadFailed,
        ));
      }
    }
  }

  @override
  Future<void> close() async {
    super.close();
    Api.cancelRequest(tag: tagRequestDetailConversation);
  }
}
