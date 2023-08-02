import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';

class DishItem extends StatefulWidget {
  const DishItem({super.key, required this.id});
  final String id;

  @override
  State<DishItem> createState() => _DishItemState();
}

class _DishItemState extends State<DishItem> {
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
            context.goNamed(RouteConstants.dishDetail, pathParameters: {
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
                      "https://chefjob.vn/wp-content/uploads/2020/02/dinh-nghia-bbq-la-gi.jpg",
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
                "Dolor Comon BBQ ${widget.id}",
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding15),
                child: Text(
                  "Làm từ thịt cừu non, là một món BBQ ngon thượng hạng. Hứa hẹn sẽ cho bạn trải nghiệm thịt nướng tuyệt vời.",
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
