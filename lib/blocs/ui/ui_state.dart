part of 'ui_bloc.dart';

class UiState extends Equatable {
  final List<DishDetailModel> dishes;
  final BlocState dishState;
  final List<DishDetailModel> drinks;
  final BlocState drinkState;
  final List<ServiceDetailModel> services;
  final BlocState serviceState;
  final TableTypeDetailModel? selectedTableType;

  const UiState({
    this.dishes = const [],
    this.dishState = BlocState.init,
    this.drinks = const [],
    this.drinkState = BlocState.init,
    this.services = const [],
    this.serviceState = BlocState.init,
    this.selectedTableType,
  });

  UiState copyWith({
    List<DishDetailModel>? dishes,
    BlocState? dishState,
    List<DishDetailModel>? drinks,
    BlocState? drinkState,
    List<ServiceDetailModel>? services,
    BlocState? serviceState,
    TableTypeDetailModel?  selectedTableType,
  }) {
    return UiState(
      dishes: dishes ?? this.dishes,
      dishState: dishState ?? this.dishState,
      drinks: drinks ?? this.drinks,
      drinkState: drinkState ?? this.drinkState,
      services: services ?? this.services,
      serviceState: serviceState ?? this.serviceState,
      selectedTableType: selectedTableType ?? this.selectedTableType,
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
      ];
}
