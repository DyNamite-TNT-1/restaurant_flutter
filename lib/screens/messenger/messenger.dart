import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/blocs/messenger/messenger_bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/models/service/message.dart';
import 'package:restaurant_flutter/screens/messenger/conversation_item.dart';
import 'package:restaurant_flutter/screens/messenger/message_item.dart';
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
    if (!isServiceClosed) {
      messengerBloc.add(OnLoadConversation(
        params: const {
          "conversationId": 1,
        },
      ));
    }
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => messengerBloc,
      child: BlocBuilder<MessengerBloc, MessengerState>(
        builder: (context, state) {
          return Container(
            width: widthOfMessengerTab,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(kCornerMedium),
              border: Border.all(),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: kPadding10,
                      bottom: kPadding10,
                      left: kPadding10,
                    ),
                    width: 300,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: 15,
                              itemBuilder: (context, index) {
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.circular(kCornerMedium),
                                    onTap: () {},
                                    child: ConversationItem(),
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
                        borderRadius: BorderRadius.circular(kCornerMedium),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopBarConversation(context),
                          Divider(
                            height: 0,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                itemCount:
                                    state.conversation?.messages.length ?? 0,
                                itemBuilder: (context, index) {
                                  final MessageDetailModel message = state
                                      .conversation!.messages.reversed
                                      .toList()[index];
                                  return MessageItem(message: message);
                                }),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppInputMultiLine(
                                    name: "message",
                                    keyboardType: TextInputType.multiline,
                                    controller: messageController,
                                    focusNode: messageFocus,
                                    placeHolder: "Nhập tin nhắn",
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {},
                                  minWidth: 50,
                                  shape: CircleBorder(),
                                  color: Colors.green,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      kPadding10 / 2,
                                    ),
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container _buildTopBarConversation(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kPadding10),
      child: Row(
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
            "Lê Mậu Anh Đức",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
