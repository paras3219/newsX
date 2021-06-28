import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_models.dart';
import 'package:news_app/views/article_view.dart';
import 'package:news_app/views/category_news.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
   
  List<CategoryModel> categories = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
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
        elevation: 0.0,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):
      SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 70.0,
                child: ListView.builder(
                  itemCount: categories.length, 
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                  return CategoryTile(
                    categories[index].imageUrl, 
                    categories[index].categoryName 
                  );
                }),
              ),
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

class CategoryTile extends StatelessWidget {
  final String imageUrl, categoryName;

  CategoryTile(
    this.imageUrl,
    this.categoryName,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CategoryNews(categoryName.toLowerCase())
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(imageUrl: imageUrl,width: 120,height: 60,fit: BoxFit.cover),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(categoryName, style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),),
            ),
          ],
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