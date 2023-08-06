import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/enum/bloc.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/dish_type.dart';

part 'dish_state.dart';
part 'dish_event.dart';

class DishBloc extends Bloc<DishEvent, DishState> {
  DishBloc(DishState state) : super(state) {
    on<OnLoadDish>(_onLoadDishList);
    on<OnLoadDishType>(_onLoadDishTypeList);
    on<OnUpdateState>(_onUpdateState);
  }
  Future<void> _onLoadDishList(OnLoadDish event, Emitter emit) async {
    List<DishDetailModel> dishes =
        event.params.containsKey("dishes") ? event.params["dishes"] : [];
    BlocState loading = event.params.containsKey("state")
        ? event.params["state"]
        : BlocState.init;
    BlocState status;
    if (loading == BlocState.loading) {
      status = BlocState.loading;
    } else {
      status = (dishes.isEmpty) ? BlocState.noData : BlocState.loadCompleted;
    }
    emit(
      state.copyWith(
        dishes: dishes,
        dishState: status,
      ),
    );
  }

  Future<void> _onLoadDishTypeList(OnLoadDishType event, Emitter emit) async {
    List<DishTypeModel> dishTypes =
        event.params.containsKey("dishTypes") ? event.params["dishTypes"] : [];
    dishTypes = [
      DishTypeModel(dishTypeId: 0, type: "Tất cả", isDrinkType: false),
      ...dishTypes
    ];
    BlocState loading = event.params.containsKey("state")
        ? event.params["state"]
        : BlocState.init;
    BlocState status;
    if (loading == BlocState.loading) {
      status = BlocState.loading;
    } else {
      status = (dishTypes.isEmpty) ? BlocState.noData : BlocState.loadCompleted;
    }
    emit(
      state.copyWith(
        dishTypes: dishTypes,
        dishTypeState: status,
      ),
    );
  }

  Future<void> _onUpdateState(OnUpdateState event, Emitter emit) async {
    BlocState dishState = event.params.containsKey('dishState')
        ? event.params['dishState']
        : state.dishState;
    BlocState dishTypeState = event.params.containsKey('dishTypeState')
        ? event.params['dishTypeState']
        : state.dishTypeState;
    emit(state.copyWith(
      dishState: dishState,
      dishTypeState: dishTypeState,
    ));
  }
}
