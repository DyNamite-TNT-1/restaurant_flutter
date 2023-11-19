import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/routes/route_constants.dart';
import 'package:restaurant_flutter/screens/setting/components/setting_card.dart';
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
    return SettingCard(
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                  child: Text(
                    Translate.of(context)
                        .translate("change_language_description"),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
              Divider(
                thickness: 3,
                height: 0,
              ),
              Container(
                height: 30,
                padding: EdgeInsets.only(right: kPadding10),
                child: Row(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersion(BuildContext context) {
    return SettingCard(
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
                  child: Icon(
                    Icons.system_update_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: kPadding10,
                ),
                Text(
                  Translate.of(context).translate('version'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding10),
              child: Text(
                Translate.of(context).translate("version_description"),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          Divider(
            thickness: 3,
            height: 0,
          ),
          Container(
            height: 30,
            padding: EdgeInsets.only(right: kPadding10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "1.0.2",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ],
            ),
          ),
        ],
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
                _buildVersion(context),
              ],
            ),
          )
        ],
      ),
    );
  }
}
