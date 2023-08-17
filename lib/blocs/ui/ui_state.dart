part of 'ui_bloc.dart';

class UiState extends Equatable {
  final List<DishDetailModel> dishes;
  final BlocState dishState;
  final List<DishDetailModel> drinks;
  final BlocState drinkState;
  final List<ServiceDetailModel> services;
  final BlocState serviceState;
  final TableTypeDetailModel? selectedTableType;
  final BlocState tableTypeState;

  const UiState({
    this.dishes = const [],
    this.dishState = BlocState.init,
    this.drinks = const [],
    this.drinkState = BlocState.init,
    this.services = const [],
    this.serviceState = BlocState.init,
    this.selectedTableType,
    this.tableTypeState = BlocState.init,
  });

  bool canMakeReservation() {
    if (dishes.isEmpty) {
      return false;
    }
    return true;
  }

  UiState copyWith(
      {List<DishDetailModel>? dishes,
      BlocState? dishState,
      List<DishDetailModel>? drinks,
      BlocState? drinkState,
      List<ServiceDetailModel>? services,
      BlocState? serviceState,
      TableTypeDetailModel? selectedTableType,
      BlocState? tableTypeState}) {
    return UiState(
      dishes: dishes ?? this.dishes,
      dishState: dishState ?? this.dishState,
      drinks: drinks ?? this.drinks,
      drinkState: drinkState ?? this.drinkState,
      services: services ?? this.services,
      serviceState: serviceState ?? this.serviceState,
      selectedTableType: selectedTableType ?? this.selectedTableType,
      tableTypeState: tableTypeState ?? this.tableTypeState,
    );
  }

  @override
  List<Object> get props => [
        dishes,
        dishState,
        drinks,
        drinkState,
        services,
        serviceState,
        tableTypeState,
      ];
}
