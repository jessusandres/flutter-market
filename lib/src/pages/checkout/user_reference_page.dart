import 'package:flutter/material.dart';
import 'package:gustolact/src/models/departaments_model.dart';
import 'package:gustolact/src/models/districts_model.dart';
import 'package:gustolact/src/models/provinces_model.dart';
import 'package:gustolact/src/options/payment_options.dart';
import 'package:gustolact/src/providers/steps_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';

class UserReferencePage extends StatefulWidget {
  @override
  _UserReferencePageState createState() => _UserReferencePageState();
}

class _UserReferencePageState extends State<UserReferencePage> {

  int _direction = 0;
  TextEditingController _textEditingController;

// _textEditingController = new TextEditingController( text: _userName );
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    final StepsProvider _stepsProvider = Provider.of<StepsProvider>(context);

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Text(
              'Datos de Pago:',
              style: AppTheme.caption.copyWith(fontSize: 20),
            ),
            Divider(
              color: AppTheme.primaryColor,
              thickness: 1.3,
            ),
            _PaymentOptions(size: size, stepsProvider: _stepsProvider),
            SizedBox(
              height: 10,
            ),
            Text(
              'Datos del Cliente:',
              style: AppTheme.caption.copyWith(fontSize: 20),
            ),
            Divider(
              color: AppTheme.primaryColor,
              thickness: 1.3,
            ),
            SizedBox(height: 10,),
            Row(
//              width: size.width,
              children: [
                Icon(Icons.map),
                SizedBox(width: 14,),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _direction,
                    items: [
                      DropdownMenuItem(
                        child: Text('Seleccione una dirección frecuente'),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Text('Direccion 1'),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text('Direccion 2'),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text('Direccion 3'),
                        value: 3,
                      ),
                    ],
                    onChanged: (int value) {
                      print(value);
                      setState(() {
                        _direction = value;
                      });
                    }),
                )],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
//               padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: TextField(
                maxLines: 1,
                // controller: _textEditingController,
                decoration: InputDecoration(
                  icon: Icon(Icons.place),
                  labelText: 'Dirección',
                  helperText: 'Dirección de entrega',
                ),
                onChanged: (String value) {
                  if (value.length > 0) {
                    // _setUserName(value);
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                // controller: _textEditingController,
                keyboardType: TextInputType.phone,
                maxLength: 9,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: 'Teléfono',
                  helperText: 'Telefono de contacto',
                ),
                onChanged: (String value) {
                  if (value.length > 0) {
                    // _setUserName(value);
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                // controller: _textEditingController,
                decoration: InputDecoration(
                  icon: Icon(Icons.swap_calls),
                  labelText: 'Referencia Domicilio',
                  helperText: 'Referencia de entrega',
                ),
                onChanged: (String value) {
                  if (value.length > 0) {
                    // _setUserName(value);
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Icon(Icons.directions),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _stepsProvider.departamentsStream,
                    builder: (BuildContext context, AsyncSnapshot<List<Departament>> asyncSnapShot) {

                      if(!asyncSnapShot.hasData) {
                        return DropdownButton(
                            isExpanded: true,
                            value: "0",
                            items: [
                              DropdownMenuItem(
                                child: Text('Departamento'),
                                value: "0",
                              )
                            ],
                            onChanged: (Object value) {
                            });
                      }else {

                        final departaments = asyncSnapShot.data;

                        final departamentsList = [
                          DropdownMenuItem(
                            child: Text('Seleccione Departamento'),
                            value: "0",
                          )
                        ];

                        departaments.forEach((element) {
                          departamentsList.add(
                              DropdownMenuItem(
                                child: Text(element.name),
                                value: element.ucode.toString(),
                              )
                          );
                        });

                        return DropdownButton(
                            isExpanded: true,
                            value: _stepsProvider.departamentSelected,
                            items: departamentsList,
                            onChanged: (String value) {
                              _stepsProvider.departamentSelected = value;
                            });
                      }

                    },

                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
//              width: size.width,
              children: [
                Icon(Icons.directions),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _stepsProvider.provincesStream,
                    builder: (BuildContext context, AsyncSnapshot<List<Province>> asyncSnapshot){
                      if(!asyncSnapshot.hasData) {
                        return DropdownButton(
                            isExpanded: true,
                            value: 0,
                            items: [
                              DropdownMenuItem(
                                child: Text('Provincia'),
                                value: 0,
                              ),
                            ],
                            onChanged: (int value) {
                            });
                      }else {
                        final provinces = asyncSnapshot.data;

                        final provincesList = [
                          DropdownMenuItem(
                            child: Text('Seleccione Provincia'),
                            value: "0",
                          )
                        ];

                        provinces.forEach((element) {
                          provincesList.add(
                              DropdownMenuItem(
                                child: Text(element.name),
                                value: element.ucode.toString(),
                              )
                          );
                        });

                        return DropdownButton(
                            isExpanded: true,
                            value: _stepsProvider.provinceSelected,
                            items: provincesList,
                            onChanged: (String value) {
                              _stepsProvider.provinceSelected = value;
                            });

                      }
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
//              width: size.width,
              children: [
                Icon(Icons.directions),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _stepsProvider.districtsStream,
                    builder: (BuildContext context, AsyncSnapshot<List<District>> asyncSnapshot){
                      if(!asyncSnapshot.hasData) {
                        return DropdownButton(
                            isExpanded: true,
                            value: 0,
                            items: [
                              DropdownMenuItem(
                                child: Text('Distrito'),
                                value: 0,
                              ),
                            ],
                            onChanged: (int value) {
                              print(value);
                              setState(() {
                                _direction = value;
                              });
                            });
                      }else {
                        final districts = asyncSnapshot.data;

                        final districtsList = [
                          DropdownMenuItem(
                            child: Text('Seleccione Distrito'),
                            value: "0",
                          )
                        ];

                        districts.forEach((element) {
                          districtsList.add(
                              DropdownMenuItem(
                                child: Text(element.name),
                                value: element.ucode.toString(),
                              )
                          );
                        });

                        return DropdownButton(
                            isExpanded: true,
                            value: _stepsProvider.districtSelected,
                            items: districtsList,
                            onChanged: (String value) {
                              _stepsProvider.districtSelected = value;
                            });
                      }
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Container(
              child: TextField(
                // controller: _textEditingController,
                maxLines: 2,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  icon: Icon(Icons.remove_red_eye),
                  labelText: 'Observacion',
                  helperText: 'Alguna observación para la entrega',
                ),
                onChanged: (String value) {
                  if (value.length > 0) {
                    // _setUserName(value);
                  }
                },
              ),
            ),
            SizedBox(
              height: 35,
            )
          ],
        ),
      ),
    );
  }
}

class _PaymentOptions extends StatelessWidget {
  const _PaymentOptions({
    Key key,
    @required this.size,
    @required StepsProvider stepsProvider,
  }) : _stepsProvider = stepsProvider, super(key: key);

  final Size size;
  final StepsProvider _stepsProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size.width * 0.40,
          child: RadioListTile(
              title: Text('Efectivo'),
              groupValue: _stepsProvider.paymentOptionSelected,
              value: PaymentOptions.efective,
              onChanged: (PaymentOptions value) {
                _stepsProvider.paymentOptionSelected = value;
              }),
        ),
        Container(
          width: size.width * 0.40,
          child: RadioListTile(
              title: Text('Tarjeta'),
              groupValue: _stepsProvider.paymentOptionSelected,
              value: PaymentOptions.card,
              onChanged: (PaymentOptions value) {
                _stepsProvider.paymentOptionSelected = value;
              }),
        ),
      ],
    );
  }
}

