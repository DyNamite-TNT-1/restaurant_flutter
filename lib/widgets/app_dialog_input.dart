import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class AppDialogInput extends StatelessWidget {
  final Function? onDone;
  final Function onCancel;
  final Widget child;
  final String? title;
  final String? buttonDoneTitle;
  final String? buttonCancelTitle;
  final Color? buttonDoneColor;
  final Color? buttonCancelColor;

  const AppDialogInput({
    Key? key,
    required this.child,
    required this.onDone,
    required this.onCancel,
    this.buttonDoneTitle,
    this.buttonCancelTitle,
    this.title,
    this.buttonDoneColor,
    this.buttonCancelColor,
  }) : super(key: key);

  Widget buildTitle(BuildContext context) {
    if (title == null) {
      return Text('Notification',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center);
    } else {
      return Text(title!,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        backgroundColor: backgroundColor,
        content: Container(
          constraints: const BoxConstraints(
            minWidth: 200,
            maxWidth: 500,
            minHeight: 100,
            maxHeight: 500,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(context),
              SizedBox(
                height: kDefaultPadding,
              ),
              child,
              SizedBox(
                height: kDefaultPadding,
              ),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: onDone == null
                            ? null
                            : () {
                                onDone!();
                              },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) =>
                                  buttonDoneColor ??
                                  Theme.of(context).primaryColor),
                        ),
                        child: Center(
                          child: Text(
                            buttonDoneTitle ?? 'OK',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: kDefaultPadding / 2,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          onCancel();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => buttonCancelColor ?? Colors.red),
                        ),
                        child: Center(
                          child: Text(
                            buttonCancelTitle ?? 'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
