import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/enum/bloc.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/dish_type.dart';

part 'drink_event.dart';
part 'drink_state.dart';

class DrinkBloc extends Bloc<DrinkEvent, DrinkState> {
  DrinkBloc(DrinkState state) : super(state) {
    on<OnLoadDrink>(_onLoadDrinkList);
    on<OnLoadDrinkType>(_onLoadDrinkTypeList);
    on<OnUpdateState>(_onUpdateState);
  }
  Future<void> _onLoadDrinkList(OnLoadDrink event, Emitter emit) async {
    List<DishDetailModel> drinks =
        event.params.containsKey("drinks") ? event.params["drinks"] : [];
    BlocState loading = event.params.containsKey("state")
        ? event.params["state"]
        : BlocState.init;
    BlocState status;
    if (loading == BlocState.loading) {
      status = BlocState.loading;
    } else {
      status = (drinks.isEmpty) ? BlocState.noData : BlocState.loadCompleted;
    }
    emit(
      state.copyWith(
        drinks: drinks,
        drinkState: status,
      ),
    );
  }

  Future<void> _onLoadDrinkTypeList(OnLoadDrinkType event, Emitter emit) async {
    List<DishTypeModel> drinkTypes = event.params.containsKey("drinkTypes")
        ? event.params["drinkTypes"]
        : [];
    drinkTypes = [
      DishTypeModel(dishTypeId: 0, type: "Tất cả", isDrinkType: false),
      ...drinkTypes
    ];
    BlocState loading = event.params.containsKey("state")
        ? event.params["state"]
        : BlocState.init;
    BlocState status;
    if (loading == BlocState.loading) {
      status = BlocState.loading;
    } else {
      status =
          (drinkTypes.isEmpty) ? BlocState.noData : BlocState.loadCompleted;
    }
    emit(
      state.copyWith(
        drinkTypes: drinkTypes,
        drinkTypeState: status,
      ),
    );
  }

  Future<void> _onUpdateState(OnUpdateState event, Emitter emit) async {
    BlocState drinkState = event.params.containsKey('drinkState')
        ? event.params['drinkState']
        : state.drinkState;
    BlocState drinkTypeState = event.params.containsKey('drinkTypeState')
        ? event.params['drinkTypeState']
        : state.drinkTypeState;
    emit(state.copyWith(
      drinkState: drinkState,
      drinkTypeState: drinkTypeState,
    ));
  }
}
