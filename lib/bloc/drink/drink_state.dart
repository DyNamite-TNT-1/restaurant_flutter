part of 'drink_bloc.dart';

class DrinkState extends Equatable {
  final List<DishDetailModel> drinks;
  final BlocState drinkState;
  final List<DishTypeModel> drinkTypes;
  final BlocState drinkTypeState;
  final int currentPage;
  final int maxPage;
  const DrinkState({
    this.drinks = const [],
    this.drinkState = BlocState.init,
    this.drinkTypes = const [],
    this.drinkTypeState = BlocState.init,
    this.currentPage = 1,
    this.maxPage = 1,
  });
  DrinkState copyWith({
    List<DishDetailModel>? drinks,
    BlocState? drinkState,
    List<DishTypeModel>? drinkTypes,
    BlocState? drinkTypeState,
    int? currentPage,
    int? maxPage,
  }) {
    return DrinkState(
      drinks: drinks ?? this.drinks,
      drinkState: drinkState ?? this.drinkState,
      drinkTypes: drinkTypes ?? this.drinkTypes,
      drinkTypeState: drinkTypeState ?? this.drinkTypeState,
      currentPage: currentPage ?? this.currentPage,
      maxPage: maxPage ?? this.maxPage,
    );
  }

  @override
  List<Object> get props => [
        drinks,
        drinkState,
        drinkTypes,
        drinkTypeState,
        currentPage,
        maxPage,
      ];
}
