import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/reservation_detail/reservation_detail_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/models/service/reservation.dart';
import 'package:restaurant_flutter/screens/reservation/widget/menu_row_item.dart';
import 'package:restaurant_flutter/screens/reservation/widget/service_row_item.dart';
import 'package:restaurant_flutter/utils/utils.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ReservationDetailScreen extends StatefulWidget {
  const ReservationDetailScreen({
    super.key,
    required this.id,
    this.backToParent,
  });
  final int id;
  final Function? backToParent;

  @override
  State<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  final ReservationDetailBloc _reservationDetailBloc =
      ReservationDetailBloc(ReservationDetailState());
  String tagRequestReservation = "";
  String tagCancelReservation = "";
  String tagChangeSchedule = "";
  bool isOpenDishList = true;
  bool isOpenDrinkList = true;
  bool isOpenServiceList = true;

  @override
  void initState() {
    super.initState();
    _requestDetailReservation();
  }

  @override
  void dispose() {
    super.dispose();
    Api.cancelRequest(tag: tagRequestReservation);
    Api.cancelRequest(tag: tagCancelReservation);
    Api.cancelRequest(tag: tagChangeSchedule);
  }

  bool get isServiceClosed {
    return !mounted || _reservationDetailBloc.isClosed;
  }

  Future<void> openUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _requestDetailReservation() async {
    if (!isServiceClosed) {
      _reservationDetailBloc.add(
        OnUpdateState(
          params: const {"reservationState": BlocState.loading},
        ),
      );
      Api.cancelRequest(tag: tagRequestReservation);
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
      } else {
        _reservationDetailBloc.add(
          OnUpdateState(
            params: const {"reservationState": BlocState.loadFailed},
          ),
        );
      }
    }
  }

  Future<bool> _changeSchedule(String schedule) async {
    Api.cancelRequest(tag: tagChangeSchedule);
    ResultModel result = await Api.requestChangeScheduleReservation(
      reservationId: widget.id,
      schedule: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(
        DateFormat("yyyy/MM/dd hh:mm")
            .parse(schedule)
            .subtract(Duration(hours: 7)),
      ),
    );
    if (mounted) {
      Fluttertoast.showToast(
        msg: Translate.of(context).translate(result.message),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
        webBgColor: result.isSuccess ? successColorToast : dangerColorToast,
      );
    }
    if (result.isSuccess) {
      _requestDetailReservation();
      return true;
    }
    return false;
  }

  _openEditDialog() {
    TextEditingController scheduleController = TextEditingController();
    FocusNode scheduleNode = FocusNode();
    ReservationDetailState state = _reservationDetailBloc.state;
    scheduleController.text = DateFormat("yyyy/MM/dd HH:mm").format(state
        .reservationDetailModel!.schedule
        .toDateTime()
        .add(Duration(hours: 7)));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ct) {
        return AppDialogInput(
          title: Translate.of(context).translate("change_schedule"),
          buttonDoneTitle: Translate.of(context).translate("apply"),
          buttonCancelTitle: Translate.of(context).translate("cancel"),
          onDone: () async {
            String errorText = "";
            if (scheduleController.text.trim().isEmpty) {
              errorText =
                  Translate.of(context).translate("VALIDATE_INPUT_EMPTY");
            }
            if (errorText.isNotEmpty) {
              Fluttertoast.showToast(
                msg: errorText,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: primaryColor,
                textColor: Colors.white,
                fontSize: 16.0,
                webBgColor: dangerColorToast,
              );
            } else {
              bool canPop = await _changeSchedule(scheduleController.text);
              if (canPop && mounted) {
                context.pop();
              }
            }
          },
          onCancel: () {
            context.pop();
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppInput2(
                    name: "schedule",
                    keyboardType: TextInputType.name,
                    controller: scheduleController,
                    placeHolder:
                        Translate.of(context).translate("yyyy/MM/dd HH:mm"),
                    focusNode: scheduleNode,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Container _buildDishServiceList(
      ReservationDetailState state, BuildContext context) {
    double heightOfDishList = isOpenDishList
        ? (40 + 28.0 * state.reservationDetailModel!.dishes.length)
        : 40;
    double heightOfDrinkList = isOpenDrinkList
        ? (40 + 28.0 * state.reservationDetailModel!.drinks.length)
        : 40;
    double heightOfServiceList = isOpenServiceList
        ? (40 + 28.0 * state.reservationDetailModel!.services.length)
        : 40;
    return Container(
      height: 30 + heightOfDishList + heightOfDrinkList + heightOfServiceList,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCornerSmall),
        border: Border.all(color: Colors.black),
        color: primaryColor.withOpacity(0.3),
      ),
      child: Column(
        children: [
          _buildTopList(context),
          SizedBox(
            height: heightOfDishList,
            child: Column(
              children: [
                _buildTopEachList(context,
                    title: "Danh sách món ăn",
                    count: state.reservationDetailModel!.dishes.length,
                    openList: isOpenDishList, onClickOpen: () {
                  setState(() {
                    isOpenDishList = !isOpenDishList;
                  });
                }),
                if (isOpenDishList &&
                    state.reservationDetailModel!.dishes.isNotEmpty)
                  Divider(
                    color: Colors.black,
                    indent: kPadding10,
                    endIndent: kPadding10,
                  ),
                if (isOpenDishList &&
                    state.reservationDetailModel!.dishes.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.reservationDetailModel!.dishes.length,
                      itemBuilder: (context, index) {
                        return MenuRowItem(
                          item: state.reservationDetailModel!.dishes[index],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: heightOfDrinkList,
            child: Column(
              children: [
                _buildTopEachList(context,
                    title: "Danh sách đồ uống",
                    count: state.reservationDetailModel!.drinks.length,
                    openList: isOpenDrinkList, onClickOpen: () {
                  setState(() {
                    isOpenDrinkList = !isOpenDrinkList;
                  });
                }),
                if (isOpenDrinkList &&
                    state.reservationDetailModel!.drinks.isNotEmpty)
                  Divider(
                    color: Colors.black,
                    indent: kPadding10,
                    endIndent: kPadding10,
                  ),
                if (isOpenDrinkList &&
                    state.reservationDetailModel!.drinks.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.reservationDetailModel!.drinks.length,
                      itemBuilder: (context, index) {
                        return MenuRowItem(
                          item: state.reservationDetailModel!.drinks[index],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: heightOfServiceList,
            child: Column(
              children: [
                _buildTopEachList(context,
                    title: "Danh sách dịch vụ",
                    count: state.reservationDetailModel!.services.length,
                    openList: isOpenServiceList, onClickOpen: () {
                  setState(() {
                    isOpenServiceList = !isOpenServiceList;
                  });
                }),
                if (isOpenServiceList &&
                    state.reservationDetailModel!.services.isNotEmpty)
                  Divider(
                    color: Colors.black,
                    indent: kPadding10,
                    endIndent: kPadding10,
                  ),
                if (isOpenServiceList &&
                    state.reservationDetailModel!.services.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.reservationDetailModel!.services.length,
                      itemBuilder: (context, index) {
                        return ServiceRowItem(
                          item: state.reservationDetailModel!.services[index],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTopList(
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.only(top: kPadding10 / 2),
      margin: EdgeInsets.symmetric(horizontal: kPadding10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Số lượng",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 100,
            child: Text(
              "${Translate.of(context).translate("price")}(VNĐ)",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTopEachList(BuildContext context,
      {required String title,
      required bool openList,
      required int count,
      required Function onClickOpen}) {
    return Container(
      padding: EdgeInsets.only(top: kPadding10 / 2),
      margin: EdgeInsets.symmetric(horizontal: kPadding10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 100,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  onClickOpen();
                },
                borderRadius: BorderRadius.circular(50),
                child:
                    Icon(openList ? Icons.arrow_drop_down : Icons.arrow_right),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfoReservation(
      ReservationDetailState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntrinsicWidth(
            child: Column(
              children: [
                Text(
                  "Mã đặt bàn: #${state.reservationDetailModel!.reservationId}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 24,
                      ),
                ),
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kCornerSmall),
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                _openEditDialog();
              },
              icon: Icon(
                Icons.edit,
                size: 20,
              ),
            ),
          )
        ],
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
              if (widget.backToParent != null) {
                widget.backToParent!();
              }
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
                children: [
                  Icon(Icons.refresh),
                  Text(Translate.of(context).translate("refresh")),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRowInfo(BuildContext context,
      {required String leftTag, required String rightValue}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            leftTag,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
        SizedBox(
          width: kDefaultPadding,
        ),
        Expanded(
          child: Text(
            rightValue,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildColumnRight(BuildContext context, ReservationDetailState state) {
    return Column(
      children: [
        _buildRowInfo(
          context,
          leftTag: "Người đặt:",
          rightValue: state.reservationDetailModel!.userModel!.userName,
        ),
        SizedBox(
          height: kPadding10,
        ),
        _buildRowInfo(
          context,
          leftTag: "Số khách:",
          rightValue: state.reservationDetailModel!.countGuest.toString(),
        ),
        SizedBox(
          height: kPadding10,
        ),
        _buildRowInfo(
          context,
          leftTag: "Thời gian diễn ra:",
          rightValue: DateFormat("dd/MM/yyyy HH:mm").format(state
              .reservationDetailModel!.schedule
              .toDateTime()
              .add(Duration(hours: 7))),
        ),
        SizedBox(
          height: kPadding10,
        ),
        _buildRowInfo(
          context,
          leftTag: "Ngày tạo yêu cầu:",
          rightValue: DateFormat("dd/MM/yyyy HH:mm").format(state
              .reservationDetailModel!.createAt
              .toDateTime()
              .add(Duration(hours: 7))),
        ),
        SizedBox(
          height: kPadding10,
        ),
        _buildRowInfo(context,
            leftTag: "Phí trả trước:",
            rightValue: "${state.reservationDetailModel!.preFeeStr} VNĐ"),
        SizedBox(
          height: kPadding10,
        ),
        if (state.reservationDetailModel!.status == -1)
          Column(
            children: [
              _buildRowInfo(context,
                  leftTag: "Phí hoàn trả:",
                  rightValue:
                      "${state.reservationDetailModel!.refundFeeStr} VNĐ"),
              SizedBox(
                height: kPadding10,
              ),
            ],
          ),
        Row(
          children: [
            Expanded(
              child: Text(
                "Trạng thái:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(
              width: kDefaultPadding,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: kPadding10, vertical: kPadding10),
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
        SizedBox(
          height: kPadding10,
        ),
        _buildActionButton(state),
      ],
    );
  }

  Widget _buildActionButton(ReservationDetailState state) {
    bool isClient = UserRepository.userModel.isClient;

    // đặt cọc
    if (isClient) {
      if (state.reservationDetailModel!.status == -2) {
        return Tooltip(
          message: "Thanh toán phí trả trước",
          child: AppButton(
            "Đặt cọc",
            onPressed: () async {
              await openUrl(Uri.parse(
                  "http://${Api.localHost()}/vnpay/create_payment_url?amount=${state.reservationDetailModel!.preFee}&id_order=${state.reservationDetailModel!.reservationId}"));
            },
          ),
        );
      } else if (state.reservationDetailModel!.status == 0 ||
          state.reservationDetailModel!.status == 1) {
        return Tooltip(
          message: "Hủy bàn",
          child: AppButton(
            "Hủy bàn",
            onPressed: _cancelReservation,
          ),
        );
      }
    }

    // hủy bàn
    return SizedBox.shrink();
  }

  Future<void> _cancelReservation() async {
    Api.cancelRequest(tag: tagCancelReservation);
    tagCancelReservation =
        Api.buildIncreaseTagRequestWithID("cancel_reservation");
    ResultModel result = await Api.requestCancelReservation(
      reservationId: widget.id,
    );
    if (mounted) {
      Fluttertoast.showToast(
        msg: Translate.of(context).translate(result.message),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        webBgColor: result.isSuccess ? successColorToast : dangerColorToast,
        webShowClose: true,
      );
    }
    if (result.isSuccess) {
      _requestDetailReservation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _reservationDetailBloc,
      child: BlocBuilder<ReservationDetailBloc, ReservationDetailState>(
        builder: (context, state) {
          return Scaffold(
            body: Container(
              margin: const EdgeInsets.symmetric(
                vertical: kPadding10,
                horizontal: kDefaultPadding,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kCornerMedium),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: kDefaultPadding,
                      right: kDefaultPadding,
                      left: kDefaultPadding,
                    ),
                    child: _buildTopBar(context),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        if (state.reservationDetailModel != null)
                          Container(
                            padding: EdgeInsets.all(kDefaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeaderInfoReservation(state, context),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          _buildDishServiceList(state, context),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: kDefaultPadding,
                                    ),
                                    Expanded(
                                        child:
                                            _buildColumnRight(context, state)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        Visibility(
                          visible: state.reservationState == BlocState.loading,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.circular(kCornerMedium),
                            ),
                            height: double.infinity,
                            width: double.infinity,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              state.reservationState == BlocState.loadFailed,
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.grey.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.circular(kCornerMedium),
                            ),
                            height: double.infinity,
                            width: double.infinity,
                            child: Center(
                              child: NoDataFoundView(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
