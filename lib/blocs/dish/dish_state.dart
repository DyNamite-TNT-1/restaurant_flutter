part of 'dish_bloc.dart';

class DishState extends Equatable {
  final List<DishDetailModel> dishes;
  final BlocState dishState;
  final List<DishTypeModel> dishTypes;
  final BlocState dishTypeState;
  final int currentPage;
  final int maxPage;

  const DishState({
    this.dishes = const [],
    this.dishState = BlocState.init,
    this.dishTypes = const [],
    this.dishTypeState = BlocState.init,
    this.currentPage = 1,
    this.maxPage = 1,
  });
  DishState copyWith({
    List<DishDetailModel>? dishes,
    BlocState? dishState,
    List<DishTypeModel>? dishTypes,
    BlocState? dishTypeState,
    int? currentPage,
    int? maxPage,
  }) {
    return DishState(
      dishes: dishes ?? this.dishes,
      dishState: dishState ?? this.dishState,
      dishTypes: dishTypes ?? this.dishTypes,
      dishTypeState: dishTypeState ?? this.dishTypeState,
      currentPage: currentPage ?? this.currentPage,
      maxPage: maxPage ?? this.maxPage,
    );
  }

  @override
  List<Object> get props => [
        dishes,
        dishState,
        dishTypes,
        dishTypeState,
        currentPage,
        maxPage,
      ];
}
