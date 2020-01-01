import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,

    //To use theme in whole platform theme use(tu)
    //tu-step01: put the attribute in ThemeData constructor
    theme: ThemeData(
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
      brightness: Brightness.dark,
    ),
    title: "Interest Calculator App",
    home: GetWidget()
  ));
}

class GetWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GetWidgetState();
  }
}

class _GetWidgetState extends State<GetWidget> {
  //vl-Step02: define a Globalkey type var
  var _formKey = GlobalKey<FormState>();

  var minPadding = 5.0;
  var currencies = ['Taka', 'Rupees', 'Dollars', 'Pounds'];

  //To get textfield value we need controller : value get text field(vgtf)
  //vgtf-Step01: Declare TextEdintingController type variable
  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  String setCurrency;

  //setCurrency = "Taka" or
  //If we want to get this value from the above String List ,currencies
  //then we have to use intState() method otherwise static keyword will
  //be needed. Simply,without Static keyword it will show error
  void initState() {
    setCurrency = currencies[0];
  }

  String display = "";

  @override
  Widget build(BuildContext context) {
    //tu-step02: To style the text accoring to theme define a variable
    TextStyle textStyle = Theme.of(context).textTheme.title;


    return Scaffold(
      appBar: AppBar(
        title: Text("Interest Calculator"),
      ),
      body: Form( //To use validation vl-step01: At Scaffold body place Form widget
          key: _formKey, //vl-Step03: put Globalkey type var in Form key
          child: Padding(
            padding: EdgeInsets.all(8),
            child:ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(top: minPadding, bottom: minPadding),

                    //vl-step04: use TextFormField instead of TextField
                    child: TextFormField(
                      //vl-step05:put a function to get your expected validation
                      validator: (String userInPrincipal){
                        if(userInPrincipal.isEmpty){
                          return "You must put principal value";
                        }
                        if(double.tryParse(userInPrincipal)==null){
                          return "You must input number.";
                        }
                        return null;
                      },

                      //vgtf-Step02: put a controller type variable
                      controller: principalController,
                      style: textStyle,
                      //tu-step03: put the TextStyle_var in style attribute
                      keyboardType: TextInputType.number,
                      //For decorate the input field
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15.0,
                        ),
                          labelText: "Principal",
                          hintText: "Enter principal e.g. 1200",
                          labelStyle: textStyle, //style according to theme
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: minPadding, bottom: minPadding),
                    child: TextFormField(
                      validator: (String userInPrincipal){
                        if(userInPrincipal.isEmpty){
                          return "You must put rate of interest";
                        }
                        if(double.tryParse(userInPrincipal)==null){
                          return "You must input number.";
                        }
                        return null;
                      },
                      controller: roiController,
                      keyboardType: TextInputType.number,
                      style: textStyle, //style according to theme
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0,
                          ),
                          labelText: "Rate Of Interest",
                          hintText: "In Percent",
                          labelStyle: textStyle, //style according to theme
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: minPadding, bottom: minPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                              validator: (String userInPrincipal){
                                if(userInPrincipal.isEmpty){
                                  return "You must put term";
                                }
                                if(double.tryParse(userInPrincipal)==null){
                                  return "Input number.";
                                }
                                return null;
                              },
                              controller: termController,
                              keyboardType: TextInputType.number,
                              style: textStyle, //style according to theme
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                    color: Colors.yellowAccent,
                                    fontSize: 15.0,
                                  ),
                                  labelText: "Term",
                                  hintText: "years e.g 2",
                                  labelStyle: textStyle, //style according to theme
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0))),
                            )),
                        Container(
                          width: minPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton(
                              items: currencies.map((String inputCurrencyItem) {
                                return DropdownMenuItem<String>(
                                  value: inputCurrencyItem,
                                  child: Text(inputCurrencyItem),
                                );
                              }).toList(),
                              onChanged: (String inValue) {
                                setState(() {
                                  setCurrency = inValue;
                                });
                              },
                              value: setCurrency,
                            ))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(top: minPadding, bottom: minPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color:
                            Theme.of(context).accentColor, //Color modify with theme
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              "Calculate",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              //Use setState() method to update action in every time
                              setState(() {
                                //vl-step06: put logic to execution in validation
                                if(_formKey.currentState.validate()){
                                display = _calculateTotalReturns();
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context)
                                .primaryColorDark, //Color modify with theme
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Reset",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          ),
                        )
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(top: minPadding, bottom: minPadding),
                    child: Text(
                      "$display",
                      textAlign: TextAlign.center,
                      style: textStyle,
                    )
                )
              ],
            ),
          )
      ),
    );


  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/interest.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(minPadding * 6),
    );
  }

  String _calculateTotalReturns() {
    //vgtf-Step03: to get the input String call : controller_var.text
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalReturn = principal + (principal * roi * term) / 100.0;
    String result =
        "After $term years your principal will be $totalReturn $setCurrency";
    return result;
  }

  void _reset() {
    principalController.text = "";
    roiController.text = "";
    termController.text = "";
    setCurrency = currencies[0];
    display = "";
  }
}
