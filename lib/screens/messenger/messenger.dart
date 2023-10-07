import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final double widthOfChatScreen = 500;

  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocus = FocusNode();

  List<String> messages = [
    "Sao em lại khóc!?! Nếu là anh, thì anh đã không để em như vậy.",
    "Sao em lại khóc!?! Nếu là anh, thì anh đã không để em như vậy. Sao em lại khóc!?! Nếu là anh, thì anh đã không để em như vậy.",
    "Về đây với anh.",
    "Nhớ nhé, không khóc, đợi anh qua!"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      clipBehavior: Clip.hardEdge,
      width: widthOfChatScreen,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(kCornerMedium),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: kPadding10,
                      left: kPadding10,
                      top: kPadding10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                          width: 30,
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
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(kPadding10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(kCornerNormal),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  messages[index % messages.length],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: kPadding10,
                                ),
                                Text("07/10/2023 - 20:29"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
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
    );
  }
}
