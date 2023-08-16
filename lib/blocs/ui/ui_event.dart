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

class OnLoadService extends UiEvent {
   const OnLoadService({required Map<String, dynamic> params})
      : super(params: params);
}

class OnChangeSelectedService extends UiEvent {
  const OnChangeSelectedService({required Map<String, dynamic> params})
      : super(params: params);
}

class OnUpdateState extends UiEvent {
  const OnUpdateState({required Map<String, dynamic> params})
      : super(params: params);
}