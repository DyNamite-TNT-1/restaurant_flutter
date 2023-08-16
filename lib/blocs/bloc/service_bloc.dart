import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/service.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc(ServiceState state) : super(state) {
    on<OnLoadService>(_onLoadServiceList);
    on<OnUpdateState>(_onUpdateState);
  }
  Future<void> _onLoadServiceList(OnLoadService event, Emitter emit) async {
    List<ServiceDetailModel> services =
        event.params.containsKey("services") ? event.params["services"] : [];
    BlocState loading = event.params.containsKey("serviceState")
        ? event.params["serviceState"]
        : BlocState.init;
   
    BlocState status;
    if (loading == BlocState.loading) {
      status = BlocState.loading;
    } else {
      status = (services.isEmpty) ? BlocState.noData : BlocState.loadCompleted;
    }
    emit(
      state.copyWith(
        services: services,
        serviceState: status,
      ),
    );
  }


  Future<void> _onUpdateState(OnUpdateState event, Emitter emit) async {
    BlocState serviceState = event.params.containsKey('serviceState')
        ? event.params['serviceState']
        : state.serviceState;
    emit(state.copyWith(
      serviceState: serviceState,
    ));
  }
}
