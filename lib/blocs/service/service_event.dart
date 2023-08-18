part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  final Map<String, dynamic> params;
  const ServiceEvent({required this.params});
  @override
  List<Object> get props => [params];
}

class OnLoadService extends ServiceEvent {
  const OnLoadService({required Map<String, dynamic> params})
      : super(params: params);
}


class OnUpdateState extends ServiceEvent {
  const OnUpdateState({required Map<String, dynamic> params})
      : super(params: params);
}
