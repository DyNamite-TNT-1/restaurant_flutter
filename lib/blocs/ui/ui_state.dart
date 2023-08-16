part of 'ui_bloc.dart';

class UiState extends Equatable {
  final List<DishDetailModel> dishes;
  final BlocState dishState;
  final List<ServiceDetailModel> services;
  final BlocState serviceState;

  const UiState({
    this.dishes = const [],
    this.dishState = BlocState.init,
    this.services = const [],
    this.serviceState = BlocState.init,
  });

  UiState copyWith({
    List<DishDetailModel>? dishes,
    BlocState? dishState,
    List<ServiceDetailModel>? services,
    BlocState? serviceState,
  }) {
    return UiState(
      dishes: dishes ?? this.dishes,
      dishState: dishState ?? this.dishState,
      services: services ?? this.services,
      serviceState: serviceState ?? this.serviceState,
    );
  }

  @override
  List<Object> get props => [
        dishes,
        dishState,
        services,
        serviceState,
      ];
}
