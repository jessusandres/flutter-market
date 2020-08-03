import 'package:flutter/material.dart';
import 'package:gustolact/src/providers/numbers_provider.dart';
import 'package:gustolact/src/providers/steps_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/widgets/appbar_payment_widget.dart';
import 'package:provider/provider.dart';

import 'checkout/user_reference_page.dart';

class StepsPaymentPage extends StatefulWidget {
  @override
  _StepsPaymentPageState createState() => _StepsPaymentPageState();
}

class _StepsPaymentPageState extends State<StepsPaymentPage> {
  List _forms;

  @override
  Widget build(BuildContext context) {
    _forms = [
      UserReferencePage(),
      Step2Container(),
    ];

    return Scaffold(
        appBar: AppBarPayment(),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider<NumberProvider>(create: (_) => new NumberProvider(),),
            ChangeNotifierProvider<StepsProvider>(create: (_) => new StepsProvider(),),
          ],
          child: Builder(builder: (BuildContext context) {
            return Container(
              color: AppTheme.nearlyWhite,
              child: Column(
                children: [
                  _StepsContainer(ammount: _forms.length),
                  Expanded(
                    child: _PageViewSteps(forms: _forms),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}



class _PageViewSteps extends StatefulWidget {
  const _PageViewSteps({
    @required List forms,
  }) : _forms = forms;

  final List _forms;

  @override
  __PageViewStepsState createState() => __PageViewStepsState();
}

class __PageViewStepsState extends State<_PageViewSteps> {
  PageController _pageViewController = new PageController();

  @override
  void initState() {
    _pageViewController.addListener(() {
      Provider.of<NumberProvider>(context, listen: false).currentIndex =
          _pageViewController.page;
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void _nextFormStep() {
    _pageViewController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<bool> onWillPop() async {
    if (_pageViewController.page.round() == _pageViewController.initialPage) {
      return true;
    }
    _pageViewController.previousPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeInOutSine);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageViewController,
        physics: BouncingScrollPhysics(),
        itemCount: widget._forms.length,
        itemBuilder: (BuildContext context, int index) {
          return _willPopPage(page: widget._forms[index]);
        });
  }

  Widget _willPopPage({@required Widget page}) {
    return WillPopScope(
      onWillPop: this.onWillPop,
      child: page,
    );
  }
}

class Step2Container extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('2'),
      ),
    );
  }
}

class _StepsContainer extends StatelessWidget {
  final int ammount;

  const _StepsContainer({@required this.ammount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(ammount, (index) => _StepNumber(index: index)),
      ),
    );
  }
}

class _StepNumber extends StatelessWidget {
  final int index;

  const _StepNumber({@required this.index});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color textColor;

    double currentPage = Provider.of<NumberProvider>(context).currentIndex;

    if (currentPage >= index - 0.5 && currentPage < index + 0.5) {
      bgColor = AppTheme.primaryColor;
      borderColor = AppTheme.primaryColor;
      textColor = AppTheme.white;
    } else {
      bgColor = AppTheme.white;
      borderColor = AppTheme.primaryColor;
      textColor = AppTheme.primaryColor;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      height: 35,
      width: 35,
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: borderColor,
          )),
      child: Center(
          child: Text(
        (index + 1).toString(),
        style: TextStyle(color: textColor),
      )),
    );
  }
}
