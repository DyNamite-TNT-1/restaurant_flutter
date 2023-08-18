import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/reservation.dart';

part 'reservation_event.dart';
part 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  ReservationBloc(ReservationState state) : super(state) {
    on<OnLoadReservationList>(_onLoadReservationList);
    on<OnUpdateState>(_onUpdateState);
  }

  Future<void> _onLoadReservationList(
      OnLoadReservationList event, Emitter emit) async {
    List<ReservationDetailModel> reservations =
        event.params.containsKey("reservations")
            ? event.params["reservations"]
            : [];
    BlocState loading = event.params.containsKey("reservationState")
        ? event.params["reservationState"]
        : BlocState.init;
    int currentPage = event.params.containsKey("currentPage")
        ? event.params["currentPage"]
        : state.currentPage;
    int maxPage = event.params.containsKey("maxPage")
        ? event.params["maxPage"]
        : state.maxPage;
    BlocState status;
    if (loading == BlocState.loading) {
      status = BlocState.loading;
    } else {
      status =
          (reservations.isEmpty) ? BlocState.noData : BlocState.loadCompleted;
    }
    emit(
      state.copyWith(
        reservations: reservations,
        reservationState: status,
        currentPage: currentPage,
        maxPage: maxPage,
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
