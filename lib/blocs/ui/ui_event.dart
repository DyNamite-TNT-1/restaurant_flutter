part of 'ui_bloc.dart';

abstract class UiEvent extends Equatable {
  final Map<String, dynamic> params;

  const UiEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class OnAddDish extends UiEvent {
const OnAddDish({required Map<String, dynamic> params})
      : super(params: params);
}

class OnSubtractDish extends UiEvent {
  const OnSubtractDish({required Map<String, dynamic> params})
      : super(params: params);
}

class OnChangeOrderDish extends UiEvent {
  const OnChangeOrderDish({required Map<String, dynamic> params})
      : super(params: params);
}

class OnAddDrink extends UiEvent {
  const OnAddDrink({required Map<String, dynamic> params})
      : super(params: params);
}

class OnSubtractDrink extends UiEvent {
  const OnSubtractDrink({required Map<String, dynamic> params})
      : super(params: params);
}

class OnAddService extends UiEvent {
   const OnAddService({required Map<String, dynamic> params})
      : super(params: params);
}

class OnSubtractService extends UiEvent {
  const OnSubtractService({required Map<String, dynamic> params})
      : super(params: params);
}

class OnChangeTableType extends UiEvent {
  const OnChangeTableType({required Map<String, dynamic> params})
      : super(params: params);
}

class OnUpdateState extends UiEvent {
  const OnUpdateState({required Map<String, dynamic> params})
      : super(params: params);
}

class OnReservationSuccess extends  UiEvent {
  const OnReservationSuccess({required Map<String, dynamic> params})
      : super(params: params);
}