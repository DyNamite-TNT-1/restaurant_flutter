import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/screens/drink/widget/drink_item.dart';
import 'package:restaurant_flutter/widgets/app_header_sliver.dart';

class DrinkScreen extends StatefulWidget {
  const DrinkScreen({super.key});

  @override
  State<DrinkScreen> createState() => _DrinkScreenState();
}

class _DrinkScreenState extends State<DrinkScreen> {
  DrinkFilter _selectedFilter = DrinkFilter.all;

  Widget _buildTopFilter(BuildContext context) {
    return Row(children: [
      Text(
        "Lọc theo",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      ...DrinkFilter.allDrinkFilter()
          .map(
            (e) => Container(
              margin: EdgeInsets.symmetric(horizontal: kPadding10),
              decoration: BoxDecoration(
                color:
                    _selectedFilter == e ? Color(0XFFEE4D2D) : backgroundColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: _selectedFilter == e ? Colors.transparent : subColor,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    if (_selectedFilter != e) {
                      setState(() {
                        _selectedFilter = e;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      e.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color:
                                _selectedFilter == e ? Colors.white : textColor,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ]);
  }

  SliverPersistentHeader _makeHeaderFilter(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: PinSliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: kPadding15,
            vertical: kPadding10,
          ),
          color: backgroundColor,
          child: _buildTopFilter(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          _makeHeaderFilter(context),
          SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300.0,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (BuildContext context, int index) {
              return DrinkItem(id: index.toString());
            },
            itemCount: 20,
          ),
        ],
      ),
    );
  }
}
