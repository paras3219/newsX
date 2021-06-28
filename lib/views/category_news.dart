import 'package:flutter/material.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/views/article_view.dart';

class CategoryNews extends StatefulWidget {
  
  final String category;
  CategoryNews(
    this.category
  );

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {

  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async{
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Flutter"),
            Text(
              "News", 
              style: TextStyle(
                color: Colors.blue
              ),
            ),
          ],
        ),
        actions: [
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.save),
            ),
          )
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body:  _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):
      SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: ListView.builder(
                  itemCount: articles.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context,index){
                    return BlogTile(
                      articles[index].urlToImage,
                      articles[index].title,
                      articles[index].description,
                      articles[index].url,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
   
  final String imageUrl, title, desc,url;

  BlogTile(
    this.imageUrl,
    this.title,
    this.desc,
    this.url
  ); 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ArticleView(url)
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(imageUrl,
                color: Colors.black.withOpacity(0.5),
                colorBlendMode: BlendMode.softLight,
                errorBuilder: (context, exception, stackTrace) {
                  return Image.asset("images/noimage.png");
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                title, 
                textAlign: TextAlign.center,
                style: TextStyle(
                  backgroundColor: Colors.black,
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // SizedBox(height: 5,),
            // Text(
            //   desc,
            //   textAlign: TextAlign.justify,
            //   style: TextStyle(
            //     color: Colors.black54,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}