part of 'drink_bloc.dart';

abstract class DrinkEvent extends Equatable {
  final Map<String, dynamic> params;
  const DrinkEvent({required this.params});
  @override
  List<Object> get props => [params];
}

class OnLoadDrink extends DrinkEvent {
  const OnLoadDrink({required Map<String, dynamic> params})
      : super(params: params);
}

class OnLoadDrinkType extends DrinkEvent {
  const OnLoadDrinkType({required Map<String, dynamic> params})
      : super(params: params);
}

class OnUpdateState extends DrinkEvent {
  const OnUpdateState({required Map<String, dynamic> params})
      : super(params: params);
}
