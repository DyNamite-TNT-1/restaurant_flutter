import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/service.dart';
import 'package:restaurant_flutter/models/service/table.dart';

part 'ui_event.dart';
part 'ui_state.dart';

class UiBloc extends Bloc<UiEvent, UiState> {
  UiBloc(UiState state) : super(state) {
    on<OnAddDish>(_onAddDish);
    on<OnSubtractDish>(_onSubtractDish);
    on<OnChangeOrderDish>(_onChangeOrderDish);
    on<OnAddDrink>(_onAddDrink);
    on<OnSubtractDrink>(_onSubtractDrink);
    on<OnAddService>(_onAddService);
    on<OnSubtractService>(_onSubtractService);
    on<OnChangeTableType>(_onChangeTableType);
    on<OnUpdateState>(_onUpdateState);
    on<OnReservationSuccess>(_onReservationSuccess);
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

  Future<void> _onAddDrink(OnAddDrink event, Emitter emit) async {
    DishDetailModel drink = event.params.containsKey("drink")
        ? event.params["drink"]
        : DishDetailModel();
    if (drink.dishId == 0) {
      return;
    }
    bool isHasSameDrink = false;
    for (var element in state.drinks) {
      if (element.dishId == drink.dishId) {
        element.quantity += 1;
        isHasSameDrink = true;
        break;
      }
    }
    BlocState status = BlocState.loadCompleted;
    emit(
      state.copyWith(
        drinks: isHasSameDrink ? [...state.drinks] : [...state.drinks, drink],
        drinkState: status,
      ),
    );
  }

  Future<void> _onSubtractDrink(OnSubtractDrink event, Emitter emit) async {
    DishDetailModel drink = event.params.containsKey("drink")
        ? event.params["drink"]
        : DishDetailModel();
    for (var element in state.drinks) {
      if (element.dishId == drink.dishId) {
        if (element.quantity > 1) {
          element.quantity -= 1;
        } else {
          state.drinks.remove(element);
        }
        break;
      }
    }
    BlocState status = BlocState.loadCompleted;
    emit(
      state.copyWith(
        drinks: [...state.drinks],
        drinkState: status,
      ),
    );
  }

  Future<void> _onAddService(OnAddService event, Emitter emit) async {
    ServiceDetailModel service = event.params.containsKey("service")
        ? event.params["service"]
        : DishDetailModel();
    if (service.serviceId == 0) {
      return;
    }
    bool isHasSameService = false;
    for (var element in state.services) {
      if (element.serviceId == service.serviceId) {
        element.quantity += 1;
        isHasSameService = true;
        break;
      }
    }
    BlocState status = BlocState.loadCompleted;
    emit(
      state.copyWith(
        services: isHasSameService
            ? [...state.services]
            : [...state.services, service],
        serviceState: status,
      ),
    );
  }

  Future<void> _onSubtractService(OnSubtractService event, Emitter emit) async {
    ServiceDetailModel service = event.params.containsKey("service")
        ? event.params["service"]
        : ServiceDetailModel();
    for (var element in state.services) {
      if (element.serviceId == service.serviceId) {
        if (element.quantity > 1) {
          element.quantity -= 1;
        } else {
          state.services.remove(element);
        }
        break;
      }
    }
    BlocState status = BlocState.loadCompleted;
    emit(
      state.copyWith(
        services: [...state.services],
        serviceState: status,
      ),
    );
  }

  Future<void> _onChangeTableType(OnChangeTableType event, Emitter emit) async {
    TableTypeDetailModel tableType = event.params.containsKey("tableType")
        ? event.params["tableType"]
        : TableTypeDetailModel();
    if (tableType.tableTypeId == 0) {
      return;
    }
    BlocState status = BlocState.loadCompleted;
    emit(
      state.copyWith(
        selectedTableType: tableType,
        tableTypeState: status,
      ),
    );
  }

  Future<void> _onUpdateState(OnUpdateState event, Emitter emit) async {
    BlocState dishState = event.params.containsKey('dishState')
        ? event.params['dishState']
        : state.dishState;
    BlocState drinkState = event.params.containsKey('drinkState')
        ? event.params['drinkState']
        : state.drinkState;
    BlocState serviceState = event.params.containsKey('serviceState')
        ? event.params['serviceState']
        : state.serviceState;
    BlocState tableTypeState = event.params.containsKey('tableTypeState')
        ? event.params['tableTypeState']
        : state.serviceState;
    emit(state.copyWith(
      dishState: dishState,
      drinkState: drinkState,
      serviceState: serviceState,
      tableTypeState: tableTypeState,
    ));
  }

  Future<void> _onReservationSuccess(
      OnReservationSuccess event, Emitter emit) async {
    emit(state.copyWith(
      dishes: [],
      dishState: BlocState.init,
      drinks: [],
      drinkState: BlocState.init,
      services: [],
      serviceState: BlocState.init,
      // selectedTableType: ,
      tableTypeState: BlocState.init,
    ));
  }
}
