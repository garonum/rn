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
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.purple)),
        //primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Луч Земли'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> title = ["Луч Земли","Луч Человека","Луч Возврата","Луч Выхода","Итог"];
  int _selectedIndex = 0;

  List<List<List<String>>> data = [
    [
      ["Фрукты, ягоды, сметана","Звездный План","Будущее"],
      ["Овощи, сливочное масло","План Солнца","Настоящее"],
      ["Растительный белок, растительное масло","План Человека","Прошлое"],
      ["Белок(Рыба, морепродукты), рыбий жир)","План Земли","Подсказки"]
    ],[
      ["Взбитое, отжатое, замороженное","Закон Разума","Знаки"],
      ["Пареное","Закон отображения","Подсветки"],
      ["Варёное","Закон отражения","Подсказки"],
      ["Печеное","Закон выхода-возврата","Причины"],
      ["Гриль, копченое","Закон легализации","Процессы"],
      ["Жареноое","Закон замещения","Следствия"]
    ],[
      ["Семена","Плат Эффект","ЫЙИ-нить"],
      ["Зерна","Плат Вселенский","Ритмологический рисунок из ЫЙИ"],
      ["Плоды","Плат Знаний","Книга Озаригн"],
      ["Цветы, мед","Плат Любви","Книга Радастея"],
      ["Листья","Плат Славы","Книга Ирлем"],
      ["Стебель","Плат Денег","Ритмический рисунок из ЫЙИ"],
      ["Корень","Плат Стыда","ЫЙИ"]
    ],[
      ["Чистая вода","План Оси",""],
      ["Газированная вода(естественная газация)","План знакоряда",""],
      ["Газированные напитки(искуственная газация)","План Обновления",""],
      ["Заваренное кипятком(чай,кофе,кисель)","План Озаригн",""],
      ["Соки","Плотный план",""],
      ["Вареное в воде(компот),сыворотка","План Кристаллии",""],
      ["Молоко всех видов","План Коралнеи",""],
      ["Морс квас","План Звездолета",""],
      ["Кисмолочные,йогурт","План полета",""]
    ]
  ];
  var getTime = ["от получения продукта(из земли, воды итд)",
    "от приготовления",
    "от появления желания",
    "от приготовления напитка"];


  void _onItemTapped(int index) async{
    //переключение между лучами
    _selectedIndex = index;
    //await updateresult();
    setState(() {
    });
  }


  setStateOfSlice(int index, int row, Slice slice){
    // выбор среза
    slice.selectedSlice = row+1;
    this.handler.updateSlice(slice, _selectedIndex);

  }
//   updateresult() async {
// //подготовка содержимого
//     this.result.clear();
//     var r =  await this.handler.retrieveSlices(_selectedIndex);
//
//     if (_selectedIndex != 4){
//       for (int i = 0; i < r.length; i++){
//         this.result.add(te(i+1,r[i].selectedSlice,r[i]));
//       }
//     }
//     if(_selectedIndex == 4){
//       getRes();
//     }
//
//   }
  saveIntervals(int index, String? interval, Slice slice){
    //запись выбранного интервала в базу
    slice.selectedInterval = interval!;
    this.handler.updateSlice(slice, _selectedIndex);
  }
  getChildrens(int index,AsyncSnapshot<List<Slice>> snapshot){
    //собирает срезы и интервалы на основе полученных из бд данных
    // возвращает все срезы  и интервалы в  виде списка контейнеров
    List<Container> x = [];

    var str = <String>[getTime[_selectedIndex],
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

    for (int i = 0; i < data[_selectedIndex].length; i++){

      var s = false;
      if (i+1 == snapshot.data![index].selectedSlice){
        s = true;
      }


      x.insert(x.length, Container(

        height: 96,

        color: s ? Colors.yellow : Colors.orange,

        child:  ListTile(
          selected: s,
          tileColor: Colors.white,
          //selectedTileColor: Colors.black,
          title: Container(

              padding: EdgeInsets.all(10),
              color: Colors.transparent,
              child:Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                verticalDirection: VerticalDirection.up,
                children: <Widget>[
                  Text(data[_selectedIndex][i][0],
                      textDirection: TextDirection.ltr),
                  Text(data[_selectedIndex][i][1],
                      textDirection: TextDirection.ltr),
                  Text(data[_selectedIndex][i][2],
                      textDirection: TextDirection.ltr),
                ],
              )
          ),
          onTap: () async {
            await setStateOfSlice(index, i, snapshot.data![index]);
            setState(() {

            });

          },
        ),
      ));

    }


    var d = Container(height: 77,
        color: Colors.blue,
        child: DropdownButton<String>(
          value: snapshot.data![index].selectedInterval,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) async {
            await saveIntervals(index, newValue, snapshot.data![index]);
            setState(() {

            });
          },
          items:str
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
    x.insert(x.length, d);
    return x;
  }

  raysPage(AsyncSnapshot<List<Slice>> snapshot)  {
    //возвращает страницу с лучами
    return ListView.builder(
      itemCount:snapshot.data?.length,
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
            await this.handler.deleteSlice(snapshot.data![index].id!, _selectedIndex);
            //await updateresult();
            setState(() {
              snapshot.data!.remove(snapshot.data![index]);

            });
          },
          child: Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.headline4!.fontSize! * 1.1 + 395.0,
            ),
            padding: const EdgeInsets.all(8.0),
            color: Colors.blue[600],
            alignment: Alignment.center,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: getChildrens(index, snapshot),//this.result[index],
            ),
          ),
        );
      },
    );
  }
  var w;
getRes() async {
  //Возвращает страницу с результатами
  Future<List> _futureOfList = handler.calculateResult();
  List list = await _futureOfList;
  double width = 98;
   w = Container(
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
               Text(list[0].toString()),
             ],
           ),
         ),
         Container(
           width: width,
           color: Colors.green,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children:  <Widget>[
               Icon(
                 Icons.accessibility_new,
                 color: Colors.black,
                 size: 24.0,
                 semanticLabel: 'Text to announce in accessibility modes',
               ),
               Text(list[1].toString()),
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
               Text(list[2].toString()),
             ],
           ),
         ),
         Container(
           width: width,
           color: Colors.orange,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children:  <Widget>[
               Icon(
                 Icons.logout,
                 color: Colors.black,
                 size: 24.0,
                 semanticLabel: 'Text to announce in accessibility modes',
               ),
               Text(list[3].toString()),
             ],
           ),
         ),
       ],
     ),
   );
}


  late DatabaseHandler handler;
  late List<List<Container>> result = [];

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title[_selectedIndex]),//Text(widget.title!),
      ),
      body: FutureBuilder(
        future: this.handler.retrieveSlices(_selectedIndex),
        builder: (BuildContext context, AsyncSnapshot<List<Slice>> snapshot) {

          if (snapshot.hasData) {
            //print(snapshot.data?.length);
              if(_selectedIndex == 4 ){
                return w;
              }

              return raysPage(snapshot);

          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Visibility(
        visible: _selectedIndex != 4 ? true: false,
        child: FloatingActionButton(
          onPressed: () async {
            await addSlices();
            setState(() {
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<int> addSlices() async {

    Slice firstSlice = Slice(selectedSlice: 0,selectedInterval: getTime[_selectedIndex]);
    List<Slice> listOfSlices = [firstSlice];
    return await this.handler.insertSlice(listOfSlices, _selectedIndex);

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
      join(path, 'rn6.db'),
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

    return queryResult.map((e) => Slice.fromMap(e)).toList();
    print(")(");
    print(queryResult);
    print(")(");
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
   print(queryResult);
    queryResult.map((e) => Slice.fromMap(e)).toList();

  }

   int getRayCoefficient(String rayName, int slice){

    final coefficientRayOfEarth = [7,14,20,27];

    final coefficientRayOfHuman = [5, 9, 14, 18, 23, 27];

    final coefficientRayOfReturn = [4, 8, 12, 16, 20, 24, 27];

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
      case "От 1 с - до 5 мин":
        return 13;
        break;
      case "От 5 мин - до 20 мин":
        return 12;

        break;
      case "От 20 мин - до 1 ч":
        return 11;
        break;
    case "От 1 ч - до 2 ч":
    return 10;
    break;
    case "От 2 ч - до 6 ч":
    return 9;
    break;
    case "От 6 ч - до 24 ч":
    return 8;
    break;
    case "От 1 дня - до 2 дней":
    return 7;
    break;
    case "От 2 дней - до 5 дней":
    return 6;
    break;
    case "От 5 дней - до 7 дней":
    return 5;
    break;
    case "От 1 недели - до 1 месяца":
      return 4;
      break;
    case "От 1 месяца - до 6 мес.":
    return 3;
    break;
    case "От 6 мес - до 12 мес":
    return 2;
    break;
      case "более года":
        return 1;
        break;
      default:
        return 0;
    }
  }


   Future<List> calculateResult() async{
    final db = await initializeDB();
    List finalResult = [0,0,0,0];

    for (int i = 0; i < rayname.length-1; i++){
      final List<Map<String, Object?>> queryResult = await db.query(rayname[i]);
      var x = queryResult.map((e) => Slice.fromMap(e)).toList();
      var d = x;
      if(d.length > 0 ){
        for (int e = 0; e < d.length; e++){
          finalResult[i] =  finalResult[i] +(getRayCoefficient(rayname[i], d[e].selectedSlice.toInt()-1) * getIntervalCoefficient(d[e].selectedInterval)).toInt();//выбранный интеррвал перемножает

        }
      }else{

      }

    }

  return finalResult;
  }
}
class RN{

}


