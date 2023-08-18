part of 'reservation_detail_bloc.dart';

class ReservationDetailState extends Equatable {
  final ReservationDetailModel? reservationDetailModel;
  final BlocState reservationState;

  const ReservationDetailState({
    this.reservationDetailModel,
    this.reservationState = BlocState.init,
  });

  ReservationDetailState copyWith({
   ReservationDetailModel? reservationDetailModel,
    BlocState? reservationState,
  }) {
    return ReservationDetailState(
      reservationDetailModel: reservationDetailModel ?? this.reservationDetailModel,
      reservationState: reservationState ?? this.reservationState,
    );
  }

  @override
  List<Object> get props => [
    reservationState,
  ];
}
