import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/blocs/app_bloc.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/blocs/ui/ui_bloc.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/widgets/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loadingLogout = false;

  _openLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ct) {
        return AppDialogText(
          child: Text(
            'Bạn muốn đăng xuất?',
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(ct).textTheme.bodyMedium,
          ),
          onDone: () {
            Navigator.of(context).pop();
            setState(() {
              loadingLogout = true;
            });
            AppBloc.uiBloc.add(OnAddDish(params: const {"dishes": []}));
            AppBloc.authenticationBloc.add(OnAuthenticationLogout(
                timeout: 2,
                callback: () {
                  context.goNamed(RouteConstants.dashboard);
                }));
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: AppButton(
              "Đăng xuất",
              onPressed: () {
                _openLogoutDialog();
              },
              type: ButtonType.normal,
              loading: loadingLogout,
            ),
          ),
        ],
      ),
    );
  }
}
