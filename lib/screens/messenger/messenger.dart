import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/authentication/bloc.dart';
import 'package:restaurant_flutter/blocs/messenger/messenger_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/client/client_conversation.dart';
import 'package:restaurant_flutter/models/service/message.dart';
import 'package:restaurant_flutter/screens/messenger/conversation_item.dart';
import 'package:restaurant_flutter/screens/messenger/message_item.dart';
import 'package:restaurant_flutter/utils/utils.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final MessengerBloc messengerBloc = MessengerBloc(MessengerState());

  final double widthOfMessengerTab = 800;
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocus = FocusNode();

  String tagRequestDetailConversation = "";

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  bool get isServiceClosed {
    return !mounted || messengerBloc.isClosed;
  }

  @override
  void dispose() {
    super.dispose();
    Api.cancelRequest(tag: tagRequestDetailConversation);
  }

  Future<void> _onRefresh() async {
    if (!isServiceClosed) {
      messengerBloc.add(OnLoadConversation(params: const {}));
    }
  }

  Container _buildTopBarConversation(
    BuildContext context,
  ) {
    MessengerState state = messengerBloc.state;
    return Container(
      padding: EdgeInsets.all(kPadding10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                    color: Colors.amber),
                child: Center(
                  child: Text("LĐ"),
                ),
              ),
              SizedBox(
                width: kPadding10,
              ),
              Text(
                state.selectedConversation?.user?.userName ?? "User Name",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          if (!(state.selectedConversation?.conversation?.acceptManager ??
              false))
            Row(
              children: [
                Text("Chấp nhận tin nhắn?"),
                SizedBox(
                  width: kPadding10 / 2,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      messengerBloc.add(OnAcceptConversation(params: const {}));
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                )
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
        create: (context) => messengerBloc,
        child: BlocListener<MessengerBloc, MessengerState>(
          listenWhen: (previous, current) {
            if (previous.acceptMessageSate == BlocState.loading &&
                (current.acceptMessageSate == BlocState.loadFailed ||
                    current.acceptMessageSate == BlocState.loadCompleted)) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            if (state.acceptMessageSate == BlocState.loadCompleted) {
              Fluttertoast.showToast(
                msg: Translate.of(context).translate(state.msg),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: primaryColor,
                textColor: Colors.white,
                fontSize: 16.0,
                webBgColor: successColorToast,
              );
            } else if (state.acceptMessageSate == BlocState.loadFailed) {
              Fluttertoast.showToast(
                msg: Translate.of(context).translate(state.msg),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: primaryColor,
                textColor: Colors.white,
                fontSize: 16.0,
                webBgColor: dangerColorToast,
              );
            }
          },
          child: BlocBuilder<MessengerBloc, MessengerState>(
            builder: (context, state) {
              return Container(
                width: widthOfMessengerTab,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kCornerMedium),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: (authState is AuthenticationSuccess)
                    ? IntrinsicHeight(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: kPadding10,
                              ),
                              width: 300,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: state
                                            .clientConversationModel.length,
                                        itemBuilder: (context, index) {
                                          final ClientConversationModel
                                              conversation =
                                              state.clientConversationModel[
                                                  index];
                                          return Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kCornerMedium),
                                              onTap: () {
                                                messengerBloc.add(
                                                    OnSelectConversation(
                                                        params: {
                                                      "selectedConversation":
                                                          conversation,
                                                    }));
                                              },
                                              child: ConversationItem(
                                                item: conversation,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              width: 0,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(kCornerMedium),
                                ),
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: state.messageState ==
                                              BlocState.loadCompleted ||
                                          state.messageState ==
                                              BlocState.noData,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildTopBarConversation(context),
                                          Divider(
                                            height: 0,
                                            color: Colors.grey,
                                          ),
                                          Expanded(
                                            child: state.messageState ==
                                                    BlocState.noData
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            kDefaultPadding),
                                                    child: NoDataFoundView(),
                                                  )
                                                : ListView.builder(
                                                    reverse: true,
                                                    shrinkWrap: true,
                                                    itemCount: state
                                                            .clientMessageModel
                                                            ?.messages
                                                            .length ??
                                                        0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final MessageDetailModel
                                                          message = state
                                                              .clientMessageModel!
                                                              .messages
                                                              .reversed
                                                              .toList()[index];
                                                      return MessageItem(
                                                          message: message);
                                                    }),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: AppInputMultiLine(
                                                    name: "message",
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    controller:
                                                        messageController,
                                                    focusNode: messageFocus,
                                                    placeHolder:
                                                        "Nhập tin nhắn",
                                                  ),
                                                ),
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {},
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              kPadding10),
                                                      child: Icon(
                                                        Icons.send,
                                                        size: 28,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: state.messageState ==
                                          BlocState.loading,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: NoDataFoundView(
                          message:
                              "Vui lòng đăng nhập để sử dụng tính năng nhắn tin!",
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
