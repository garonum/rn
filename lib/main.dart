import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.green,
        ),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
        //primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Луч Земли'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;
// типы компиляции
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> title = ["Луч Земли","Луч Человека","Луч Возврата","Луч Выхода","Итог"];
  int _selectedIndex = 0;
  List<List<String>> revertNumbersOfSlices =[['4','3','2','1'],['6','5','4','3','2','1',],['7','6','5','4','3','2','1',],['1','2','3','4','5','6','7','8','9']];
  List<List<List<String>>> data = [
    [
      ["Фрукты, ягоды, сметана","Звёздный План","Будущее"],
      ["Овощи, сливочное масло","План Солнца","Настоящее"],
      ["Растительный белок, растительное масло","План Человека","Прошлое"],
      ["Белок (рыба, морепродукты), рыбий жир","План Земли","Подсказки"]
    ],[
      ["Взбитое, отжатое, замороженное","Закон разума","Знаки"],
      ["Пареное","Закон отображения","Подсветки"],
      ["Варёное","Закон отражения","Подсказки"],
      ["Печёное","Закон выхода-возврата","Причины"],
      ["Гриль, копчёное","Закон легализации","Процессы"],
      ["Жареное","Закон замещения","Следствия"]
    ],[
      ["Семена","плат эффект","ЫЙИ-нить"],
      ["Зёрна","Плат Вселенский","Ритмологический рисунок из ЫЙИ"],
      ["Плоды","Плат Знаний","Книга «Озаригн»"],
      ["Цветы, мёд","Плат Любви","Книга «Радастея»"],
      ["Листья","Плат Славы","Книга «ИРЛЕМ»"],
      ["Стебель","Плат Денег","Ритмический рисунок из ЫЙИ"],
      ["Корень","Плат Стыда","ЫЙИ"]
    ],[
      ["Чистая вода","План Оси",""],
      ["Газированная вода (естественная газация)","План Знакоряда",""],
      ["Газированные напитки (искуственная газация)","План Обновления",""],
      ["Заваренное кипятком (чай, кофе, кисель)","План Озаригн",""],
      ["Соки","Плотный План",""],
      ["Варёное в воде (компот), сыворотка","План Кристаллии",""],
      ["Молоко всех видов","План Кораллнеи",""],
      ["Морс, квас","План Звездолёта",""],
      ["Кисломолочные, йогурт","План Полёта",""]
    ]
  ];

  var getTime = ["от получения продукта(из земли, воды итд)",
    "от приготовления",
    "от появления желания",
    "от приготовления напитка"];


  void _onItemTapped(int index) async{
    //переключение между лучами
    // int index  = this.handler.getSelectedIndex();
     _selectedIndex = index;
   // await
    setState(()  {
       this.handler.setIndex(index);
    });
  }


  setStateOfSlice(int index, int row, Slice slice, int selectedIndex){
    // выбор среза

    //print(slice.selectedSlice);
    slice.selectedSlice = row+1;
    this.handler.updateSlice(slice, selectedIndex);

  }

  saveIntervals(int index, String? interval, Slice slice,int selectedIndex){
    //запись выбранного интервала в базу
    slice.selectedInterval = interval!;
    this.handler.updateSlice(slice, selectedIndex);
  }
  getChildrens(int index,AsyncSnapshot<List<dynamic>> snapshot){
    //собирает срезы и интервалы на основе полученных из бд данных
    // возвращает все срезы  и интервалы в  виде списка контейнеров
    List<Container> x = [];
 //int selectedIndex = 0;
     var str = <String>[getTime[snapshot.data![2][0]],
      "От 1 с - до 5 мин",
      "От 5 мин - до 20 мин",
      "От 20 мин - до 1 ч",
      "От 1 ч - до 2 ч",
      "От 2 ч - до 6 ч",
      "От 6 ч - до 24 ч",
      "От 1 дня - до 2 дней",
      "От 2 дней - до 5 дней",
      "От 5 дней - до 7 дней",
      "От 1 недели - до 1 месяца",
      "От 1 месяца - до 6 мес.",
      "От 6 мес - до 12 мес",
      "более года"];

    //(snapshot.data![0]![index].selectedInterval);
    var d = Container(height: 77,
        color: Colors.blue,
        child: DropdownButton<String>(
          isExpanded: true,
          value: snapshot.data![0]![index].selectedInterval,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          // underline: Container(
          //   height: 2,
          //   color: Colors.deepPurpleAccent,
          // ),
          onChanged: (String? newValue) async {
            await saveIntervals(index, newValue, snapshot.data![0]![index],snapshot.data![2][0]);
            setState(() {

            });
          },
          items:str
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(left:15), //apply padding to some sides only
                child: Text(value),
              ),
            );
          }).toList(),
        ));
    x.insert(x.length, d);


    for (int i = 0; i < data[snapshot.data![2][0]].length; i++){

      var s = false;

      if (i+1 == snapshot.data![0]![index].selectedSlice){
        s = true;
      }


      x.insert(x.length, Container(

        height: 96,

        color: s ? Colors.yellow : Colors.blue,

        child: GestureDetector(
          onTap: () async {
            await setStateOfSlice(index, i, snapshot.data![0]![index],snapshot.data![2][0]);
            setState(() {

            });

          },
          child: CustomList(
            numberOfSlice: revertNumbersOfSlices[snapshot.data![2][0]][i].toString(),
            firstParametr: data[snapshot.data![2][0]][i][0],
            secondParametr: data[snapshot.data![2][0]][i][1],
            thirdParametr: data[snapshot.data![2][0]][i][2],
          ),
        )
      ));

    }

    return x;
  }


  raysPage(AsyncSnapshot<List<dynamic>> snapshot)  {
    //возвращает страницу с лучами
    return ListView.builder(
      itemCount:snapshot.data![0].length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.delete_forever),
          ),
          key: UniqueKey(),
          onDismissed: (DismissDirection direction) async {
            await this.handler.deleteSlice(snapshot.data![0][index].id!, snapshot.data![2][0]);

            setState(() {
              snapshot.data![0].remove(snapshot.data![0][index]);

            });
          },
          child: Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.headline4!.fontSize! * 1.1 + 395.0,
            ),
            padding: const EdgeInsets.all(18.0),
            //color: Colors.,
            alignment: Alignment.center,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: getChildrens(index, snapshot),//this.result[index],
            ),
          ),
        );
      },
    );
  }
 // var w;
getRes(AsyncSnapshot<List<dynamic>> snapshot) {
  //Возвращает страницу с результатами
  // Future<List> _futureOfList = handler.calculateResult();
  // List list = await _futureOfList;
  double width = 98;

  //w =
  if (snapshot.data != null){
    if (snapshot.data![1] != null){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: 158.0,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: width,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.public,
                  color: Colors.black,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                Text(snapshot.data![1]![0] != null ? snapshot.data![1]![0].toString() : "0"),
              ],
            ),
          ),
          Container(
            width: width,
            color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.accessibility_new,
                  color: Colors.black,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                Text(snapshot.data![1]![1] != null ? snapshot.data![1]![1].toString() : "0"),
              ],
            ),
          ),
          Container(
            width: width,
            color: Colors.yellow,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.undo,
                  color: Colors.black,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                Text(snapshot.data![1]![2] != null ? snapshot.data![1]![2].toString() : "0"),
              ],
            ),
          ),
          Container(
            width: width,
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.logout,
                  color: Colors.black,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                Text(snapshot.data![1]![3] != null ? snapshot.data![1]![3].toString() : "0"),
              ],
            ),
          ),
        ],
      ),
    );
}}
}


  late DatabaseHandler handler;
  late List<List<Container>> result = [];

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title[this.handler.getSelectedIndex()]),//Text(widget.title!),
      ),
      body: FutureBuilder(
        future: Future.wait([this.handler.retrieveSlices(this.handler.getSelectedIndex()), this.handler.calculateResult(), this.handler.getIndex()//Future that returns bool
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {

          if(snapshot.hasData){

            if(snapshot.data![2][0] == 4 ){
              return getRes(snapshot);

            }

            return raysPage(snapshot);
          }else {
            return Center(child: CircularProgressIndicator());
          }


        },
      ),
      floatingActionButton: Visibility(
        visible: this.handler.getSelectedIndex() != 4 ? true: false,
        child: FloatingActionButton(
          onPressed: ()  {
            //await
            setState(() {
              addSlices(this.handler.getSelectedIndex());
            });
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.public
              ),
              label: 'Земли',
              backgroundColor: Colors.blue
          ),BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            label: 'Человека',
              backgroundColor: Colors.blue
          ),BottomNavigationBarItem(
              icon: Icon(Icons.undo),
              label: 'Возврата',
              backgroundColor: Colors.blue
          ),BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Выхода',
              backgroundColor: Colors.blue
          ),BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Итог',
              backgroundColor: Colors.blue
          )
        ],
        currentIndex: _selectedIndex,//this.handler.getSelectedIndex(),
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<int> addSlices(selectedIndex) async {

    Slice firstSlice = Slice(selectedSlice: 0,selectedInterval: getTime[selectedIndex]);
    List<Slice> listOfSlices = [firstSlice];
    return await this.handler.insertSlice(listOfSlices, selectedIndex);

  }


}


class Slice {
  final int? id;
  int selectedSlice;
  String selectedInterval;

  Slice(
      { this.id,
        required this.selectedSlice,
        required this.selectedInterval
      });

  Slice.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        selectedSlice = res["selectedSlice"],
        selectedInterval = res["selectedInterval"];


  Map<String, Object?> toMap() {
    return {'id':id, 'selectedSlice': selectedSlice, 'selectedInterval': selectedInterval};
  }
}



class DatabaseHandler {
  static const rayname = ['RayOfEarth','RayOfHuman','RayOfReturn','RayOfExit',"Results"];
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'rn12.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE RayOfEarth(id INTEGER PRIMARY KEY AUTOINCREMENT, selectedSlice int, selectedInterval string)",
        );
        await database.execute(
          "CREATE TABLE RayOfHuman(id INTEGER PRIMARY KEY AUTOINCREMENT, selectedSlice int, selectedInterval string)",
        );
        await database.execute(
          "CREATE TABLE RayOfReturn(id INTEGER PRIMARY KEY AUTOINCREMENT, selectedSlice int, selectedInterval string)",
        );
        await database.execute(
          "CREATE TABLE RayOfExit(id INTEGER PRIMARY KEY AUTOINCREMENT,  selectedSlice int, selectedInterval string)",
        );
        await database.execute(
          "CREATE TABLE Results(id INTEGER PRIMARY KEY AUTOINCREMENT, RayOfEarth int NOT NULL,RayOfHuman int NOT NULL, RayOfReturn int NOT NULL, RayOfExit int NOT NULL)",
        );
      },


      version: 1,
    );
  }

  Future<int> insertSlice(List<Slice> slices, int _selectedIndex) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var slice in slices){
      result = await db.insert(rayname[_selectedIndex], slice.toMap());
    }
    return result;
  }

  Future<List<Slice>> retrieveSlices(int _selectedIndex) async {
    final Database db = await initializeDB();
    List<Map<String, Object?>> queryResult = await db.query(rayname[_selectedIndex]);
    // print(")(");
    // print(queryResult);
    // print(")(");
    return queryResult.map((e) => Slice.fromMap(e)).toList();

  }

  Future<void> deleteSlice(int id,int _selectedIndex) async {

    final db = await initializeDB();

    await db.delete(
      rayname[_selectedIndex],
      where: "id = ?",
      whereArgs: [id],
    );

    final List<Map<String, Object?>> queryResult = await db.query(rayname[_selectedIndex]);
    //   print(")(");
    // print(queryResult);
    //   print(")(");
  }


  updateSlice(Slice slice ,int _selectedIndex) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Update the given Dog.
    await db.update(
      rayname[_selectedIndex],
      slice.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [slice.id],
    );
    final List<Map<String, Object?>> queryResult = await db.query(rayname[_selectedIndex]);
   // print("++++++++");
  // print(queryResult);
    queryResult.map((e) => Slice.fromMap(e)).toList();

  }

   int getRayCoefficient(String rayName, int slice){

    final coefficientRayOfEarth = [27,20,14,7];

    final coefficientRayOfHuman = [27, 23, 18, 14, 9, 5];

    final coefficientRayOfReturn = [27, 24, 20, 16, 12, 8, 4];

    final coefficientRayOfExit = [27, 24, 21, 18, 15, 12, 9, 6, 3];

    switch(rayName){

      case 'RayOfEarth':

        return coefficientRayOfEarth[slice].toInt();
        break;
      case 'RayOfHuman':
        return coefficientRayOfHuman[slice].toInt();

        break;
      case 'RayOfReturn':
        return coefficientRayOfReturn[slice].toInt();
        break;
      case 'RayOfExit':
        return coefficientRayOfExit[slice].toInt();
        break;
      default:
        return 0;
    }
  }

  getIntervalCoefficient(String intetval){

    switch(intetval){
      case "от получения продукта(из земли, воды итд)":
      return 0;

      case "от приготовления":
      return 0;

      case "от появления желания":
      return 0;

      case "от приготовления напитка":
      return 0;

      case "От 1 с - до 5 мин":
        return 13;

      case "От 5 мин - до 20 мин":
        return 12;


      case "От 20 мин - до 1 ч":
        return 11;

    case "От 1 ч - до 2 ч":
    return 10;

    case "От 2 ч - до 6 ч":
    return 9;

    case "От 6 ч - до 24 ч":
    return 8;

    case "От 1 дня - до 2 дней":
    return 7;

    case "От 2 дней - до 5 дней":
    return 6;

    case "От 5 дней - до 7 дней":
    return 5;

    case "От 1 недели - до 1 месяца":
      return 4;

    case "От 1 месяца - до 6 мес.":
    return 3;

    case "От 6 мес - до 12 мес":
    return 2;

      case "более года":
        return 1;

      default:
        return 0;
    }
  }


   Future<List> calculateResult() async{
    final db = await initializeDB();
    List finalResult = [0,0,0,0];

    for (int i = 0; i < rayname.length-1; i++) {
      final List<Map<String, Object?>> queryResult = await db.query(rayname[i]);
      var x = queryResult.map((e) => Slice.fromMap(e)).toList();
      if (x.isNotEmpty){
        if (x.length > 0) {

          for (int e = 0; e < x.length; e++) {
              if(x[e].selectedSlice == 0){
                finalResult[i] = finalResult[i] + 0;
              }else{
                finalResult[i] = finalResult[i] +
                    (getRayCoefficient(rayname[i], x[e].selectedSlice.toInt()-1) *
                        getIntervalCoefficient(x[e].selectedInterval));

              }

          }
        }
      }

    }

  return finalResult;
  }
  int _selectedIndex = 0;
  Future<List> getIndex() async{
    List x = [_selectedIndex];
    return x;
  }
   int getSelectedIndex() {
    return _selectedIndex;

  }
  setIndex(int selectedIndex) async{
   // print(selectedIndex);
    _selectedIndex = selectedIndex;

  }

}
class _SliceDescription extends StatelessWidget {
  const _SliceDescription({
    required this.firstParametr,
    required this.secondParametr,
    required this.thirdParametr,

  });

  final String firstParametr;
  final String secondParametr;
  final String thirdParametr;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          firstParametr,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        Text(
          secondParametr,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),
        ),
        Text(
          thirdParametr,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class CustomList extends StatelessWidget {
  const CustomList({
    required this.numberOfSlice,
    required this.firstParametr,
    required this.secondParametr,
    required this.thirdParametr,

  });

  final String numberOfSlice;
  final String firstParametr;
  final String secondParametr;
  final String thirdParametr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 0.0),
                child: Center(
                child:CircleAvatar(
                  backgroundColor: const Color(0xff764abc),
                  child: Text(numberOfSlice),
                )
            )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _SliceDescription(
                  firstParametr: firstParametr,
                  secondParametr: secondParametr,
                  thirdParametr: thirdParametr,

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



