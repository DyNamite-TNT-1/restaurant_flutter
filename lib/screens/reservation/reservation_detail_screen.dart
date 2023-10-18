import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/reservation_detail/reservation_detail_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/models/service/reservation.dart';
import 'package:restaurant_flutter/screens/reservation/widget/dish_item.dart';
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
  bool isOpenMenu = true;
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
            body: isShowData
                ? Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: kPadding10,
                      horizontal: kDefaultPadding,
                    ),
                    padding: EdgeInsets.all(kPadding10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kCornerMedium),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopBar(context),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: kPadding10),
                          child: Text(
                            "Mã đặt bàn: #${state.reservationDetailModel!.reservationId}",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: isOpenMenu
                                    ? (40 +
                                        32.0 *
                                            state.reservationDetailModel!.menus
                                                .length)
                                    : 40,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(kCornerSmall),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: kPadding10 / 2),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: kPadding10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Danh sách món ăn:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isOpenMenu = !isOpenMenu;
                                                });
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Icon(isOpenMenu
                                                  ? Icons.arrow_drop_down
                                                  : Icons.arrow_right),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isOpenMenu)
                                      Divider(
                                        color: Colors.black,
                                        indent: kPadding10,
                                        endIndent: kPadding10,
                                      ),
                                    if (isOpenMenu)
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: state
                                              .reservationDetailModel!
                                              .menus
                                              .length,
                                          itemBuilder: (context, index) {
                                            return ReservationDetailDishItem(
                                              item: state
                                                  .reservationDetailModel!
                                                  .menus[index],
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: kDefaultPadding,
                            ),
                            Expanded(child: _buildColumnRight(context, state)),
                          ],
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        },
      ),
    );
  }

  Row _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(kCornerSmall),
            onTap: () {
              context.pop();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kCornerSmall),
                border: Border.all(),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.arrow_back,
                    size: 20,
                  ),
                  // Text("Làm mới"),
                ],
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(kCornerSmall),
            onTap: () {
              _requestDetailReservation();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kCornerSmall),
                border: Border.all(),
              ),
              child: Row(
                children: const [
                  Icon(Icons.refresh),
                  Text("Làm mới"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumnRight(BuildContext context, ReservationDetailState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Phí trả trước",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              child: Text(
                state.reservationDetailModel!.preFeeStr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "Trạng thái",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: kPadding10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kCornerSmall),
                  color: state.reservationDetailModel!.statusColor,
                ),
                child: Center(
                  child: Text(
                    state.reservationDetailModel!.statusStr,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (UserRepository.userModel.isClient)
          Tooltip(
            message: "Thanh toán phí trả trước",
            child: AppButton(
              "Đặt cọc",
              disabled: state.reservationDetailModel!.status != -2,
              onPressed: () {
                js.context.callMethod('open', [
                  'http://localhost:3005/vnpay/create_payment_url?amount=${state.reservationDetailModel!.preFee}&id_order=${state.reservationDetailModel!.reservationId}'
                ]);
              },
            ),
          ),
      ],
    );
  }
}
