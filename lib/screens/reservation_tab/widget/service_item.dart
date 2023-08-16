import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/blocs/ui/ui_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/service.dart';

class ServiceReservationItem extends StatefulWidget {
  const ServiceReservationItem({super.key, required this.item});
  final ServiceDetailModel item;

  @override
  State<ServiceReservationItem> createState() => _ServiceReservationItemState();
}

class _ServiceReservationItemState extends State<ServiceReservationItem> {
  late bool isSelected;

  @override
  void initState() {
    isSelected = widget.item.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: kPadding10 / 2),
            width: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kCornerLarge),
              color: primaryColor,
            ),
          ),
          SizedBox(
            width: kPadding10 / 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                    ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "${widget.item.priceStr} VNĐ",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: primaryColor,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
          Spacer(),
          Checkbox(
              value: isSelected,
              onChanged: (value) {
                isSelected = value!;
                context.read<UiBloc>().add(
                      OnUpdateState(
                          params: const {"dishState": BlocState.loading}),
                    );
                context.read<UiBloc>().add(OnChangeSelectedService(
                      params: {
                        "service": widget.item,
                        "isSelected": isSelected,
                      },
                    ));
              }),
        ],
      ),
    );
  }
}
