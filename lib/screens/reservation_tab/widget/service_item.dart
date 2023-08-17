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
  @override
  void initState() {
    super.initState();
  }

  Widget _iconBtn(
    BuildContext context,
    IconData icon,
    Function onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          onTap();
        },
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.red,
            ),
          ),
          child: Icon(
            icon,
            size: 14,
          ),
        ),
      ),
    );
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
          Expanded(
            child: Column(
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
                  "${widget.item.priceStr} VNĐ/ ${widget.item.unit}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: primaryColor,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: kPadding10,
          ),
          Text("Số lượng: ${widget.item.quantity}"),
          SizedBox(
            width: kPadding10,
          ),
          Row(
            children: [
              _iconBtn(
                context,
                Icons.add,
                () {
                  context.read<UiBloc>().add(
                        OnUpdateState(
                            params: const {"serviceState": BlocState.loading}),
                      );
                  context.read<UiBloc>().add(
                        OnAddService(
                          params: {"service": widget.item},
                        ),
                      );
                },
              ),
              SizedBox(
                width: kPadding10 / 2,
              ),
              _iconBtn(
                context,
                Icons.remove,
                () {
                  context.read<UiBloc>().add(
                        OnUpdateState(
                            params: const {"serviceState": BlocState.loading}),
                      );
                  context.read<UiBloc>().add(
                        OnSubtractService(
                          params: {"service": widget.item},
                        ),
                      );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
