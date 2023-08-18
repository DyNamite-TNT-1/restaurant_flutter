import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/reservation.dart';

part 'reservation_detail_event.dart';
part 'reservation_detail_state.dart';

class ReservationDetailBloc
    extends Bloc<ReservationDetailEvent, ReservationDetailState> {
  ReservationDetailBloc(ReservationDetailState state) : super(state) {
    on<OnLoadReservation>(_onLoadReservation);
    on<OnUpdateState>(_onUpdateState);
  }

  Future<void> _onLoadReservation(OnLoadReservation event, Emitter emit) async {
    final ReservationDetailModel? reservationDetailModel =
        event.params.containsKey("reservation")
            ? event.params["reservation"]
            : null;
    BlocState status = reservationDetailModel == null ? BlocState.noData : BlocState.loadCompleted;
    
    emit(
      state.copyWith(
        reservationDetailModel: reservationDetailModel,
        reservationState: status,
      ),
    );
  }

  Future<void> _onUpdateState(OnUpdateState event, Emitter emit) async {
    BlocState reservationState = event.params.containsKey('reservationState')
        ? event.params['reservationState']
        : state.reservationState;

    emit(state.copyWith(
      reservationState: reservationState,
    ));
  }
}
