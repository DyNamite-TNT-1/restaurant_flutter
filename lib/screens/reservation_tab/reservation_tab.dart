import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_flutter/blocs/ui/ui_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/screens/reservation_tab/widget/service_item.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

import 'widget/dish_item.dart';

class ReservationTab extends StatefulWidget {
  const ReservationTab({super.key, required this.onTapClose});
  final Function onTapClose;

  @override
  State<ReservationTab> createState() => _ReservationTabState();
}

class _ReservationTabState extends State<ReservationTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController textEditingController = TextEditingController();
  DateTime scheduleDate = DateTime.now();
  TimeOfDay scheduleHour = TimeOfDay.now();
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
    tabController = TabController(length: 3, vsync: this);
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
                  content: "3 người",
                  onTap: () {},
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
                _buildRowHeader(
                  context,
                  title: "Loại bàn",
                  content: "Tầng 1",
                  onTap: () {},
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
                      : NoDataFoundView(),
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
                      : NoDataFoundView(),
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
