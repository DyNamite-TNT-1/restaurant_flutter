import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/bloc/dish/dish_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/bloc.dart';
import 'package:restaurant_flutter/enum/order.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/dish_type.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

import 'widget/dish_item.dart';

class DishScreen extends StatefulWidget {
  const DishScreen({super.key});

  @override
  State<DishScreen> createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  DishBloc dishBloc = DishBloc(DishState());
  DishTypeModel _selectedFilter = DishTypeModel(
    dishTypeId: 0,
    type: "Tất cả",
  );
  String tagRequestDishes = "";
  String tagRequestDishTypes = "";
  OrderEnum _selectedPriceOrder = OrderEnum.desc;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _requestDishType();
    _requestDish(type: 0, priceOrder: OrderEnum.desc);
  }

  @override
  void dispose() {
    super.dispose();
    Api.cancelRequest(tag: tagRequestDishes);
    Api.cancelRequest(tag: tagRequestDishTypes);
  }

  bool get isServiceClosed {
    return !mounted || dishBloc.isClosed;
  }

  Future<void> _requestDish({
    required int type,
    required OrderEnum priceOrder,
  }) async {
    if (!isServiceClosed) {
      dishBloc.add(
        OnUpdateState(
          params: const {"dishState": BlocState.loading},
        ),
      );
      tagRequestDishes = Api.buildIncreaseTagRequestWithID("dishes");
      DishModel dishModel = await Api.requestDish(
        type: type,
        order: priceOrder,
        page: currentPage,
        isDrink: false,
        tagRequest: tagRequestDishes,
      );
      if (!isServiceClosed && dishModel.isSuccess) {
        dishBloc.add(
          OnLoadDish(
            params: {
              "dishes": dishModel.dishes,
              "currentPage": dishModel.currentPage,
              "maxPage": dishModel.maxPage,
            },
          ),
        );
      }
    }
  }

  Future<void> _requestDishType() async {
    if (!isServiceClosed) {
      dishBloc.add(
        OnUpdateState(
          params: const {"dishTypeState": BlocState.loading},
        ),
      );
      tagRequestDishTypes = Api.buildIncreaseTagRequestWithID("dishTypes");
      DishTypeFilterModel dishTypeModel = await Api.requestDishType(
        isDrinkType: false,
        tagRequest: tagRequestDishTypes,
      );
      if (!isServiceClosed) {
        dishBloc.add(
          OnLoadDishType(
            params: {
              "dishTypes": dishTypeModel.dishTypes,
            },
          ),
        );
      }
    }
  }

  Widget _buildTopFilter(BuildContext context) {
    return Row(
      children: [
        Text(
          "Loại: ",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        PopupMenuButton<DishTypeModel>(
          tooltip: "Chọn loại",
          initialValue: _selectedFilter,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kCornerSmall),
              color: Color(0XFFA0A0A0),
            ),
            child: Row(
              children: [
                Text(
                  _selectedFilter.type,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                ),
                SizedBox(
                  width: 2,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          onSelected: (value) {
            setState(() {
              _selectedFilter = value;
      currentPage = 1;
            });
            _requestDish(
              type: _selectedFilter.dishTypeId,
              priceOrder: _selectedPriceOrder,
            );
          },
          itemBuilder: (context) {
            return dishBloc.state.dishTypes.map(
              (e) {
                return PopupMenuItem<DishTypeModel>(
                  value: e,
                  child: Text(e.type),
                );
              },
            ).toList();
          },
        ),
        SizedBox(
          width: kDefaultPadding,
        ),
        Text(
          "Giá: ",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        PopupMenuButton<OrderEnum>(
          tooltip: "Sắp xếp giá",
          initialValue: _selectedPriceOrder,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kCornerSmall),
              color: Color(0XFFA0A0A0),
            ),
            child: Row(
              children: [
                Text(
                  _selectedPriceOrder.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                ),
                SizedBox(
                  width: 2,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          onSelected: (value) {
            setState(() {
              _selectedPriceOrder = value;
            });
            _requestDish(
              type: _selectedFilter.dishTypeId,
              priceOrder: _selectedPriceOrder,
            );
          },
          itemBuilder: (context) {
            return OrderEnum.allOrderEnum().map(
              (e) {
                return PopupMenuItem<OrderEnum>(
                  value: e,
                  child: Text(e.name),
                );
              },
            ).toList();
          },
        ),
      ],
    );
  }

  Future<void> _onRefresh() async {
    await _requestDish(
      type: _selectedFilter.dishTypeId,
      priceOrder: _selectedPriceOrder,
    );
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTopFilter(context),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(kCornerSmall),
                  onTap: () {
                    _onRefresh();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kCornerSmall),
                      border: Border.all(),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.refresh),
                        Text("Làm mới"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => dishBloc,
      child: BlocBuilder<DishBloc, DishState>(
        builder: (context, state) {
          bool isLoading = state.dishState == BlocState.loading ||
              state.dishTypeState == BlocState.loading;
          currentPage = state.currentPage;
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    _makeHeaderFilter(context),
                    if (state.dishState == BlocState.loadCompleted ||
                        state.dishState == BlocState.loading)
                      SliverPadding(
                        padding: EdgeInsets.all(kPadding10),
                        sliver: SliverGrid.builder(
                          itemCount: state.dishes.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300.0,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return DishItem(
                              dish: state.dishes[index],
                            );
                          },
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Visibility(
                        visible: state.dishState == BlocState.noData,
                        child: NoDataFoundView(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 50,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isLoading,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: NumberPagination(
                    onPageChanged: (int pageNumber) {
                      setState(() {
                        currentPage = pageNumber;
                      });
                      _requestDish(
                        type: _selectedFilter.dishTypeId,
                        priceOrder: _selectedPriceOrder,
                      );
                    },
                    pageTotal: state.maxPage,
                    pageInit: currentPage, // picked number when init page
                    colorPrimary: primaryColor,
                    // colorSub: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
