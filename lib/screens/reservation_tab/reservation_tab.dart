import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/app_bloc.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/blocs/ui/ui_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/models/service/reservation.dart';
import 'package:restaurant_flutter/models/service/table.dart';
import 'package:restaurant_flutter/screens/authentication/login_screen.dart';
import 'package:restaurant_flutter/screens/reservation_tab/widget/service_item.dart';
import 'package:restaurant_flutter/utils/utils.dart';
import 'package:restaurant_flutter/widgets/app_popup_menu_button.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';
import 'dart:js' as js;
import 'widget/dish_item.dart';
import 'widget/drink_item.dart';

class ReservationTab extends StatefulWidget {
  const ReservationTab({super.key, required this.onTapClose});
  final Function onTapClose;

  @override
  State<ReservationTab> createState() => _ReservationTabState();
}

class _ReservationTabState extends State<ReservationTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController peopleController =
      TextEditingController(text: "2");
  final FocusNode peopleNode = FocusNode();
  DateTime scheduleDate = DateTime.now();
  TimeOfDay scheduleHour = TimeOfDay.now();
  List<TableTypeDetailModel> tableTypes = [];
  final TextEditingController textEditingController = TextEditingController();
  late final _noteNode = FocusNode(
    onKey: (FocusNode node, RawKeyEvent evt) {
      if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
        if (evt is RawKeyDownEvent) {}
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    _requestListTableType();
  }

  Future<void> _requestListTableType() async {
    ResultModel result = await Api.requestTableType();
    if (result.isSuccess) {
      tableTypes = TableTypeDetailModel.parseListItem(result.data);
      if (AppBloc.uiBloc.state.selectedTableType == null &&
          tableTypes.isNotEmpty) {
        AppBloc.uiBloc.add(
          OnChangeTableType(params: {"tableType": tableTypes[0]}),
        );
      }
    }
  }

  Future<void> _requestMakeReservation(BuildContext context) async {
    ResultModel result = await Api.requestCreateReservation(
      dishes: AppBloc.uiBloc.state.dishes,
      drinks: AppBloc.uiBloc.state.drinks,
      services: AppBloc.uiBloc.state.services,
      tableType: AppBloc.uiBloc.state.selectedTableType!,
      countGuest: ParseTypeData.ensureInt(peopleController.text),
      schedule:
          "${DateFormat("yyyy-MM-dd").format(scheduleDate)} ${scheduleHour.hour.toString().padLeft(2, "0")}:${scheduleHour.minute.toString().padLeft(2, "0")}",
      note: textEditingController.text,
    );
    if (result.isSuccess) {
      ReservationDetailModel reservation =
          ReservationDetailModel.fromJson(result.data);
      _openDialogPayment(
        reservation.preFee,
        DateFormat('dd/MM/yyyy HH:mm')
            .format(reservation.deadline.toDateTime()),
        reservation.reservationId,
      );
      // AppBloc.uiBloc.add(OnReservationSuccess(params: const {}));
    } else if (mounted) {
      Fluttertoast.showToast(
        msg: result.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: primaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
        webBgColor: dangerColorToast,
      );
      return;
    }
  }

  void _openDialogPayment(
    int preFee,
    String deadline,
    int reservationId,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AppDialogText(
          buttonDoneTitle: preFee > 0 ? "Thanh toán" : "OK",
          onDone: () {
            if (preFee > 0) {
              js.context.callMethod('open', [
                'http://localhost:3005/vnpay/create_payment_url?amount=$preFee&id_order=$reservationId'
              ]);
            }
            Navigator.pop(context);
          },
          onCancel: () {
            Navigator.pop(context);
          },
          child: Column(
            children: [
              Text("Đặt bàn thành công!"),
              preFee > 0
                  ? Column(
                      children: [
                        Text(
                            "Phí trả trước là ${NumberFormat.simpleCurrency(locale: "vi-VN", name: "VNĐ", decimalDigits: 0).format(preFee)}"),
                        Text(
                          "Bạn phải thanh toán trước $deadline. Nếu không, hệ thống sẽ xóa yêu cầu đặt bàn này!",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }

  void _openDialogConfirmReservation() {
    showDialog(
      context: context,
      builder: (context) {
        return AppDialogText(
            child: Text("Xác nhận đặt bàn?"),
            onDone: () {
              Navigator.pop(context);
              _requestMakeReservation(context);
            },
            onCancel: () {
              Navigator.pop(context);
            });
      },
    );
  }

  void _openDialogNeedAuthentication() {
    showDialog(
      context: context,
      builder: (context) {
        return AppDialogText(
          buttonDoneTitle: "Đăng nhập",
          onDone: () {
            Navigator.pop(context);
            _openLoginDialog();
          },
          onCancel: () {
            Navigator.pop(context);
          },
          child: Text("Vui lòng đăng nhập!"),
        );
      },
    );
  }

  _openLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ct) {
        return LoginScreen(
          onLoginDone: () {
            _openDialogConfirmReservation();
          },
        );
      },
    );
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: scheduleDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      helpText: 'Chọn ngày',
      confirmText: 'Xác nhận',
      cancelText: 'Thoát',
    );
    if (mounted && picked != null && picked.isBefore(scheduleDate)) {
      Fluttertoast.showToast(
        msg: Translate.of(context).translate("VALIDATE_DATE_E001"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        webBgColor: dangerColorToast,
        webShowClose: true,
      );
      return;
    }
    if (picked != null && picked != scheduleDate) {
      setState(() {
        scheduleDate = picked;
      });
    }
  }

  void selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: scheduleHour,
      cancelText: "Thoát",
      confirmText: "Xác nhận",
      helpText: "Chọn giờ",
    );
    if (mounted && picked != null) {
      if (scheduleDate.isSameDate(DateTime.now())) {
        if (picked.hour + picked.minute / 60.0 <
            DateTime.now().hour + DateTime.now().minute / 60.0) {
          Fluttertoast.showToast(
            msg: Translate.of(context).translate("VALIDATE_TIME_E001"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            webBgColor: dangerColorToast,
            webShowClose: true,
          );
          return;
        }
      }
      if (picked != scheduleHour) {
        setState(() {
          scheduleHour = picked;
        });
      }
    }
  }

  void _openDialogPeople() {
    showDialog(
      context: context,
      builder: (BuildContext ct) {
        return StatefulBuilder(builder: (context, newState) {
          return AppDialogInput(
            title: "Số người",
            buttonDoneTitle: "Đồng ý",
            buttonCancelTitle: "Thoát",
            onDone: () {
              String errorText = "";
              if (peopleController.text.isEmpty) {
                errorText =
                    Translate.of(context).translate("VALIDATE_PEOPLE_E001");
              } else if (ParseTypeData.ensureInt(
                      peopleController.text.trim()) ==
                  0) {
                errorText =
                    Translate.of(context).translate("VALIDATE_PEOPLE_E002");
              } else if (!RegExp(r"^[0-9]*$")
                  .hasMatch(peopleController.text.trim())) {
                errorText =
                    Translate.of(context).translate("VALIDATE_NUMBER_E001");
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
                setState(() {});
                Navigator.pop(context);
              }
            },
            onCancel: () {
              Navigator.pop(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInput2(
                  name: "people",
                  keyboardType: TextInputType.number,
                  controller: peopleController,
                  placeHolder: "1, 2, 3...",
                  focusNode: peopleNode,
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildRowHeader(BuildContext context,
      {String title = "", String content = "", Function? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFF313131),
        borderRadius: BorderRadius.circular(kCornerSmall),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(kCornerSmall),
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Color(0XFFB6B6B6),
                        ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 16,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 650,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCornerNormal),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Đặt bàn",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        Tooltip(
                          message:
                              "Hệ thống sẽ tự động xếp bàn dựa theo số lượng, thời gian, loại bàn bạn chọn!",
                          child: Icon(
                            Icons.info_outline,
                            size: 16,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        widget.onTapClose();
                      },
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Color(0XFF313131),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                _buildRowHeader(
                  context,
                  title: "Số người",
                  content: "${peopleController.text} người",
                  onTap: () {
                    _openDialogPeople();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                _buildRowHeader(
                  context,
                  title: "Ngày",
                  content: DateFormat("dd/MM/yyyy").format(scheduleDate),
                  onTap: () {
                    selectDate(context);
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                _buildRowHeader(
                  context,
                  title: "Thời gian",
                  content:
                      "${scheduleHour.hour.toString().padLeft(2, "0")}:${scheduleHour.minute.toString().padLeft(2, "0")}",
                  onTap: () {
                    selectTime(context);
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                // _buildRowHeader(
                //   context,
                //   title: "Loại bàn",
                //   content: AppBloc.uiBloc.state.selectedTableType?.name ?? "",
                //   onTap: () {},
                // ),
                if (AppBloc.uiBloc.state.selectedTableType != null)
                  AppPopupMenuButton<TableTypeDetailModel>(
                    items: tableTypes,
                    height: 35,
                    value: AppBloc.uiBloc.state.selectedTableType!,
                    buttonBgColor: Color(0XFF313131),
                    menuDropBgColor: Color(0XFF313131),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 260,
                        minWidth: 200,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kCornerSmall),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Loại bàn",
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .bodyMedium
                              //     ?.copyWith(
                              //       fontStyle: FontStyle.italic,
                              //       color: Color(0XFFB6B6B6),
                              //     ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              AppBloc.uiBloc.state.selectedTableType!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onChanged: (value) {
                      AppBloc.uiBloc.add(
                        OnUpdateState(params: const {
                          "tableTypeState": BlocState.loading
                        }),
                      );
                      AppBloc.uiBloc.add(
                        OnChangeTableType(params: {"tableType": value}),
                      );
                    },
                    filterItemBuilder: (context, e) {
                      return DropdownMenuItem<TableTypeDetailModel>(
                        value: e,
                        child: Text(
                          e.name,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TabBar(
            controller: tabController,
            indicatorColor: primaryColor,
            labelPadding: EdgeInsets.only(bottom: 5),
            tabs: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Menu",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Tooltip(
                    message: "Thay đổi thứ tự dọn món bằng cách di chuyển món.",
                    child: Icon(
                      Icons.info_outline,
                      size: 16,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Đồ uống",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dịch vụ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ghi chú",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Tooltip(
                    message:
                        "Những ghi chú này sẽ được quản lý nhà hàng ghi nhận.",
                    child: Icon(
                      Icons.info_outline,
                      size: 16,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Container(
                  padding: EdgeInsets.all(kPadding10),
                  child: context.read<UiBloc>().state.dishes.isNotEmpty
                      ? ReorderableListView.builder(
                          itemCount: context.read<UiBloc>().state.dishes.length,
                          itemBuilder: (context, index) {
                            return Container(
                              key: Key("$index"),
                              margin: EdgeInsets.only(bottom: 3, top: 3),
                              child: DishReservationItem(
                                item:
                                    context.read<UiBloc>().state.dishes[index],
                              ),
                            );
                          },
                          onReorder: (int oldIndex, int newIndex) {
                            context.read<UiBloc>().add(
                                  OnUpdateState(params: const {
                                    "dishState": BlocState.loading
                                  }),
                                );
                            context.read<UiBloc>().add(OnChangeOrderDish(
                                  params: {
                                    "oldIndex": oldIndex,
                                    "newIndex": newIndex,
                                  },
                                ));
                          },
                        )
                      : NoDataFoundView(
                          message: "Bạn chưa thêm món ăn",
                        ),
                ),
                Container(
                  padding: EdgeInsets.all(kPadding10),
                  child: context.read<UiBloc>().state.drinks.isNotEmpty
                      ? ListView.builder(
                          itemCount: context.read<UiBloc>().state.drinks.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 3, top: 3),
                              child: DrinkReservationItem(
                                  item: context
                                      .read<UiBloc>()
                                      .state
                                      .drinks[index]),
                            );
                          },
                        )
                      : NoDataFoundView(
                          message: "Bạn chưa thêm đồ uống",
                        ),
                ),
                Container(
                  padding: EdgeInsets.all(kPadding10),
                  child: context.read<UiBloc>().state.services.isNotEmpty
                      ? ListView.builder(
                          itemCount:
                              context.read<UiBloc>().state.services.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 3, top: 3),
                              child: ServiceReservationItem(
                                  item: context
                                      .read<UiBloc>()
                                      .state
                                      .services[index]),
                            );
                          },
                        )
                      : NoDataFoundView(
                          message: "Bạn chưa thêm dịch vụ",
                        ),
                ),
                TextField(
                  controller: textEditingController,
                  focusNode: _noteNode,
                  maxLines: null,
                  textInputAction: TextInputAction.none,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Điền ghi chú...',
                    contentPadding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          AppButton(
            "Xác nhận đặt bàn",
            onPressed: () {
              if (!AppBloc.uiBloc.state.canMakeReservation()) {
                Fluttertoast.showToast(
                  msg: Translate.of(context).translate("MENU_EMPTY_E001"),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: primaryColor,
                  textColor: Colors.white,
                  fontSize: 16.0,
                  webBgColor: dangerColorToast,
                );
                return;
              }
              if (AppBloc.authenticationBloc.state is AuthenticationSuccess) {
                _openDialogConfirmReservation();
              } else {
                _openDialogNeedAuthentication();
              }
            },
          ),
          SizedBox(
            height: kPadding10,
          ),
        ],
      ),
    );
  }
}
