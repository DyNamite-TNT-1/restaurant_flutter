import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/widgets/app_button.dart';

class DishDetailScreen extends StatefulWidget {
  const DishDetailScreen({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 6,
              vertical: kDefaultPadding * 3,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(
                  kDefaultPadding,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://chefjob.vn/wp-content/uploads/2020/02/dinh-nghia-bbq-la-gi.jpg",
                        height: 400,
                        width: 400,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Dolor Comon BBQ ${widget.id}",
                            style: Theme.of(context).textTheme.titleLarge,
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
                          Text(
                            "599.000 VNĐ",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: primaryColor,
                                      fontSize: 32,
                                    ),
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          Text(
                            "Làm từ thịt cừu non, là một món BBQ ngon thượng hạng. Hứa hẹn sẽ cho bạn trải nghiệm thịt nướng tuyệt vời.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          AppButton(
                            "Thêm vào thực đơn",
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
