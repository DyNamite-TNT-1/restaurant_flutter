import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/reservation_detail/reservation_detail_bloc.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/models/service/reservation.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';
import 'dart:js' as js;

class ReservationDetailScreen extends StatefulWidget {
  const ReservationDetailScreen({super.key, required this.id});

  final int id;

  @override
  State<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  final ReservationDetailBloc _reservationDetailBloc =
      ReservationDetailBloc(ReservationDetailState());
  String tagRequestReservation = "";
  @override
  void initState() {
    super.initState();
    _requestDetailReservation();
  }

  @override
  void dispose() {
    super.dispose();
    Api.cancelRequest(tag: tagRequestReservation);
  }

  bool get isServiceClosed {
    return !mounted || _reservationDetailBloc.isClosed;
  }

  Future<void> _requestDetailReservation() async {
    if (!isServiceClosed) {
      _reservationDetailBloc.add(
        OnUpdateState(
          params: const {"reservationState": BlocState.loading},
        ),
      );
      tagRequestReservation =
          Api.buildIncreaseTagRequestWithID("reservationDetail");
      ResultModel result = await Api.requestDetailReservation(
        reservationId: widget.id,
      );
      if (!isServiceClosed && result.isSuccess) {
        ReservationDetailModel reservationDetailModel =
            ReservationDetailModel.fromJson(result.data["reservation"]);
        _reservationDetailBloc.add(
          OnLoadReservation(
            params: {
              "reservation": reservationDetailModel,
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _reservationDetailBloc,
      child: BlocBuilder<ReservationDetailBloc, ReservationDetailState>(
        builder: (context, state) {
          bool isShowData = state.reservationState == BlocState.loadCompleted;
          return Scaffold(
            body: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                isShowData
                    ? Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                              "${state.reservationDetailModel!.reservationId}"),
                          Row(
                            children: [
                              Text("Trạng thái"),
                              Text(state.reservationDetailModel!.statusStr),
                            ],
                          ),
                          Tooltip(
                            message: "Thanh toán phí trả trước",
                            child: AppButton("Đặt cọc", onPressed: () {
                              js.context.callMethod('open', [
                                'http://localhost:3005/vnpay/create_payment_url?amount=${state.reservationDetailModel!.preFee}&id_order=${state.reservationDetailModel!.reservationId}'
                              ]);
                            }),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
