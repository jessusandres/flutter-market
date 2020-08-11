import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

//String urlStore = 'GustoLact';
String urlStore = 'redmarket';

//String storeName = 'GUSTOLACT';
String storeName = 'RedMarket';

String globalToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiYW5kcmV3IiwicGFzcyI6ImJsbW9udDEwIiwiaWQiOjIwMjAwM30.WwgI6w5rWu5yXdxuKFsPWhA-4pAl1XoyHVHcKVvjZZ8';

//String storeAvatar = 'https://www.redmovildenegocios.com/Mas7er/r3dmark3t/images_tiendas/1591462450_LogoGustoLact.png';
String storeAvatar = 'https://www.redmovildenegocios.com/Mas7er/r3dmark3t/images_tiendas/1590676995_LogoRedMarket1.png';

String storeUrlAPI = 'https://tuquepides.com/api/store/$urlStore';
//String storeUrlAPI = 'http://192.168.1.3:3100/store/$urlStore';

//String baseUrlAPI = 'http://192.168.1.3:3100';
String baseUrlAPI = 'https://tuquepides.com/api';

String publicCulquiKey  = 'pk_test_9fb7c16dc0ed24f5';

Pattern emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

