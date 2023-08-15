part of 'reservation_bloc.dart';

abstract class ReservationEvent extends Equatable {
    final Map<String, dynamic> params;
  const ReservationEvent({required this.params});

  @override
  List<Object> get props => [params];
}
class OnLoadTable extends ReservationEvent {
  const OnLoadTable({required Map<String, dynamic> params})
      : super(params: params);
}

class OnLoadTableType extends ReservationEvent {
  const OnLoadTableType({required Map<String, dynamic> params})
      : super(params: params);
}

class OnUpdateState extends ReservationEvent {
  const OnUpdateState({required Map<String, dynamic> params})
      : super(params: params);
}
