part of 'service_bloc.dart';

class ServiceState extends Equatable {
  final List<ServiceDetailModel> services;
  final BlocState serviceState;
  final int currentPage;
  final int maxPage;

  const ServiceState({
    this.services = const [],
    this.serviceState = BlocState.init,
    this.currentPage = 1,
    this.maxPage = 1,
  });
  ServiceState copyWith({
    List<ServiceDetailModel>? services,
    BlocState? serviceState,
    int? currentPage,
    int? maxPage,
  }) {
    return ServiceState(
      services: services ?? this.services,
      serviceState: serviceState ?? this.serviceState,
      currentPage: currentPage ?? this.currentPage,
      maxPage: maxPage ?? this.maxPage,
    );
  }

  @override
  List<Object> get props => [
        services,
        serviceState,
        currentPage,
        maxPage,
      ];
}
