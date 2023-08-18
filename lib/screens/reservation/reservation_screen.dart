import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/blocs/reservation/reservation_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/configs/user_repository.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/models/service/reservation.dart';
import 'package:restaurant_flutter/screens/reservation/widget/reservation_item.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final ReservationBloc _reservationBloc = ReservationBloc(ReservationState());
  String tagRequestReservations = "";
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _requestReservationList();
  }

  @override
  void dispose() {
    Api.cancelRequest(tag: tagRequestReservations);
    _reservationBloc.close();
    super.dispose();
  }

  bool get isServiceClosed {
    return !mounted || _reservationBloc.isClosed;
  }

  Future<void> _onRefresh() async {
    await _requestReservationList();
  }

  Future<void> _requestReservationList() async {
    if (!isServiceClosed) {
      _reservationBloc.add(
        OnUpdateState(
          params: const {"reservationState": BlocState.loading},
        ),
      );
      tagRequestReservations =
          Api.buildIncreaseTagRequestWithID("reservations");
      ResultModel result = await Api.requestAllReservation(
        status: "",
        order: OrderEnum.desc,
        page: currentPage,
        limit: 15,
        tagRequest: tagRequestReservations,
      );
      if (!isServiceClosed && result.isSuccess) {
        ReservationListModel reservationListModel =
            ReservationListModel.fromJson(result.data);
        _reservationBloc.add(
          OnLoadReservationList(
            params: {
              "reservations": reservationListModel.reservations,
              "currentPage": reservationListModel.currentPage,
              "maxPage": reservationListModel.maxPage,
            },
          ),
        );
      }
    }
  }

  Container _buildHeader(BuildContext context) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCornerSmall),
      ),
      child: Column(
        children: [
          Row(
            children: [
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
          SizedBox(
            height: kDefaultPadding,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "ID",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                width: kPadding10,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Ngày diễn ra",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                width: kPadding10,
              ),
              Expanded(
                flex: 1,
                child: Text("Số người",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              SizedBox(
                width: kPadding10,
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    "Trạng thái",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              SizedBox(
                width: kPadding10,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Ngày tạo yêu cầu",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                width: kPadding10,
              ),
              if (!UserRepository.userModel.isClient)
                Expanded(
                  flex: 2,
                  child: Text(
                    "Khách hàng",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              SizedBox(
                width: kPadding10 * 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var authState = context.select((AuthenticationBloc bloc) => bloc.state);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) {
        if (previous is Authenticating && current is AuthenticationSuccess) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        _onRefresh();
      },
      child: BlocProvider(
        create: (context) => _reservationBloc,
        child: BlocBuilder<ReservationBloc, ReservationState>(
          builder: (context, state) {
            return Scaffold(
              body: (authState is AuthenticationSuccess)
                  ? Stack(
                      children: [
                        _buildHeader(context),
                        Padding(
                          padding: const EdgeInsets.only(top: 120),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _reservationBloc
                                      .state.reservations.length,
                                  itemBuilder: (context, index) {
                                    return ReservationItem(
                                      item: _reservationBloc
                                          .state.reservations[index],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
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
                              _requestReservationList();
                            },
                            pageTotal: state.maxPage,
                            pageInit:
                                currentPage, // picked number when init page
                            colorPrimary: primaryColor,
                          ),
                        ),
                      ],
                    )
                  : NoDataFoundView(
                      message: "Vui lòng đăng nhập!",
                    ),
            );
          },
        ),
      ),
    );
  }
}
