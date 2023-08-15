import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/screens/reservation/widget/dish_item.dart';
import 'package:restaurant_flutter/screens/reservation/widget/seat_item.dart';
import 'package:restaurant_flutter/widgets/app_button.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime scheduleDate = DateTime.now();
  TimeOfDay scheduleHour = TimeOfDay.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        helpText: "Chọn giờ");
    if (picked != null && picked != scheduleHour) {
      setState(() {
        scheduleHour = picked;
      });
    }
  }

  InkWell _buildSelectHour(BuildContext context) {
    return InkWell(
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
              "${scheduleHour.hour}:${scheduleHour.minute}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildSelectDate(BuildContext context) {
    return InkWell(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Danh sách món",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(kPadding10),
                      child: Text(
                        "Chọn thời gian để kiếm tra bàn trống",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildSelectDate(context),
                        SizedBox(
                          width: kPadding10,
                        ),
                        _buildSelectHour(context),
                        SizedBox(
                          width: kPadding10,
                        ),
                        AppButton(
                          "Kiểm tra",
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: kPadding10,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 1000,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey,
                      child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return DishReservationItem();
                          }),
                    ),
                  ),
                  Container(
                    width: 360,
                    height: double.infinity,
                    padding: EdgeInsets.all(kPadding10),
                    child: GridView.builder(
                      itemCount: 50,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: kPadding10,
                          crossAxisSpacing: kPadding10),
                      itemBuilder: (context, index) {
                        return SeatReservationItem();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
