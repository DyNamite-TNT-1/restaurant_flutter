import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';

class AppPagination extends StatefulWidget {
  const AppPagination({
    super.key,
    required this.maxPage,
    required this.currentPage,
    required this.onChanged,
  });
  final int maxPage;
  final int currentPage;
  final Function(int) onChanged;

  @override
  State<AppPagination> createState() => _AppPaginationState();
}

class _AppPaginationState extends State<AppPagination> {
  late int currentPage;
  @override
  void initState() {
    super.initState();
    currentPage = widget.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              currentPage--;
            });
            widget.onChanged(currentPage);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        Text(
          "$currentPage",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: primaryColor,
              ),
        ),
        Text(
          " / ${widget.maxPage}",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              currentPage++;
            });
            widget.onChanged(currentPage);
          },
          icon: Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }
}
