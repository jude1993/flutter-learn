import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

///=>符号是Dart中单行函数或者方法的简写
void main() => runApp(MyApp());

///Widget的主要工作是提供一个build()方法来描述如何根据其他较低级别的widget
///来显示自己

///继承statelessWidget,将会使应用本身也成为了一个widget
///在Flutter中大多数东西都是Widget 包括对齐填充和布局
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      ///主题
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWords(),
    );



    //随机单词生成类
    //final wordPair = new WordPair.random();

    /*///material 是一种标准的移动端和web端的视觉设计语言
    return MaterialApp(
      ///标题
      title: 'Welcome to Flutter',
      ///Scaffold 是material library 中提供的一个widget, 它提供了磨人的导航栏
      ///标题和包括主屏幕widget树的body属性。widget树可以很复杂
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
          //child: new Text('Hello World'),
          //child: new Text(wordPair.asPascalCase),
          child: new RandomWords(),
        ),
      ),
    );*/
  }
}
///随机单词类
class RandomWords extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return new RandomWordsState();
  }

}

///随机单词状态类
class RandomWordsState extends State<RandomWords>{

  ///集合
  final _suggestions = <WordPair>[];

  ///字体
  final _biggerFont = const TextStyle(fontSize: 18.0);

  ///
  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    //final wordPair = new WordPair.random();
    //return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        ///某些widget属性需要单个Widget(child),而其它一些属性,如action,需要一组
          ///widgets(children),用方括号[]表示
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ]
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions(){
    return new ListView.builder(
      padding: const EdgeInsets.all(10.0),

      //对于每个建议单词对都会调用一次itemBuilder,然后将单词添加到ListView中
      //在偶数行,该函数回味单词对添加一个ListTile row
        //在奇数行该函数会添加一个分割线widget，来分隔相邻的词对
        //小屏幕上，分割线看不出来
      itemBuilder: (context, i){
        //在每一列之前，添加一个1像素高的分割线widget
        if(i.isOdd) return new Divider();

        //语法 i~/2 表示 i除以2，返回值向下取整
        final index = i ~/ 2;

        if(index >= _suggestions.length){
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  ///生成单词
  Widget _buildRow(WordPair pair){

    final alreadSaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadSaved ? Icons.favorite : Icons.favorite_border,
        color: alreadSaved ? Colors.red : null,
      ),

      onTap: (){
        ///在Flutter的响应式风格框架中,调用setState()会为state对象触发
        ///build()方法,从而导致对UI的更新
        setState((){
          if(alreadSaved){
            _saved.remove(pair);
          }else {
            _saved.add(pair);
          }
        });
      }
    );
  }

  ///当用户点击导航栏中的列表图表时,建立一个路由并将其推入到导航管理器栈中
  ///此操作会切换页面以显示新的路由
  void _pushSaved(){
    ///添加Navigator.push调用，这会使路由入栈(以后路由入栈指推入到导航管理器的栈)
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context){
          final tiles = _saved.map(
              (pair) {
                return new ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              }
          );
          final divided = ListTile
              .divideTiles(
                tiles: tiles,
                context: context,
              ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        }

      ),
    );
  }
}





























