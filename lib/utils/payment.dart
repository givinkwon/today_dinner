import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/stat_item.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SecondRoute extends StatefulWidget {
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  Payload payload = Payload();
  String _data = ""; // 서버승인을 위해 사용되기 위한 변수

  String get applicationId {
    return Bootpay().applicationId('61f5373ce38c30001f7b88d5',
        '61f5373ce38c30001f7b88d6', '61f5373ce38c30001f7b88d7');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bootpayAnalyticsUserTrace(); //통계용 함수 호출
    bootpayAnalyticsPageTrace(); //통계용 함수 호출
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Container(
          child: Center(
              child: TextButton(
            onPressed: () => goBootpayRequest(
                context, "danal", "", ['card', 'phone', 'vbank', 'bank']),
            // goBootpayRequest(context, "kcp", "npay", []),
            child: Text('부트페이 결제테스트'),
          )),
        );
      }),
    );
  }

  //통계용 함수
  bootpayAnalyticsUserTrace() async {
    String? ver;
    if (kIsWeb)
      ver =
          '1.0'; //web 일 경우 버전 지정, 웹이 아닌 android, ios일 경우 package_info 통해 자동으로 생성

    await Bootpay().userTrace(
        id: 'user_1234',
        email: 'user1234@gmail.com',
        gender: -1,
        birth: '19941014',
        area: '서울',
        applicationId: applicationId,
        ver: ver);
  }

  //통계용 함수
  bootpayAnalyticsPageTrace() async {
    String? ver;
    if (kIsWeb)
      ver =
          '1.0'; //web 일 경우 버전 지정, 웹이 아닌 android, ios일 경우 package_info 통해 자동으로 생성

    StatItem item1 = StatItem();
    item1.itemName = "미키 마우스"; // 주문정보에 담길 상품명
    item1.unique = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
    item1.price = 500; // 상품의 가격
    item1.cat1 = '컴퓨터';
    item1.cat2 = '주변기기';

    StatItem item2 = StatItem();
    item2.itemName = "키보드"; // 주문정보에 담길 상품명
    item2.unique = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
    item2.price = 500; // 상품의 가격
    item2.cat1 = '컴퓨터';
    item2.cat2 = '주변기기';

    List<StatItem> items = [item1, item2];

    await Bootpay().pageTrace(
        url: 'main_1234',
        pageType: 'sub_page_1234',
        applicationId: applicationId,
        userId: 'user_1234',
        items: items,
        ver: ver);
  }

  //결제용 데이터 init
  void goBootpayRequest(BuildContext context, String pg, String method,
      List<String> methods) async {
    // item 설정
    Item item1 = Item();
    item1.itemName = "미키 마우스"; // 주문정보에 담길 상품명
    item1.qty = 1; // 해당 상품의 주문 수량
    item1.unique = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
    item1.price = 500; // 상품의 가격

    Item item2 = Item();
    item2.itemName = "키보드"; // 주문정보에 담길 상품명
    item2.qty = 1; // 해당 상품의 주문 수량
    item2.unique = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
    item2.price = 500; // 상품의 가격
    List<Item> itemList = [item1, item2];

    // id 설정
    Payload payload = Payload();
    payload.webApplicationId = '61f5373ce38c30001f7b88d5'; // web application id
    payload.androidApplicationId =
        '61f5373ce38c30001f7b88d6'; // android application id
    payload.iosApplicationId = '61f5373ce38c30001f7b88d7'; // ios application id

    // pg 설정
    payload.pg = pg;
    payload.method = method;
    payload.methods = methods;
    payload.name = '테스트 상품';
    payload.price = 1000.0; //정기결제시 0 혹은 주석
    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
    payload.params = {
      "callbackParam1": "value12",
      "callbackParam2": "value34",
      "callbackParam3": "value56",
      "callbackParam4": "value78",
    };

    // user 설정
    User user = User();
    user.username = "사용자 이름";
    user.email = "user1234@gmail.com";
    user.area = "서울";
    user.phone = "010-4033-4678";
    user.addr = '서울시 동작구 상도로 222';

    // 결제 신청
    Bootpay().request(
      context: context,
      payload: payload,
      showCloseButton: false,
      // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onCancel: $data');
      },
      onClose: () {
        print('------- onClose');
        Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
        //TODO - 원하시는 라우터로 페이지 이동
      },
      onCloseHardware: () {
        print('------- onCloseHardware');
      },
      onReady: (String data) {
        print('------- onReady: $data');
      },
      onConfirm: (String data) {
        /**
        1. 바로 승인하고자 할 때
        return true;
        **/
        /***
        2. 비동기 승인 하고자 할 때
        checkQtyFromServer(data);
        return false;
        ***/
        /***
        3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
        return false; 후에 서버에서 결제승인 수행
         */
        checkQtyFromServer(data);
        return false;
      },
      onDone: (String data) {
        print('------- onDone: $data');
      },
    );
  }

  Future<void> checkQtyFromServer(String data) async {
    //TODO 서버로부터 재고파악을 한다
    print('checkQtyFromServer http call');

    //재고파악 후 결제를 승인한다. 아래 함수를 호출하지 않으면 결제를 승인하지 않게된다.
    Bootpay().transactionConfirm(data);
  }
}
