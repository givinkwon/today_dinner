import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// appbar 지우기
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 그리드 뷰 이미지
    List<String> images = [
      "assets/main.jpg",
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(40, 40, 40, 1), //색변경
        ),
        backgroundColor: Colors.white,
        title: Text(
          "스크랩",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(40, 40, 40, 1)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Image(
                  image: AssetImage('assets/main.jpg'),
                  fit: BoxFit.cover,
                ),
              ),

              // 제품 제목
              Container(
                alignment: Alignment.topLeft,
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: "프레시지\n김밥만들기 세트\n10,800",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              // 상세 하단 경게선
              Container(child: Divider(color: Colors.grey, thickness: 2.0)),

              // 본문 이미지 1
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Image(
                  image: AssetImage('assets/main.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              // 본문 글 1
              Container(
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text:
                        "유찡이가 만든 된장찌게 예~이!\n유찡이가 만든 된장찌게 예~이!\n유찡이가 만든 된장찌게 예~이!\n유찡이가 만든 된장찌게 예~이!\n유찡이가 만든 된장찌게 예~이!\n",
                    style: TextStyle(
                      color: Color.fromRGBO(40, 40, 40, 1),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 본문 이미지 2
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Image(
                  image: AssetImage('assets/main.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              // 본문 글 2
              Container(
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text:
                        "유찡이가 만든 된장찌게 예~이!\n유찡이가 만든 된장찌게 예~이!\n유찡이가 만든 된장찌게 예~이!\n유찡이가 만든 된장찌게 예~이!\n유찡이가 만든 된장찌게 예~이!\n",
                    style: TextStyle(
                      color: Color.fromRGBO(40, 40, 40, 1),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // 상세 하단 경게선
              Container(child: Divider(color: Colors.grey, thickness: 2.0)),

              // 상세 하단 메뉴 1
              Container(
                margin: EdgeInsets.all(5.0),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: "리뷰 564",
                    style: TextStyle(
                      color: Color.fromRGBO(40, 40, 40, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 리뷰 평균 점수
              Container(
                margin: EdgeInsets.all(10.0),
                color: Colors.grey,
                child: Row(
                  children: <Widget>[
                    // 리뷰 평점
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text: "평균 평점",
                              style: TextStyle(
                                color: Color.fromRGBO(40, 40, 40, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    VerticalDivider(
                      thickness: 5,
                      width: 20,
                      color: Color.fromRGBO(40, 40, 40, 1),
                    ),

                    // 점수별 리뷰 분포
                    Expanded(
                      flex: 1,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: "평균 평점",
                          style: TextStyle(
                            color: Color.fromRGBO(40, 40, 40, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 리뷰 사진
              Container(
                height: 120.0,
                child: GridView.builder(
                  padding: EdgeInsets.all(5.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: 16,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // 제품 상세 페이지로 이동하기
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage()),
                        );
                      },
                      child: Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text("GridView $index"),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 상세 하단 경게선2
              Container(child: Divider(color: Colors.grey, thickness: 2.0)),

              // 상세 하단 메뉴 2
              Container(
                height: 120.0,
                child: GridView.builder(
                  padding: EdgeInsets.all(5.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: 16,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // 제품 상세 페이지로 이동하기
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage()),
                        );
                      },
                      child: Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text("GridView $index"),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          children: <Widget>[
            // 네비게이션바 메뉴 1
            Expanded(
              flex: 1,
              child: Align(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.grey,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
              ),
            ),
            // 네비게이션바 메뉴 2
            Expanded(
              flex: 1,
              child: Align(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.mediation,
                      color: Colors.grey,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
              ),
            ),
            // 간편식 모아보기 버튼
            Expanded(
              flex: 2,
              child: Align(
                child: Container(
                  color: Colors.grey,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "간편식 모아보기",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
