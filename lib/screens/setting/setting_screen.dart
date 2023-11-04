import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/utils/utils.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Widget _buildChangeLanguage(BuildContext context) {
    String currentLang = AppLanguage.currentLanguage?.languageCode ??
        Localizations.localeOf(context).languageCode;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCornerSmall),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(kCornerSmall),
          onTap: () {
            context.goNamed(RouteConstants.settingLanguage,
                extra: {"initLangCode": currentLang});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(kPadding10),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(kPadding10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kCornerMedium),
                        color: primaryColor,
                      ),
                      child: SvgPicture.asset(
                        AssetImages.icLanguage,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: kPadding10,
                    ),
                    Text(
                      Translate.of(context).translate('change_language'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                child: Text(
                  Translate.of(context)
                      .translate("change_language_description"),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Divider(
                thickness: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    UtilLanguage.getGlobalLanguageName(
                      currentLang,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  SizedBox(
                    width: kPadding10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GridView(
              padding: EdgeInsets.all(kDefaultPadding),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 140,
                maxCrossAxisExtent: 300,
              ),
              children: [
                _buildChangeLanguage(context),
              ],
            ),
          )
        ],
      ),
    );
  }
}
