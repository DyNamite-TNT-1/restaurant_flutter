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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isMe = UserRepository.isMe(id: widget.message.userId) ? true : false;
    final String name = UserRepository.userModel.isManager
        ? widget.message.user?.userName ?? "User Name"
        : "Firestaurant";
    final Widget avatar = UserRepository.userModel.isManager
        ? Text(
            "LĐ",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                // fontSize: 16,
                ),
          )
        : Image.asset(
            Images.logoAppNoBg,
            width: 50,
            height: 50,
          );
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
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: primaryColor,
                    width: 1.5,
                  ),
                  color:
                      UserRepository.userModel.isClient ? null : Colors.amber),
              child: Center(
                child: avatar,
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
                color: isMe ? primaryColor : Color(0XFFE4E6EB),
                borderRadius: BorderRadius.circular(kCornerNormal),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: isMe ? Colors.white : Colors.black,
                        ),
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
