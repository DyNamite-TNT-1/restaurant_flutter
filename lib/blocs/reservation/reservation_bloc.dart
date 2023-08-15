import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/table.dart';

part 'reservation_event.dart';
part 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  ReservationBloc(ReservationState state) : super(state) {
    on<OnLoadTable>(_onLoadTableList);
    // on<OnLoadTableType>(_onLoadTableTypeList);
    on<OnUpdateState>(_onUpdateState);
  }

  Future<void> _onLoadTableList(OnLoadTable event, Emitter emit) async {
    List<TableDetailModel> tables =
        event.params.containsKey("tables") ? event.params["tables"] : [];
    BlocState loading = event.params.containsKey("tableState")
        ? event.params["tableState"]
        : BlocState.init;
    BlocState status;
    if (loading == BlocState.loading) {
      status = BlocState.loading;
    } else {
      status = (tables.isEmpty) ? BlocState.noData : BlocState.loadCompleted;
    }
    emit(
      state.copyWith(
        tables: tables,
        tableState: status,
      ),
    );
  }

  // Future<void> _onLoadDrinkTypeList(OnLoadDrinkType event, Emitter emit) async {
  //   List<DishTypeModel> drinkTypes = event.params.containsKey("drinkTypes")
  //       ? event.params["drinkTypes"]
  //       : [];
  //   drinkTypes = [
  //     DishTypeModel(dishTypeId: 0, type: "Tất cả", isDrinkType: false),
  //     ...drinkTypes
  //   ];
  //   BlocState loading = event.params.containsKey("state")
  //       ? event.params["state"]
  //       : BlocState.init;
  //   BlocState status;
  //   if (loading == BlocState.loading) {
  //     status = BlocState.loading;
  //   } else {
  //     status =
  //         (drinkTypes.isEmpty) ? BlocState.noData : BlocState.loadCompleted;
  //   }
  //   emit(
  //     state.copyWith(
  //       drinkTypes: drinkTypes,
  //       drinkTypeState: status,
  //     ),
  //   );
  // }

  Future<void> _onUpdateState(OnUpdateState event, Emitter emit) async {
    BlocState tableState = event.params.containsKey('tableState')
        ? event.params['tableState']
        : state.tableState;
    // BlocState drinkTypeState = event.params.containsKey('drinkTypeState')
    //     ? event.params['drinkTypeState']
    //     : state.drinkTypeState;
    emit(state.copyWith(
      tableState: tableState,
      // drinkTypeState: drinkTypeState,
    ));
  }
}
