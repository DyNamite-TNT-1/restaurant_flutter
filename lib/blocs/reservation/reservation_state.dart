part of 'reservation_bloc.dart';

class ReservationState extends Equatable {
  final List<ReservationDetailModel> reservations;
  final BlocState reservationState;
  final int currentPage;
  final int maxPage;

  const ReservationState({
    this.reservations = const [],
    this.reservationState = BlocState.init,
    this.currentPage = 1,
    this.maxPage = 1,
  });

  ReservationState copyWith({
    List<ReservationDetailModel>? reservations,
    BlocState? reservationState,
    int? currentPage,
    int? maxPage,
  }) {
    return ReservationState(
      reservations: reservations ?? this.reservations,
      reservationState: reservationState ?? this.reservationState,
      currentPage: currentPage ?? this.currentPage,
      maxPage: maxPage ?? this.maxPage,
    );
  }

  @override
  List<Object> get props => [
        reservations,
        reservationState,
        currentPage,
        maxPage,
      ];
}
