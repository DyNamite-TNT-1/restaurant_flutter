import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/reservation/reservation_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/models/service/table.dart';
import 'package:restaurant_flutter/screens/reservation/widget/dish_item.dart';
import 'package:restaurant_flutter/screens/reservation/widget/seat_item.dart';
import 'package:restaurant_flutter/widgets/app_button.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final ReservationBloc _reservationBloc = ReservationBloc(ReservationState());
  String tagRequestTables = "";

  DateTime scheduleDate = DateTime.now();
  TimeOfDay scheduleHour = TimeOfDay.now();
  @override
  void initState() {
    _requestTable();
    super.initState();
  }

  @override
  void dispose() {
    _reservationBloc.close();
    Api.cancelRequest(tag: tagRequestTables);

    super.dispose();
  }

  bool get isServiceClosed {
    return !mounted || _reservationBloc.isClosed;
  }

  Future<void> _requestTable() async {
    if (!isServiceClosed) {
      _reservationBloc.add(
        OnUpdateState(
          params: const {"tableState": BlocState.loading},
        ),
      );
      tagRequestTables = Api.buildIncreaseTagRequestWithID("tables");
      final String datetime =
          "${DateFormat("yyyy-MM-dd").format(scheduleDate)} ${scheduleHour.hour}:${scheduleHour.minute}";

      ResultModel result = await Api.requestTable(
        datetime: datetime,
        tagRequest: tagRequestTables,
      );
      if (!isServiceClosed && result.isSuccess) {
        List<TableDetailModel> tables =
            TableDetailModel.parseListDishItem(result.data["tables"]);
        _reservationBloc.add(
          OnLoadTable(
            params: {
              "tables": tables,
            },
          ),
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

  Widget _buildSelectHour(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(kCornerNormal),
        onTap: () {
          selectTime(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kCornerNormal),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.6,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.more_time,
                color: primaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${scheduleHour.hour.toString().padLeft(2, "0")}:${scheduleHour.minute.toString().padLeft(2, "0")}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectDate(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(kCornerNormal),
        onTap: () {
          selectDate(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kCornerNormal),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.6,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.date_range_outlined,
                color: primaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                DateFormat("yyyy/MM/dd").format(scheduleDate),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildBodyTable() {
    bool showTable =
        _reservationBloc.state.tableState == BlocState.loadCompleted;
    return Container(
      width: 400,
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(kCornerMedium),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: kPadding10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(kCornerNormal),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Chọn thời gian để kiếm tra bàn trống(4 người/bàn)",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Tooltip(
                      message:
                          "Hệ thống sẽ tự động chọn bàn dựa theo số lượng và thời gian bạn chọn!",
                      child: Icon(
                        Icons.info_outline,
                        size: 16,
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: kPadding10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildSelectDate(context),
                    SizedBox(
                      width: kPadding10,
                    ),
                    _buildSelectHour(context),
                  ],
                ),
                SizedBox(
                  height: kPadding10,
                ),
                Row(
                  children: [
                    Tooltip(
                      message: "Kiểm tra thời gian, số lượng phù hợp",
                      child: AppButton(
                        "Kiểm tra",
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      width: kPadding10,
                    ),
                    Tooltip(
                      message: "Lấy danh sách bàn theo ngày giờ bạn chọn",
                      child: AppButton(
                        "Lấy danh sách",
                        color: Colors.green,
                        onPressed: () {
                          _requestTable();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: showTable
                ? GridView.builder(
                    itemCount: _reservationBloc.state.tables.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: kPadding10,
                      crossAxisSpacing: kPadding10,
                    ),
                    itemBuilder: (context, index) {
                      return SeatReservationItem(
                        item: _reservationBloc.state.tables[index],
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyDish() {
    return Expanded(
      child: Column(
        children: [
          Text(
            "Danh sách món",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: 20,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              itemBuilder: (context, index) {
                return DishReservationItem(
                  key: Key("$index"),
                );
              },
              onReorder: (int oldIndex, int newIndex) {},
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _reservationBloc,
      child: BlocBuilder<ReservationBloc, ReservationState>(
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(kPadding10),
                    margin: const EdgeInsets.only(
                      top: kDefaultPadding * 2,
                      right: kDefaultPadding,
                      left: kDefaultPadding,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kCornerMedium),
                    ),
                    child: Row(
                      children: [
                        _buildBodyDish(),
                        _buildBodyTable(),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPadding15 * 2,
                    vertical: kDefaultPadding,
                  ),
                  child: Row(
                    children: [
                      AppButton(
                        "Đặt bàn",
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
