import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final List<Widget> actions;
  final EdgeInsets margin;
  final Widget richText;

  final Widget inputWidget;

  CustomAlertDialog({
    @required this.title,
    this.body,
    this.actions,
    this.icon,
    this.margin,
    this.richText,
    this.inputWidget,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ColorsConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: margin ?? EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: Offset(0, 3),
                blurRadius: 16,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.getProportionateScreenWidth(24),
                  top: SizeConfig.getProportionateScreenWidth(24),
                  right: SizeConfig.getProportionateScreenWidth(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon != null
                        ? Padding(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.getProportionateScreenHeight(
                                    20)),
                            child: Icon(
                              icon,
                              color: ColorsConfig.primary,
                              size: 60,
                            ),
                          )
                        : SizedBox(),
                    Text(
                      title,
                      style: TextStyle(
                        color: ColorsConfig.primaryText,
                        fontSize: SizeConfig.getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: body != null ? 8 : 0),
                    body != null
                        ? Text(
                            body,
                            style: TextStyle(
                              color: ColorsConfig.primary,
                              fontSize:
                                  SizeConfig.getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : (richText != null)
                            ? richText
                            : SizedBox(),
                    inputWidget != null
                        ? Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: inputWidget,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
              Row(children: actions ?? [])
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAlertDialogButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroudColor;
  final Function onTap;
  final BorderRadius borderRadius;

  const CustomAlertDialogButton({
    this.text = "",
    this.textColor,
    this.backgroudColor,
    @required this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        child: Text(
          text ?? "",
          style: TextStyle(
            color: textColor ?? ColorsConfig.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        color: backgroudColor ?? Colors.white,
        padding: EdgeInsets.symmetric(vertical: 18),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        onPressed: text == null ? null : onTap,
      ),
    );
  }
}

class BonusOfferAlertDialog extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final List<Widget> actions;
  final EdgeInsets margin;

  final Widget inputWidget;

  BonusOfferAlertDialog({
    @required this.title,
    this.body,
    this.actions,
    this.icon,
    this.margin,
    this.inputWidget,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ColorsConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: margin ?? EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: Offset(0, 3),
                blurRadius: 16,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                      width: SizeConfig.getProportionateScreenHeight(50),
                      height: SizeConfig.getProportionateScreenHeight(50),
                      decoration: BoxDecoration(
                          color: Colors.yellow[700],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(40))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.getProportionateScreenWidth(10),
                          vertical: SizeConfig.getProportionateScreenHeight(10),
                        ),
                        child: Text("+1",
                            style: TextStyle(
                                color: ColorsConfig.background,
                                fontSize:
                                    SizeConfig.getProportionateScreenWidth(15),
                                fontWeight: FontWeight.w600)),
                      )),
                  SizedBox(width: 3),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.yellow[700],
                      fontSize: SizeConfig.getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: body != null ? 6 : 0),
              body != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        body,
                        style: TextStyle(
                          color: ColorsConfig.primary,
                          fontSize: SizeConfig.getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : SizedBox(),
              inputWidget != null
                  ? Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: inputWidget,
                    )
                  : SizedBox(),
              Row(children: actions ?? [])
            ],
          ),
        ),
      ),
    );
  }
}


/*
class CustomAlertDialogAlt extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final List<Widget> actions;
  final EdgeInsets margin;

  final Widget inputWidget;

  CustomAlertDialogAlt({
    @required this.title,
    this.body,
    this.actions,
    this.icon,
    this.margin,
    this.inputWidget,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ColorsConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: margin ?? EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: Offset(0, 3),
                blurRadius: 16,
              )
            ],
          ),
          child: Stack(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      width: SizeConfig.getProportionateScreenHeight(60),
                      height: SizeConfig.getProportionateScreenHeight(60),
                      decoration: BoxDecoration(
                          color: ColorsConfig.primary,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(40))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                SizeConfig.getProportionateScreenHeight(20)),
                        child: Icon(Coolicons.close_small,
                            color: ColorsConfig.white),
                      )),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.horizontal24,
                    top: SizeConfig.horizontal24,
                    right: SizeConfig.horizontal24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon != null
                          ? Padding(
                              padding: EdgeInsets.only(
                                  bottom: SizeConfig.vertical20),
                              child: Icon(
                                icon,
                                color: ColorsConfig.primary,
                                size: 60,
                              ),
                            )
                          : SizedBox(),
                      Text(
                        title,
                        style: TextStyle(
                          color: ColorsConfig.primaryText,
                          fontSize: SizeConfig.font18,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: body != null ? 8 : 0),
                      body != null
                          ? Text(
                              body,
                              style: TextStyle(
                                color: ColorsConfig.darkerSecondaryText,
                                fontSize: SizeConfig.font16,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : SizedBox(),
                      inputWidget != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: inputWidget,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.vertical30),
                Row(children: actions ?? [])
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class CustomerDataAlertDialog extends StatelessWidget {
  final Customer customer;
  final List<Widget> actions;
  final EdgeInsets margin;
  final int index;

  final Widget inputWidget;

  CustomerDataAlertDialog({
    this.actions,
    this.customer,
    this.margin,
    this.inputWidget,
    this.index = 0,
  });

  /// Fragments of [Widgets] separated from the Builder
  Widget _dataFragment(String quantity, String description, IconData icon) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                quantity,
                style: TextStyle(
                    color: ColorsConfig.primaryText,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          Text(
            description,
            style: TextStyle(
                fontSize: 10,
                color: ColorsConfig.primaryText,
                fontWeight: FontWeight.w400),
          )
        ]);
  }

  Widget _insights(
    AppLocalizations language,
  ) {
    return StoreConnector<AppState, CustomerStoreVM>(
      converter: (Store<AppState> store) => CustomerStoreVM.create(store),
      builder: (BuildContext context, CustomerStoreVM customerStoreVM) =>
          Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionateScreenWidth(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _dataFragment(index.toString(), language.translate("classificato"),
                Coolicons.qrcode_outline),
            Container(
              width: 1,
              height: SizeConfig.vertical16,
              color: ColorsConfig.secondaryText,
            ),
            _dataFragment(customer.points.toStringAsFixed(2),
                language.translate('punteggio'), Coolicons.qrcode_outline),
            Container(
              width: 1,
              height: SizeConfig.vertical16,
              color: ColorsConfig.secondaryText,
            ),
            _dataFragment(
                customer.usedOffersCount.toString(),
                language.translate('convalide'),
                Coolicons.calendar_event_outline),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ColorsConfig().init(context);
    AppLocalizations language = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: margin ?? EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: Offset(0, 3),
                blurRadius: 16,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                        width: SizeConfig.getProportionateScreenHeight(60),
                        height: SizeConfig.getProportionateScreenHeight(60),
                        decoration: BoxDecoration(
                            color: ColorsConfig.primary,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(40))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConfig.getProportionateScreenHeight(20)),
                          child: Icon(Coolicons.close_small,
                              color: ColorsConfig.white),
                        )),
                  ),
                ],
              ),
              Container(
                  width: SizeConfig.horizontal70,
                  height: SizeConfig.vertical70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      child: (customer.photoURL != null)
                          ? AvatarImageWidget(
                              imageUrl: customer.photoURL,
                              radius: SizeConfig.horizontal70 < 71
                                  ? SizeConfig.horizontal70
                                  : 70,
                              whiteBorderWidth: 0,
                            )
                          : SvgPicture.asset(
                              "assets/Illustrations/ProfileImages/User.svg"))),

              // User Profile
              Text(
                customer.displayName ?? "",
                style: TextStyle(
                  color: ColorsConfig.primaryText,
                  fontSize: SizeConfig.font18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                customer.status.toString(),
                style: TextStyle(
                  color: ColorsConfig.primaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: SizeConfig.vertical30),

              _insights(language),
              SizedBox(height: SizeConfig.vertical20)
            ],
          ),
        ),
      ),
    );
  }
}
*/