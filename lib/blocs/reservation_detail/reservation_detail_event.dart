part of 'reservation_detail_bloc.dart';

abstract class ReservationDetailEvent extends Equatable {
final Map<String, dynamic> params;
  const ReservationDetailEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class OnLoadReservation extends ReservationDetailEvent {
    const OnLoadReservation({required Map<String, dynamic> params})
      : super(params: params);
}

class OnUpdateState extends ReservationDetailEvent {
  const OnUpdateState({required Map<String, dynamic> params})
      : super(params: params);
}
