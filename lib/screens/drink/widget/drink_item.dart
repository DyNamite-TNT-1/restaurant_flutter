import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';

class DrinkItem extends StatefulWidget {
  const DrinkItem({super.key, required this.id});
  final String id;

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
            context.goNamed(RouteConstants.drinkDetail, pathParameters: {
              "id": widget.id,
            });
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
                  imageUrl:
                      "https://cdn.tgdd.vn/2020/08/CookProduct/5-1200x676-1.jpg",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: kPadding10,
              ),
              Text(
                "Rượu vang ${widget.id}",
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding15),
                child: Text(
                  "Rượu vang từ Đan Mạch",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Text(
                      "599.000 VNĐ",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: primaryColor,
                          ),
                    ),
                  ],
                ),
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
                      "Xem chi tiết",
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
