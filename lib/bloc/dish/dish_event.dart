part of 'dish_bloc.dart';

abstract class DishEvent extends Equatable {
  final Map<String, dynamic> params;
  const DishEvent({required this.params});
  @override
  List<Object> get props => [params];
}

class OnLoadDish extends DishEvent {
  const OnLoadDish({required Map<String, dynamic> params})
      : super(params: params);
}

class OnLoadDishType extends DishEvent {
  const OnLoadDishType({required Map<String, dynamic> params})
      : super(params: params);
}

class OnUpdateState extends DishEvent {
  const OnUpdateState({required Map<String, dynamic> params})
      : super(params: params);
}
