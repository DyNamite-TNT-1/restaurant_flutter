import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/configs/user_repository.dart';
import 'package:restaurant_flutter/models/service/message.dart';
import 'package:restaurant_flutter/utils/utils.dart';

class MessageItem extends StatefulWidget {
  const MessageItem({
    super.key,
    required this.message,
  });

  final MessageDetailModel message;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  bool isMe = false;
  @override
  void initState() {
    super.initState();
    if (UserRepository.isMe(id: widget.message.userId)) {
      isMe = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: kPadding10,
        left: kPadding10,
        top: kPadding10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
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
              margin: EdgeInsets.only(
                  left: isMe ? kDefaultPadding * 3 : 0,
                  right: !isMe ? kDefaultPadding * 4 : 0),
              padding: EdgeInsets.all(
                kPadding10,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(kCornerNormal),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: kPadding10,
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(widget
                        .message.createdAt
                        .toDateTime()
                        .add(Duration(hours: 7))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
