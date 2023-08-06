part of 'drink_bloc.dart';

class DrinkState extends Equatable {
  final List<DishDetailModel> drinks;
  final BlocState drinkState;
  final List<DishTypeModel> drinkTypes;
  final BlocState drinkTypeState;

  const DrinkState({
    this.drinks = const [],
    this.drinkState = BlocState.init,
    this.drinkTypes = const [],
    this.drinkTypeState = BlocState.init,
  });
  DrinkState copyWith({
    List<DishDetailModel>? drinks,
    BlocState? drinkState,
    List<DishTypeModel>? drinkTypes,
    BlocState? drinkTypeState,
  }) {
    return DrinkState(
      drinks: drinks ?? this.drinks,
      drinkState: drinkState ?? this.drinkState,
      drinkTypes: drinkTypes ?? this.drinkTypes,
      drinkTypeState: drinkTypeState ?? this.drinkTypeState,
    );
  }

  @override
  List<Object> get props => [
        drinks,
        drinkState,
        drinkTypes,
        drinkTypeState,
      ];
}
