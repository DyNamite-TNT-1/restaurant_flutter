import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_flutter/blocs/ui/ui_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/dish.dart';

class DrinkItem extends StatefulWidget {
  const DrinkItem({super.key, required this.drink});
  final DishDetailModel drink;

  @override
  State<DrinkItem> createState() => _DrinkItemState();
}

class _DrinkItemState extends State<DrinkItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isHover ? primaryColor : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(5),
        color: Color(0XFFFFFFFF),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<UiBloc>().add(
                  OnUpdateState(
                      params: const {"drinkState": BlocState.loading}),
                );
            context.read<UiBloc>().add(
                  OnAddDrink(params: {
                    "drink": widget.drink,
                  }),
                );
          },
          onHover: (value) {
            setState(() {
              isHover = value;
            });
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.drink.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: kPadding10,
              ),
              Text(
                widget.drink.name,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding15),
                child: Text(
                  widget.drink.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Text(
                "${widget.drink.priceStr} VNĐ/ ${widget.drink.unit}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: primaryColor,
                    ),
              ),
              RatingBarIndicator(
                rating: 4.35,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
              Spacer(),
              if (isHover)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "Thêm vào đồ uống",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
