part of 'dish_bloc.dart';

class DishState extends Equatable {
  final List<DishDetailModel> dishes;
  final BlocState dishState;
  final List<DishTypeModel> dishTypes;
  final BlocState dishTypeState;

  const DishState({
    this.dishes = const [],
    this.dishState = BlocState.init,
    this.dishTypes = const [],
    this.dishTypeState = BlocState.init,
  });
  DishState copyWith({
    List<DishDetailModel>? dishes,
    BlocState? dishState,
    List<DishTypeModel>? dishTypes,
    BlocState? dishTypeState,
  }) {
    return DishState(
      dishes: dishes ?? this.dishes,
      dishState: dishState ?? this.dishState,
      dishTypes: dishTypes ?? this.dishTypes,
      dishTypeState: dishTypeState ?? this.dishTypeState,
    );
  }

  @override
  List<Object> get props => [
        dishes,
        dishState,
        dishTypes,
        dishTypeState,
      ];
}
