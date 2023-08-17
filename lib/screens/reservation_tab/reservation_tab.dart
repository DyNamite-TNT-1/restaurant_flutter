import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/app_bloc.dart';
import 'package:restaurant_flutter/blocs/ui/ui_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/models/service/table.dart';
import 'package:restaurant_flutter/screens/reservation_tab/widget/service_item.dart';
import 'package:restaurant_flutter/widgets/app_popup_menu_button.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

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
      tableTypes = TableTypeDetailModel.parseListDishItem(result.data);
      if (AppBloc.uiBloc.state.selectedTableType == null) {
        AppBloc.uiBloc.add(
          OnChangeTableType(params: {"tableType": tableTypes[0]}),
        );
      }
    }
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: scheduleDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Chọn ngày',
      confirmText: 'Xác nhận',
      cancelText: 'Thoát',
    );
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
    if (picked != null && picked != scheduleHour) {
      setState(() {
        scheduleHour = picked;
      });
    }
  }

  void _openDialogPeople() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ct) {
        return StatefulBuilder(builder: (context, newState) {
          return AppDialogInput(
            title: "Số người",
            buttonDoneTitle: "Đồng ý",
            buttonCancelTitle: "Thoát",
            onDone: () {
              setState(() {});
              Navigator.pop(context);
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
                  content: DateFormat("yyyy/MM/dd").format(scheduleDate),
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
                    menuDropBgColor: Colors.white,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Color(0XFFB6B6B6),
                                  ),
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
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    onChanged: (value) {},
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
                  // Tooltip(
                  //   message: "Thay đổi thứ tự dọn món bằng cách di chuyển món.",
                  //   child: Icon(
                  //     Icons.info_outline,
                  //     size: 16,
                  //     color: primaryColor,
                  //   ),
                  // ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dịch vụ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Tooltip(
                    message: "Chọn dịch vụ bạn muốn.",
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
            onPressed: () {},
          ),
          SizedBox(
            height: kPadding10,
          ),
        ],
      ),
    );
  }
}
