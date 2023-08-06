import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

import 'widget/table_item.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  List<String> tableTypes = ["Tất cả", "Vip 1", "Vip 2", "Tầng trệt", "Tầng 2"];
  String _selectedFilter = "Tất cả";

  Widget _buildTopFilter(BuildContext context) {
    return Row(children: [
      Text(
        "Lọc theo",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      ...tableTypes
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
                      e,
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
      body: CustomScrollView(
        slivers: [
          _makeHeaderFilter(context),
          SliverPadding(
            padding: EdgeInsets.all(kPadding10),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return TableItem(id: index.toString());
              },
              itemCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
