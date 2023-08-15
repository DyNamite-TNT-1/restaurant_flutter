part of 'reservation_bloc.dart';

class ReservationState extends Equatable {
  final List<TableDetailModel> tables;
  final BlocState tableState;
  const ReservationState({
    this.tables = const [],
    this.tableState = BlocState.init,
  });

  ReservationState copyWith({
    List<TableDetailModel>? tables,
    BlocState? tableState,
  }) {
    return ReservationState(
      tables: tables ?? this.tables,
      tableState: tableState ?? this.tableState,
    );
  }

  @override
  List<Object> get props => [
        tables,
        tableState,
      ];
}
