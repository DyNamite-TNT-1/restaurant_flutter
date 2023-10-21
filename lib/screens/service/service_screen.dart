import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/authentication/bloc.dart';
import 'package:restaurant_flutter/blocs/service/service_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/configs/user_repository.dart';
import 'package:restaurant_flutter/enum/bloc.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/client/client_service.dart';
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
  OrderEnum _selectedPriceOrder = OrderEnum.desc;
  int currentPage = 1;

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _priceController = TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  final TextEditingController _imageController = TextEditingController();
  final FocusNode _imageFocusNode = FocusNode();
  final TextEditingController _unitController = TextEditingController();
  final FocusNode _unitFocusNode = FocusNode();

  bool isShowaddNewServiceValidateText = false;
  String addNewServiceValidateText = "";

  @override
  void initState() {
    super.initState();
    _requestService(priceOrder: _selectedPriceOrder);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.clear();
    _priceController.clear();
    _imageController.clear();
    _unitController.clear();
    Api.cancelRequest(tag: tagRequestServices);
  }

  bool get isServiceClosed {
    return !mounted || serviceBloc.isClosed;
  }

  Future<void> _requestService({
    required OrderEnum priceOrder,
  }) async {
    if (!isServiceClosed) {
      serviceBloc.add(
        OnUpdateState(
          params: const {"serviceState": BlocState.loading},
        ),
      );
      tagRequestServices = Api.buildIncreaseTagRequestWithID("services");
      ResultModel result = await Api.requestListService(
        order: priceOrder,
        page: currentPage,
        tagRequest: tagRequestServices,
      );
      if (!isServiceClosed && result.isSuccess) {
        ClientServiceModel serviceModel =
            ClientServiceModel.fromJson(result.data);
        serviceBloc.add(
          OnLoadService(
            params: {
              "services": serviceModel.services,
              "currentPage": serviceModel.currentPage,
              "maxPage": serviceModel.maxPage,
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
          "Giá: ",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        AppPopupMenuButton<OrderEnum>(
          onChanged: (value) {
            setState(() {
              _selectedPriceOrder = value;
              currentPage = 1;
            });
            _requestService(
              priceOrder: _selectedPriceOrder,
            );
          },
          filterItemBuilder: (context, e) {
            return DropdownMenuItem<OrderEnum>(
              value: e,
              child: Text(e.name),
            );
          },
          items: OrderEnum.allOrderEnum(),
          value: _selectedPriceOrder,
          child: Text(
            _selectedPriceOrder.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }

  Future<void> _onRefresh() async {
    await _requestService(
      priceOrder: _selectedPriceOrder,
    );
  }

  Future<bool> _addNewService() async {
    if (_nameController.text.trim().isEmpty ||
        _unitController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      addNewServiceValidateText = "Tên, giá, đơn vị tính là bắt buộc";
      return true;
    }
    addNewServiceValidateText = "";
    ResultModel result = await Api.addService(
      name: _nameController.text.capitalize(),
      image: _imageController.text,
      unit: _unitController.text.capitalize(),
      price: _priceController.text,
    );
    if (result.isSuccess) {
      if (context.mounted) {
        Fluttertoast.showToast(
          msg: "Thêm dịch vụ thành công!",
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
        _priceController.text = "";
        _imageController.text = "";
        _unitController.text = "";
      }
    } else {
      Fluttertoast.showToast(
        msg: "Thêm dịch vụ thất bại!",
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

  void _openDialogAddNewService() {
    bool isShow = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ct) {
        return StatefulBuilder(builder: (context, newState) {
          return AppDialogInput(
            title: "Thêm dịch vụ mới",
            buttonDoneTitle: "Tạo",
            buttonCancelTitle: "Thoát",
            onDone: () async {
              isShow = await _addNewService();
              newState(() {});
            },
            onCancel: () {
              context.pop();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Tên dịch vụ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ),
                AppInput2(
                  name: "name",
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  placeHolder: "Điền tên dịch vụ",
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
                              "Giá dịch vụ(VNĐ)",
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
                            placeHolder: "Nhập giá dịch vụ(VNĐ)",
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
                            keyboardType: TextInputType.name,
                            controller: _unitController,
                            placeHolder: "Ex: chiếc, giờ, cái...",
                            focusNode: _unitFocusNode,
                          ),
                        ],
                      ),
                    ),
                  ],
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
                if (isShow)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      addNewServiceValidateText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                    ),
                  ),
              ],
            ),
          );
        });
      },
    );
  }

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
                      _openDialogAddNewService();
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
                          Text("Thêm dịch vụ"),
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
      create: (context) => serviceBloc,
      child: BlocListener<ServiceBloc, ServiceState>(
        listener: (context, state) {},
        child: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            bool isLoading = state.serviceState == BlocState.loading;
            currentPage = state.currentPage;
            return Scaffold(
              backgroundColor: backgroundColor,
              body: Stack(
                children: [
                  _makeHeaderFilter(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: CustomScrollView(
                      slivers: [
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
                  if (state.maxPage != 0)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: NumberPagination(
                        onPageChanged: (int pageNumber) {
                          setState(() {
                            currentPage = pageNumber;
                          });
                          _requestService(
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
