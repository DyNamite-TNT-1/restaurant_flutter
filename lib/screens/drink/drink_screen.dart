import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/blocs/drink/drink_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/configs/user_repository.dart';
import 'package:restaurant_flutter/enum/bloc.dart';
import 'package:restaurant_flutter/enum/order.dart';
import 'package:restaurant_flutter/models/client/client_dish.dart';
import 'package:restaurant_flutter/models/service/dish_type.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/utils/extension.dart';
import 'package:restaurant_flutter/widgets/app_popup_menu_button.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

import 'widget/drink_item.dart';

class DrinkScreen extends StatefulWidget {
  const DrinkScreen({super.key});

  @override
  State<DrinkScreen> createState() => _DrinkScreenState();
}

class _DrinkScreenState extends State<DrinkScreen> {
  DrinkBloc drinkBloc = DrinkBloc(DrinkState());
  DishTypeModel _selectedFilter = DishTypeModel(
    dishTypeId: 0,
    type: "Tất cả",
  );
  String tagRequestDrinks = "";
  String tagRequestDrinkTypes = "";
  OrderEnum _selectedPriceOrder = OrderEnum.desc;
  int currentPage = 1;

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

  @override
  void initState() {
    super.initState();
    _requestDrinkType();
    _requestDrink(type: 0, priceOrder: OrderEnum.desc);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _imageController.clear();
    _unitController.clear();
    drinkBloc.close();
    Api.cancelRequest(tag: tagRequestDrinks);
    Api.cancelRequest(tag: tagRequestDrinkTypes);
  }

  bool get isServiceClosed {
    return !mounted || drinkBloc.isClosed;
  }

  Future<void> _requestDrink({
    required int type,
    required OrderEnum priceOrder,
  }) async {
    if (!isServiceClosed) {
      drinkBloc.add(
        OnUpdateState(
          params: const {"drinkState": BlocState.loading},
        ),
      );
      tagRequestDrinks = Api.buildIncreaseTagRequestWithID("drinks");
      ResultModel result = await Api.requestDish(
        type: type,
        order: priceOrder,
        page: currentPage,
        isDrink: true,
        tagRequest: tagRequestDrinks,
      );
      if (!isServiceClosed && result.isSuccess) {
        ClientDishModel drinkModel = ClientDishModel.fromJson(result.data);
        drinkBloc.add(
          OnLoadDrink(
            params: {
              "drinks": drinkModel.dishes,
              "currentPage": drinkModel.currentPage,
              "maxPage": drinkModel.maxPage,
            },
          ),
        );
      }
    }
  }

  Future<void> _requestDrinkType() async {
    if (!isServiceClosed) {
      drinkBloc.add(
        OnUpdateState(
          params: const {"drinkTypeState": BlocState.loading},
        ),
      );
      tagRequestDrinkTypes = Api.buildIncreaseTagRequestWithID("drinkTypes");
      ResultModel result = await Api.requestDishType(
        isDrinkType: true,
        tagRequest: tagRequestDrinkTypes,
      );
      if (!isServiceClosed && result.isSuccess) {
        DishTypeFilterModel drinkTypeModel =
            DishTypeFilterModel.fromJson(result.data);
        drinkBloc.add(
          OnLoadDrinkType(
            params: {
              "drinkTypes": drinkTypeModel.dishTypes,
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
        if (drinkBloc.state.drinkTypes.isNotEmpty &&
            drinkBloc.state.drinkTypeState == BlocState.loadCompleted)
          AppPopupMenuButton<DishTypeModel>(
            items: drinkBloc.state.drinkTypes,
            value: _selectedFilter,
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
            onChanged: (value) {
              setState(() {
                _selectedFilter = value;
                currentPage = 1;
              });
              _requestDrink(
                type: _selectedFilter.dishTypeId,
                priceOrder: _selectedPriceOrder,
              );
            },
            filterItemBuilder: (context, e) {
              return DropdownMenuItem<DishTypeModel>(
                value: e,
                child: Text(e.type),
              );
            },
          ),
        SizedBox(
          width: kDefaultPadding,
        ),
        Text(
          "Giá: ",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        AppPopupMenuButton<OrderEnum>(
          items: OrderEnum.allOrderEnum(),
          value: _selectedPriceOrder,
          child: Row(
            children: [
              Text(
                _selectedPriceOrder.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          onChanged: (value) {
            setState(() {
              _selectedPriceOrder = value;
            });
            _requestDrink(
              type: _selectedFilter.dishTypeId,
              priceOrder: _selectedPriceOrder,
            );
          },
          filterItemBuilder: (context, e) {
            return DropdownMenuItem<OrderEnum>(
              value: e,
              child: Text(e.name),
            );
          },
        ),
      ],
    );
  }

  Future<void> _onRefresh() async {
    await _requestDrink(
      type: _selectedFilter.dishTypeId,
      priceOrder: _selectedPriceOrder,
    );
  }

  Future<void> _addNewDrink(DishTypeModel dishType) async {
    ResultModel result = await Api.addDish(
      name: _nameController.text,
      description: _descriptionController.text,
      image: _imageController.text,
      isDrink: true,
      unit: _unitController.text.capitalize(),
      price: _priceController.text,
      dishTypeId: dishType.dishTypeId,
    );
    if (result.isSuccess) {
      if (context.mounted) {
        Fluttertoast.showToast(
          msg: "Thêm món mới thành công!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          textColor: Colors.white,
          fontSize: 16.0,
          webShowClose: true,
          webBgColor: successColorToast,
        );
        context.pop();
        _onRefresh();
        _nameController.text = "";
        _descriptionController.text = "";
        _priceController.text = "";
        _imageController.text = "";
        _unitController.text = "";
      }
    } else {
      Fluttertoast.showToast(
        msg: "Thêm món mới thất bại!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
        webShowClose: true,
        webBgColor: dangerColorToast,
      );
    }
  }

  void _openDialogAddNewDish() {
    DishTypeModel selectedFilter2 = drinkBloc.state.drinkTypes.sublist(1)[0];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ct) {
        return StatefulBuilder(builder: (context, newState) {
          return AppDialogInput(
            title: "Thêm đồ uống mới",
            buttonDoneTitle: "Tạo",
            buttonCancelTitle: "Thoát",
            onDone: () {
              _addNewDrink(selectedFilter2);
            },
            onCancel: () {
              context.pop();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5,
                    top: 10,
                  ),
                  child: Text(
                    "Tên đồ uống",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ),
                AppInput2(
                  name: "name",
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  placeHolder: "Điền tên",
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
                              "Giá(VNĐ)",
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
                            placeHolder: "Nhập giá(VNĐ)",
                            focusNode: _priceFocusNode,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: kPadding10,
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
                            keyboardType: TextInputType.name,
                            controller: _unitController,
                            placeHolder: "Ex: lon, chai...",
                            focusNode: _unitFocusNode,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: kPadding10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              "Loại đồ uống",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                          AppPopupMenuButton<DishTypeModel>(
                            height: 45,
                            value: selectedFilter2,
                            onChanged: (value) {
                              newState(() {
                                selectedFilter2 = value;
                              });
                            },
                            items: drinkBloc.state.drinkTypes.sublist(1),
                            filterItemBuilder: (context, label) {
                              return DropdownMenuItem<DishTypeModel>(
                                value: label,
                                child: Text(label.type),
                              );
                            },
                            child: Text(
                              selectedFilter2.type,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
          );
        });
      },
    );
  }

  // SliverPersistentHeader _makeHeaderFilter(BuildContext context) {
  //   var authState = context.select((AuthenticationBloc bloc) => bloc.state);
  //   return SliverPersistentHeader(
  //     pinned: true,
  //     delegate: PinSliverAppBarDelegate(
  //       minHeight: 50.0,
  //       maxHeight: 50.0,
  //       child: Container(
  //         padding: EdgeInsets.symmetric(
  //           horizontal: kPadding15,
  //           vertical: kPadding10,
  //         ),
  //         color: backgroundColor,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             _buildTopFilter(context),
  //             Row(
  //               children: [
  //                 if (authState is AuthenticationSuccess &&
  //                     UserRepository.userModel.isManager)
  //                   Material(
  //                     color: Colors.transparent,
  //                     child: InkWell(
  //                       borderRadius: BorderRadius.circular(kCornerSmall),
  //                       onTap: () {
  //                         _openDialogAddNewDish();
  //                       },
  //                       child: Container(
  //                         padding: EdgeInsets.symmetric(horizontal: 5),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(kCornerSmall),
  //                           border: Border.all(),
  //                         ),
  //                         child: Row(
  //                           children: const [
  //                             Icon(Icons.add),
  //                             Text("Thêm đồ uống"),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 SizedBox(
  //                   width: 5,
  //                 ),
  //                 Material(
  //                   color: Colors.transparent,
  //                   child: InkWell(
  //                     borderRadius: BorderRadius.circular(kCornerSmall),
  //                     onTap: () {
  //                       _onRefresh();
  //                     },
  //                     child: Container(
  //                       padding: EdgeInsets.symmetric(horizontal: 5),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(kCornerSmall),
  //                         border: Border.all(),
  //                       ),
  //                       child: Row(
  //                         children: const [
  //                           Icon(Icons.refresh),
  //                           Text("Làm mới"),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _makeHeaderFilter(BuildContext context) {
    var authState = context.select((AuthenticationBloc bloc) => bloc.state);
    return Container(
      height: 50,
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
              if (authState is AuthenticationSuccess &&
                  UserRepository.userModel.isManager)
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
                          Text("Thêm đồ uống"),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => drinkBloc,
      child: BlocListener<DrinkBloc, DrinkState>(
        listenWhen: (previous, current) {
          if (previous.drinkTypeState == BlocState.loading &&
              current.drinkTypeState == BlocState.loadCompleted) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          setState(() {
            _selectedFilter = state.drinkTypes[0];
          });
        },
        child: BlocBuilder<DrinkBloc, DrinkState>(
          builder: (context, state) {
            bool isLoading = state.drinkState == BlocState.loading ||
                state.drinkTypeState == BlocState.loading;
            return Scaffold(
              backgroundColor: backgroundColor,
              body: Stack(
                children: [
                  _makeHeaderFilter(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: CustomScrollView(
                      slivers: [
                        if (state.drinkState == BlocState.loadCompleted ||
                            state.drinkState == BlocState.loading)
                          SliverPadding(
                            padding: EdgeInsets.all(kPadding10),
                            sliver: SliverGrid.builder(
                              itemCount: state.drinks.length,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300.0,
                                mainAxisSpacing: 20.0,
                                crossAxisSpacing: 20.0,
                                childAspectRatio: 0.7,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return DrinkItem(
                                  drink: state.drinks[index],
                                );
                              },
                            ),
                          ),
                        SliverToBoxAdapter(
                          child: Visibility(
                            visible: state.drinkState == BlocState.noData,
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
                        _requestDrink(
                          type: _selectedFilter.dishTypeId,
                          priceOrder: _selectedPriceOrder,
                        );
                      },
                      pageTotal: state.maxPage,
                      pageInit: currentPage, // picked number when init page
                      colorPrimary: primaryColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
