import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/blocs/bloc.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;

    return BlocListener<ApplicationBloc, ApplicationState>(
      listener: (context, state) {
        if (state is ApplicationSetupCompleted) {
          context.goNamed(RouteConstants.dashboard);
        }
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          height: double.maxFinite,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Center(
                child: Image.asset(
                  AssetImages.logoAppNoBg,
                  width: 350,
                  height: 350,
                ),
              ),
              SpinKitCircle(
                size: 70,
                color: color,
              ),
              
              SizedBox(
                height: 50,
              ),
              Text(
                Translate.of(context).translate('Loading common settings'),
                 style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
