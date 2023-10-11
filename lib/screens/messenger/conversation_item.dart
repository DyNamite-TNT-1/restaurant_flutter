import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/models/client/client_conversation.dart';

class ConversationItem extends StatefulWidget {
  const ConversationItem({super.key, required this.item});
  final ClientConversationModel item;

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        right: kPadding10,
        left: kPadding10,
        top: kPadding10 / 2,
        bottom: kPadding10 / 2,
      ),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: kPadding10,
                top: kPadding10 / 2,
                bottom: kPadding10 / 2,
                right: kPadding10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.item.user!.userName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "6 giờ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: subTextColor,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: kPadding10 / 2,
                  ),
                  Text(
                    "Bạn: Sao em lại khóc?!!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subTextColor,
                        ),
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
