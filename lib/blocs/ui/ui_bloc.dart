import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/service.dart';

part 'ui_event.dart';
part 'ui_state.dart';

class UiBloc extends Bloc<UiEvent, UiState> {
  UiBloc(UiState state) : super(state) {
    on<OnAddDish>(_onAddDish);
    on<OnUpdateState>(_onUpdateState);
    on<OnSubtractDish>(_onSubtractDish);
    on<OnChangeOrderDish>(_onChangeOrderDish);
    on<OnLoadService>(_onLoadService);
    on<OnChangeSelectedService>(_onChangeSelectedService);
  }

  Future<void> _onAddDish(OnAddDish event, Emitter emit) async {
    DishDetailModel dish = event.params.containsKey("dish")
        ? event.params["dish"]
        : DishDetailModel();
    if (dish.dishId == 0) {
      return;
    }
    bool isHasSameDish = false;
    for (var element in state.dishes) {
      if (element.dishId == dish.dishId) {
        element.quantity += 1;
        isHasSameDish = true;
        break;
      }
    }
    BlocState status = BlocState.loadCompleted;
    emit(
      state.copyWith(
        dishes: isHasSameDish ? [...state.dishes] : [...state.dishes, dish],
        dishState: status,
      ),
    );
  }

  Future<void> _onSubtractDish(OnSubtractDish event, Emitter emit) async {
    DishDetailModel dish = event.params.containsKey("dish")
        ? event.params["dish"]
        : DishDetailModel();
    for (var element in state.dishes) {
      if (element.dishId == dish.dishId) {
        if (element.quantity > 1) {
          element.quantity -= 1;
        } else {
          state.dishes.remove(element);
        }
        break;
      }
    }
    BlocState status = BlocState.loadCompleted;
    emit(
      state.copyWith(
        dishes: [...state.dishes],
        dishState: status,
      ),
    );
  }

  Future<void> _onChangeOrderDish(OnChangeOrderDish event, Emitter emit) async {
    int newIndex =
        event.params.containsKey("newIndex") ? event.params["newIndex"] : 0;
    int oldIndex =
        event.params.containsKey("oldIndex") ? event.params["oldIndex"] : 0;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final dish = state.dishes.removeAt(oldIndex);
    state.dishes.insert(newIndex, dish);
    BlocState status = BlocState.loadCompleted;
    emit(
      state.copyWith(
        dishes: [...state.dishes],
        dishState: status,
      ),
    );
  }

  Future<void> _onLoadService(OnLoadService event, Emitter emit) async {
    List<ServiceDetailModel> services =
        event.params.containsKey("services") ? event.params["services"] : [];
    BlocState loading = event.params.containsKey("serviceState")
        ? event.params["serviceState"]
        : BlocState.init;
    BlocState status;

    if (loading == BlocState.loading) {
      status = BlocState.loading;
    } else {
      status = (services.isEmpty) ? BlocState.noData : BlocState.loadCompleted;
    }

    emit(
      state.copyWith(
        services: services,
        serviceState: status,
      ),
    );
  }

  Future<void> _onChangeSelectedService(
      OnChangeSelectedService event, Emitter emit) async {
    bool isSelected = event.params.containsKey("isSelected")
        ? event.params["isSelected"]
        : false;
    ServiceDetailModel service =
        event.params.containsKey("service") ? event.params["service"] : [];

    for (var element in state.services) {
      if (element.serviceId == service.serviceId) {
        element.isSelected = isSelected;
        break;
      }
    }
    BlocState status = BlocState.loadCompleted;
    emit(
      state.copyWith(
        dishes: [...state.dishes],
        dishState: status,
      ),
    );
  }

  Future<void> _onUpdateState(OnUpdateState event, Emitter emit) async {
    BlocState dishState = event.params.containsKey('dishState')
        ? event.params['dishState']
        : state.dishState;

    BlocState serviceState = event.params.containsKey('serviceState')
        ? event.params['serviceState']
        : state.serviceState;

    emit(state.copyWith(
      dishState: dishState,
      serviceState: serviceState,
    ));
  }
}
