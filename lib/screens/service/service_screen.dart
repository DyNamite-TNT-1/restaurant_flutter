import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/authentication/bloc.dart';
import 'package:restaurant_flutter/blocs/bloc/service_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/configs/user_repository.dart';
import 'package:restaurant_flutter/enum/bloc.dart';
import 'package:restaurant_flutter/enum/order.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/dish_type.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/models/service/service.dart';
import 'package:restaurant_flutter/screens/service/widget/service_item.dart';
import 'package:restaurant_flutter/utils/extension.dart';
import 'package:restaurant_flutter/widgets/app_popup_menu_button.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  ServiceBloc serviceBloc = ServiceBloc(ServiceState());

  String tagRequestServices = "";

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

  bool isShowAddNewDishValidateText = false;
  String addNewDishValidateText = "";

  @override
  void initState() {
    super.initState();
    _requestService();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _imageController.clear();
    _unitController.clear();
    Api.cancelRequest(tag: tagRequestServices);
  }

  bool get isServiceClosed {
    return !mounted || serviceBloc.isClosed;
  }

  Future<void> _requestService() async {
    if (!isServiceClosed) {
      serviceBloc.add(
        OnUpdateState(
          params: const {"serviceState": BlocState.loading},
        ),
      );
      tagRequestServices = Api.buildIncreaseTagRequestWithID("services");
      ResultModel result = await Api.requestListService(
        tagRequest: tagRequestServices,
      );
      if (!isServiceClosed && result.isSuccess) {
        List<ServiceDetailModel> services =
            ServiceDetailModel.parseListDishItem(result.data["services"]);
        serviceBloc.add(
          OnLoadService(
            params: {
              "services": services,
            },
          ),
        );
      }
    }
  }

  // Widget _buildTopFilter(BuildContext context) {
  //   return Row(
  //     children: [
  //       Text(
  //         "Loại: ",
  //         style: Theme.of(context).textTheme.bodyLarge,
  //       ),
  //       if (dishBloc.state.dishTypes.isNotEmpty &&
  //           dishBloc.state.dishTypeState == BlocState.loadCompleted)
  //         AppPopupMenuButton<DishTypeModel>(
  //           onChanged: (value) {
  //             setState(() {
  //               _selectedFilter = value;
  //               currentPage = 1;
  //             });
  //             _requestService(
  //               type: _selectedFilter.dishTypeId,
  //               priceOrder: _selectedPriceOrder,
  //             );
  //           },
  //           filterItemBuilder: (context, e) {
  //             return DropdownMenuItem<DishTypeModel>(
  //               value: e,
  //               child: Text(e.type),
  //             );
  //           },
  //           items: dishBloc.state.dishTypes,
  //           value: _selectedFilter,
  //           child: Text(
  //             _selectedFilter.type,
  //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                   fontSize: 14,
  //                   color: Colors.white,
  //                 ),
  //           ),
  //         ),
  //       SizedBox(
  //         width: kDefaultPadding,
  //       ),
  //       Text(
  //         "Giá: ",
  //         style: Theme.of(context).textTheme.bodyLarge,
  //       ),
  //       AppPopupMenuButton<OrderEnum>(
  //         onChanged: (value) {
  //           setState(() {
  //             _selectedPriceOrder = value;
  //             currentPage = 1;
  //           });
  //           _requestService(
  //             type: _selectedFilter.dishTypeId,
  //             priceOrder: _selectedPriceOrder,
  //           );
  //         },
  //         filterItemBuilder: (context, e) {
  //           return DropdownMenuItem<OrderEnum>(
  //             value: e,
  //             child: Text(e.name),
  //           );
  //         },
  //         items: OrderEnum.allOrderEnum(),
  //         value: _selectedPriceOrder,
  //         child: Text(
  //           _selectedPriceOrder.name,
  //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                 fontSize: 14,
  //                 color: Colors.white,
  //               ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Future<void> _onRefresh() async {
    await _requestService();
  }

  Future<bool> _addNewDish(DishTypeModel dishType) async {
    if (_nameController.text.trim().isEmpty ||
        _unitController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      addNewDishValidateText = "Tên, giá, đơn vị tính là bắt buộc";
      return true;
    }
    addNewDishValidateText = "";
    ResultModel result = await Api.addDish(
      name: _nameController.text,
      description: _descriptionController.text,
      image: _imageController.text,
      isDrink: false,
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
    return false;
  }

  // void _openDialogAddNewDish() {
  //   DishTypeModel selectedFilter2 = dishBloc.state.dishTypes.sublist(1)[0];
  //   bool isShow = false;
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext ct) {
  //       return StatefulBuilder(builder: (context, newState) {
  //         return AppDialogInput(
  //           title: "Thêm món mới",
  //           buttonDoneTitle: "Tạo",
  //           buttonCancelTitle: "Thoát",
  //           onDone: () async {
  //             isShow = await _addNewDish(selectedFilter2);
  //             newState(() {});
  //           },
  //           onCancel: () {
  //             context.pop();
  //           },
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(bottom: 5),
  //                 child: Text(
  //                   "Tên món",
  //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                         fontSize: 16,
  //                       ),
  //                 ),
  //               ),
  //               AppInput2(
  //                 name: "name",
  //                 keyboardType: TextInputType.name,
  //                 controller: _nameController,
  //                 placeHolder: "Điền tên món",
  //                 focusNode: _nameFocusNode,
  //               ),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 10, bottom: 5),
  //                           child: Text(
  //                             "Giá món(VNĐ)",
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .bodyMedium
  //                                 ?.copyWith(
  //                                   fontSize: 16,
  //                                 ),
  //                           ),
  //                         ),
  //                         AppInput2(
  //                           name: "price",
  //                           keyboardType: TextInputType.number,
  //                           controller: _priceController,
  //                           placeHolder: "Nhập giá món(VNĐ)",
  //                           focusNode: _priceFocusNode,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: kPadding15,
  //                   ),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 10, bottom: 5),
  //                           child: Text(
  //                             "Đơn vị tính",
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .bodyMedium
  //                                 ?.copyWith(
  //                                   fontSize: 16,
  //                                 ),
  //                           ),
  //                         ),
  //                         AppInput2(
  //                           name: "price",
  //                           keyboardType: TextInputType.name,
  //                           controller: _unitController,
  //                           placeHolder: "Ex: phần, dĩa, ly...",
  //                           focusNode: _unitFocusNode,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: kPadding10,
  //                   ),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 10, bottom: 5),
  //                           child: Text(
  //                             "Loại món",
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .bodyMedium
  //                                 ?.copyWith(
  //                                   fontSize: 16,
  //                                 ),
  //                           ),
  //                         ),
  //                         AppPopupMenuButton<DishTypeModel>(
  //                           height: 45,
  //                           value: selectedFilter2,
  //                           onChanged: (value) {
  //                             newState(() {
  //                               selectedFilter2 = value;
  //                             });
  //                           },
  //                           items: dishBloc.state.dishTypes.sublist(1),
  //                           filterItemBuilder: (context, label) {
  //                             return DropdownMenuItem<DishTypeModel>(
  //                               value: label,
  //                               child: Text(label.type),
  //                             );
  //                           },
  //                           child: Text(
  //                             selectedFilter2.type,
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .bodyMedium
  //                                 ?.copyWith(
  //                                   fontSize: 14,
  //                                   color: Colors.white,
  //                                 ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 10, bottom: 5),
  //                 child: Text(
  //                   "Mô tả",
  //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                         fontSize: 16,
  //                       ),
  //                 ),
  //               ),
  //               AppInput2(
  //                 name: "description",
  //                 keyboardType: TextInputType.name,
  //                 controller: _descriptionController,
  //                 placeHolder: "Thêm mô tả(tùy chọn)",
  //                 focusNode: _descriptionFocusNode,
  //                 maxLines: 2,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 10, bottom: 5),
  //                 child: Text(
  //                   "Link ảnh",
  //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                         fontSize: 16,
  //                       ),
  //                 ),
  //               ),
  //               AppInput2(
  //                 name: "image",
  //                 keyboardType: TextInputType.name,
  //                 controller: _imageController,
  //                 placeHolder: "Url ảnh(tùy chọn)",
  //                 focusNode: _imageFocusNode,
  //               ),
  //               if (isShow)
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 10, bottom: 5),
  //                   child: Text(
  //                     addNewDishValidateText,
  //                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                           fontSize: 14,
  //                           color: Colors.red,
  //                         ),
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  SliverPersistentHeader _makeHeaderFilter(BuildContext context) {
    var authState = context.select((AuthenticationBloc bloc) => bloc.state);
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
              // _buildTopFilter(context),
              Row(
                children: [
                  if (authState is AuthenticationSuccess &&
                      UserRepository.userModel.isManager)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(kCornerSmall),
                        onTap: () {
                          // _openDialogAddNewDish();
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
      create: (context) => serviceBloc,
      child: BlocListener<ServiceBloc, ServiceState>(
        // listenWhen: (previous, current) {
        //   if (previous.dishTypeState == BlocState.loading &&
        //       current.dishTypeState == BlocState.loadCompleted) {
        //     return true;
        //   }
        //   return false;
        // },
        listener: (context, state) {
          // setState(() {
          //   _selectedFilter = state.dishTypes[0];
          // });
        },
        child: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            bool isLoading = state.serviceState == BlocState.loading;
            return Scaffold(
              backgroundColor: backgroundColor,
              body: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      _makeHeaderFilter(context),
                      if (state.serviceState == BlocState.loadCompleted ||
                          state.serviceState == BlocState.loading)
                        SliverPadding(
                          padding: EdgeInsets.all(kPadding10),
                          sliver: SliverGrid.builder(
                            itemCount: state.services.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300.0,
                              mainAxisSpacing: 20.0,
                              crossAxisSpacing: 20.0,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return ServiceItem(
                                item: state.services[index],
                              );
                            },
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: Visibility(
                          visible: state.serviceState == BlocState.noData,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}