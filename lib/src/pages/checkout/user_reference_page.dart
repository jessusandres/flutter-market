import 'package:flutter/material.dart';
import 'package:gustolact/src/models/departaments_model.dart';
import 'package:gustolact/src/models/districts_model.dart';
import 'package:gustolact/src/models/provinces_model.dart';
import 'package:gustolact/src/models/user_addresses_model.dart';
import 'package:gustolact/src/providers/steps_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/widgets/divier_checkout_widget.dart';
import 'package:gustolact/src/widgets/title_checkout.dart';
import 'package:provider/provider.dart';

class UserReferencePage extends StatefulWidget {
  @override
  _UserReferencePageState createState() => _UserReferencePageState();
}

class _UserReferencePageState extends State<UserReferencePage> {
  @override
  Widget build(BuildContext context) {
    final StepsProvider _stepsProvider = Provider.of<StepsProvider>(context);

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleCheckout(title: 'Datos del Cliente:'),
            DividerCheckout(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(Icons.map),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _stepsProvider.userDirectionsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, Address>>>
                            asyncSnapshot) {
                      if (!asyncSnapshot.hasData) {
                        return DropdownButton(
                            isExpanded: true,
                            value: 0,
                            items: [
                              DropdownMenuItem(
                                child: Text('Direcciones frecuentes'),
                                value: 0,
                              ),
                            ],
                            onChanged: (int value) {});
                      } else {
                        final addresses = asyncSnapshot.data;

                        final addressesList = [
                          DropdownMenuItem(
                            child: Text('Seleccione una dirección frecuente'),
                            value: "00",
                          )
                        ];
                        addresses.forEach((element) {
                          element.forEach((key, value) {
                            addressesList.add(DropdownMenuItem(
                              child: Text(
                                  "${value.direction}-${value.departament} - ${value.province} - ${value.district} (${value.reference})"),
                              value: key,
                            ));
                          });
                        });

                        return Container(
                          child: DropdownButton(
                              isDense: false,
                              style: TextStyle(
                                color: AppTheme.nearlyBlack,
                              ),
                              isExpanded: true,
                              value: _stepsProvider.addressFrecuentlySelected,
                              items: addressesList,
                              onChanged: (String value) {
                                _stepsProvider.changeAddressFrecuently(value);
                              }),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
//               padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: TextField(
                maxLines: 1,
                controller: _stepsProvider.addressController,
                autofocus: false,
                decoration: InputDecoration(
                  errorText: _stepsProvider.addressEntered.error,
                  icon: Icon(Icons.place),
                  labelText: 'Dirección',
                  helperText: 'Dirección de entrega',
                ),
//                onChanged: _stepsProvider.changeAddress,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: _stepsProvider.phoneController,
                keyboardType: TextInputType.phone,
                autofocus: false,
                maxLength: 9,
                decoration: InputDecoration(
                  errorText: _stepsProvider.phoneEntered.error,
                  icon: Icon(Icons.phone),
                  labelText: 'Teléfono',
                  helperText: 'Telefono de contacto',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: _stepsProvider.referenceController,
                autofocus: false,
                decoration: InputDecoration(
                  errorText: _stepsProvider.referenceEntered.error,
                  icon: Icon(Icons.swap_calls),
                  labelText: 'Referencia Domicilio',
                  helperText: 'Referencia de entrega',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.directions,
                  color: (_stepsProvider.departamentSelected != '0')
                      ? Colors.grey
                      : Colors.redAccent,
                ),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _stepsProvider.departamentsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Departament>> asyncSnapShot) {
                      if (!asyncSnapShot.hasData) {
                        return DropdownButton(
                            isExpanded: true,
                            value: "0",
                            items: [
                              DropdownMenuItem(
                                child: Text('Departamento'),
                                value: "0",
                              )
                            ],
                            onChanged: (Object value) {});
                      } else {
                        final departaments = asyncSnapShot.data;

                        final departamentsList = [
                          DropdownMenuItem(
                            child: Text('Seleccione Departamento'),
                            value: "0",
                          )
                        ];

                        departaments.forEach((element) {
                          departamentsList.add(DropdownMenuItem(
                            child: Text(element.name),
                            value: element.ucode.toString(),
                          ));
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
                Icon(
                  Icons.directions,
                  color: (_stepsProvider.provinceSelected != '0')
                      ? Colors.grey
                      : Colors.redAccent,
                ),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _stepsProvider.provincesStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Province>> asyncSnapshot) {
                      if (!asyncSnapshot.hasData) {
                        return DropdownButton(
                            isExpanded: true,
                            value: 0,
                            items: [
                              DropdownMenuItem(
                                child: Text('Provincia'),
                                value: 0,
                              ),
                            ],
                            onChanged: (int value) {});
                      } else {
                        final provinces = asyncSnapshot.data;

                        final provincesList = [
                          DropdownMenuItem(
                            child: Text('Seleccione Provincia'),
                            value: "0",
                          )
                        ];

                        provinces.forEach((element) {
                          provincesList.add(DropdownMenuItem(
                            child: Text(element.name),
                            value: element.ucode.toString(),
                          ));
                        });

                        return DropdownButton(
                            isExpanded: true,
                            value: _stepsProvider.provinceSelected,
                            items: provincesList,
                            onChanged: (String value) {
                              _stepsProvider.changeProvince(value);
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
                Icon(
                  Icons.directions,
                  color: (_stepsProvider.districtSelected != '0')
                      ? Colors.grey
                      : Colors.redAccent,
                ),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _stepsProvider.districtsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<District>> asyncSnapshot) {
                      if (!asyncSnapshot.hasData) {
                        return DropdownButton(
                            isExpanded: true,
                            value: 0,
                            items: [
                              DropdownMenuItem(
                                child: Text('Distrito'),
                                value: 0,
                              ),
                            ],
                            onChanged: (int value) {});
                      } else {
                        final districts = asyncSnapshot.data;

                        final districtsList = [
                          DropdownMenuItem(
                            child: Text('Seleccione Distrito'),
                            value: "0",
                          )
                        ];

                        districts.forEach((element) {
                          districtsList.add(DropdownMenuItem(
                            child: Text(element.name),
                            value: element.ucode.toString(),
                          ));
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
                    _stepsProvider.changeObservation(value);
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
