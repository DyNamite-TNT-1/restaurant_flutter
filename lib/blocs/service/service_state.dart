part of 'service_bloc.dart';

class ServiceState extends Equatable {
  final List<ServiceDetailModel> services;
  final BlocState serviceState;

  const ServiceState({
    this.services = const [],
    this.serviceState = BlocState.init,
  });
  ServiceState copyWith({
    List<ServiceDetailModel>? services,
    BlocState? serviceState,
  }) {
    return ServiceState(
      services: services ?? this.services,
      serviceState: serviceState ?? this.serviceState,
    );
  }

  @override
  List<Object> get props => [
        services,
        serviceState,
      ];
}
