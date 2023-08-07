import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/bloc/dish/dish_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/bloc.dart';
import 'package:restaurant_flutter/enum/order.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/dish_type.dart';
import 'package:restaurant_flutter/widgets/app_dialog_input.dart';
import 'package:restaurant_flutter/widgets/app_popup_menu_button.dart';
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
        AppPopupMenuButton<DishTypeModel>(
          tooltip: "Chọn loại",
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
          data: dishBloc.state.dishTypes,
          filterItemBuilder: (context, label) {
            return PopupMenuItem<DishTypeModel>(
              value: label,
              child: Text(label.type),
            );
          },
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
        ),
        SizedBox(
          width: kDefaultPadding,
        ),
        Text(
          "Giá: ",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        AppPopupMenuButton<OrderEnum>(
          tooltip: "Sắp xếp giá",
          onSelected: (value) {
            setState(() {
              _selectedPriceOrder = value;
            });
            _requestDish(
              type: _selectedFilter.dishTypeId,
              priceOrder: _selectedPriceOrder,
            );
          },
          data: OrderEnum.allOrderEnum(),
          filterItemBuilder: (context, label) {
            return PopupMenuItem<OrderEnum>(
              value: label,
              child: Text(label.name),
            );
          },
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

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _priceController = TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();
  final TextEditingController _imageController = TextEditingController();
  final FocusNode _imageFocusNode = FocusNode();
  final TextEditingController _unitController = TextEditingController();
  final FocusNode _unitFocusNode = FocusNode();

  void _openDialogAddNewDish() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ct) {
        return AppDialogInput(
          title: "Thêm món mới",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  "Tên món",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                      ),
                ),
              ),
              AppInput2(
                name: "name",
                keyboardType: TextInputType.name,
                controller: _nameController,
                placeHolder: "Điền tên món",
                focusNode: _nameFocusNode,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Text(
                            "Giá món(VNĐ)",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 16,
                                ),
                          ),
                        ),
                        AppInput2(
                          name: "price",
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                          placeHolder: "Nhập giá món(VNĐ)",
                          focusNode: _priceFocusNode,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: kPadding15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Text(
                            "Đơn vị tính",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 16,
                                ),
                          ),
                        ),
                        AppInput2(
                          name: "price",
                          keyboardType: TextInputType.number,
                          controller: _unitController,
                          placeHolder: "Ex: phần, dĩa, ly...",
                          focusNode: _unitFocusNode,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  "Mô tả",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                      ),
                ),
              ),
              AppInput2(
                name: "description",
                keyboardType: TextInputType.name,
                controller: _descriptionController,
                placeHolder: "Thêm mô tả(tùy chọn)",
                focusNode: _descriptionFocusNode,
                maxLines: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  "Link ảnh",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                      ),
                ),
              ),
              AppInput2(
                name: "image",
                keyboardType: TextInputType.name,
                controller: _imageController,
                placeHolder: "Url ảnh(tùy chọn)",
                focusNode: _imageFocusNode,
              ),
            ],
          ),
          onDone: () {
            context.pop();
          },
          onCancel: () {
            context.pop();
          },
        );
      },
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
              Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(kCornerSmall),
                      onTap: () {
                        _openDialogAddNewDish();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kCornerSmall),
                          border: Border.all(),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.add),
                            Text("Thêm món"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
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
