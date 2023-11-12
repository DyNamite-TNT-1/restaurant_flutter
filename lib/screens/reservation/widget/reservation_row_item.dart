import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/models/service/reservation.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/utils/extension.dart';

class ReservationRowItem extends StatefulWidget {
  const ReservationRowItem({
    super.key,
    required this.item,
    required this.backToParent,
  });

  final ReservationDetailModel item;
  final Function backToParent;

  @override
  State<ReservationRowItem> createState() => _ReservationRowItemState();
}

class _ReservationRowItemState extends State<ReservationRowItem> {
  late String createAtDate;
  late String createAtHour;
  late String scheduleDate;
  late String scheduleHour;

  @override
  void initState() {
    createAtDate =
        DateFormat("dd/MM/yyyy").format(widget.item.createAt.toDateTime());
    createAtHour =
        DateFormat("HH:mm").format(widget.item.createAt.toDateTime());
    scheduleDate =
        DateFormat("dd/MM/yyyy").format(widget.item.schedule.toDateTime());
    scheduleHour =
        DateFormat("HH:mm").format(widget.item.schedule.toDateTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 5,
        right: kDefaultPadding,
        left: kDefaultPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCornerSmall),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kPadding10,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "${widget.item.reservationId}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Color(0XFF6C6EB8),
                  ),
            ),
          ),
          SizedBox(
            width: kPadding10,
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scheduleDate,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(scheduleHour),
              ],
            ),
          ),
          SizedBox(
            width: kPadding10,
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${widget.item.countGuest}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  // color: Color(0XFF6C6EB8),
                  ),
            ),
          ),
          SizedBox(
            width: kPadding10,
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: kPadding10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kCornerSmall),
                color: widget.item.statusColor,
              ),
              child: Center(
                child: Text(
                  widget.item.statusStr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: kPadding10,
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  createAtDate,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(createAtHour),
              ],
            ),
          ),
          SizedBox(
            width: kPadding10,
          ),
          if (!UserRepository.userModel.isClient)
            Expanded(
              flex: 2,
              child: Text(
                widget.item.userModel?.userName ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          SizedBox(
            width: kPadding10,
          ),
          Material(
            color: Colors.transparent,
            child: Tooltip(
              message: "Xem chi tiết",
              child: InkWell(
                onTap: () {
                  context.goNamed(RouteConstants.reservationDetail,
                      pathParameters: {
                        "id": "${widget.item.reservationId}",
                      },
                      extra: {
                        "backToParent": widget.backToParent,
                      });
                },
                child: Icon(Icons.more_vert),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
