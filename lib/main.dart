import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:rn/data.dart';

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
        useMaterial3: true,
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
  List<String> mealsName = [];
  List<String> title = Data.title;
  int _selectedIndex = 0;
  List<List<String>> revertNumbersOfSlices = Data.revertNumbersOfSlices;
  List<List<List<String>>> data = Data.data;
  var getTime = Data.getTime;

  void switchBetweenRays(int index) async {
    //переключение между лучами
    // int index  = this.handler.getSelectedIndex();
    _selectedIndex = index;
    await this.handler.retrieveSlices(_selectedIndex).then((result) {
      // loading = false;
      dataFromDB = result;
    });
    await this.handler.calculateResult().then((res) {
      finalResult = res;
    });
    setState(() {
      this.handler.setIndex(index);
    });
  }

  saveIntervals(String? interval, Slice slice, int selectedIndex) async {
    //запись выбранного интервала в базу
    slice.selectedInterval = interval!;
    await this.handler.updateSlice(slice, selectedIndex);
  }

  saveSlice(String? sliceNumber, Slice slice, int selectedIndex) async {
    //запись выбранного интервала в базу
    slice.selectedSlice = sliceNumber!;
    await this.handler.updateSlice(slice, selectedIndex);
  }

  saveMealName(String? mealName, Slice slice, int selectedIndex) async {
    //запись выбранного интервала в базу
    slice.mealName = mealName!;
    await this.handler.updateSlice(slice, selectedIndex);
  }

  getChildrensNew(int index, List<Slice> d) {
    //собирает срезы и интервалы на основе полученных из бд данных
    // возвращает все срезы  и интервалы в  виде списка контейнеров
    List<Widget> x = [];
    //int selectedIndex = 0;
    var _intervals = Data().getIntervals(_selectedIndex);
    var mealField = Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
          //apply padding to some sides only
          child: TextField(
            controller: TextEditingController(text: dataFromDB[index].mealName),
            decoration: new InputDecoration.collapsed(
              hintText: 'Название продукта',
            ),
            onSubmitted: (text) async {
              dataFromDB[index].mealName = text;
              await saveMealName(text, d[index], _selectedIndex);
              await this.handler.retrieveSlices(_selectedIndex).then((result) {
                // loading = false;
                dataFromDB = result;
              });
            },
          ),
        ));
    x.insert(x.length, mealField);
    x.insert(
        x.length,
        const SizedBox(
          height: 5,
        ));

    var intervals = Container(
      //height: 77,
      color: Colors.blue,
      child: DropdownMenu<String>(
        expandedInsets: EdgeInsets.zero,
        initialSelection: dataFromDB[index].selectedInterval,
        onSelected: (String? value) async {
          // This is called when the user selects an item.
          await saveIntervals(value, dataFromDB[index], _selectedIndex);
          await this.handler.retrieveSlices(_selectedIndex).then((result) {
            // loading = false;
            dataFromDB = result;
          });
          setState(() {
            //dropdownValue = value!;
          });
        },
        dropdownMenuEntries:
            _intervals.map<DropdownMenuEntry<String>>((String value) {
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
      ),
    );
    x.insert(x.length, intervals);
    x.insert(
        x.length,
        const SizedBox(
          height: 5,
        ));

    var i = 0;
    var slices = Container(
      color: Colors.blue,
      child: DropdownMenu<String>(
        expandedInsets: EdgeInsets.zero,
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
          gapPadding: 5,
        )),
        initialSelection: dataFromDB[index].selectedSlice,
        onSelected: (String? value) async {
          // This is called when the user selects an item.
          //dropdownValue = value!;
          // This is called when the user selects an item.
          await saveSlice(value, dataFromDB[index], _selectedIndex);
          await this.handler.retrieveSlices(_selectedIndex).then((result) {
            // loading = false;
            dataFromDB = result;
          });
          setState(() {
            setState(() {
              //dropdownValue = value!;
            });
          });
        },
        dropdownMenuEntries: Data.slicesData[_selectedIndex]
            .map<DropdownMenuEntry<String>>((String value) {
          if (value != "Указать срез") {
            i++;
          }

          return DropdownMenuEntry<String>(
              value: value,
              label: value,
              labelWidget: Row(
                children: [
                  value != "Указать срез"
                      ? Container(
                          child: CircleAvatar(
                            backgroundColor: Color(0xff764abc),
                            child: Text(i.toString()),
                          ),
                        )
                      : SizedBox(
                          width: 10,
                        ),
                  SizedBox(width: 5),
                  Text(value),
                ],
              ));
        }).toList(),
      ),
    );
    x.insert(x.length, slices);

    return x;
  }

  List<Widget> xx = [];

  // var w;
  getRes(Map<String, dynamic> result) {
    //Возвращает страницу с результатами
    // Future<List> _futureOfList = handler.calculateResult();
    // List list = await _futureOfList;
    double width = 98;
    List<TableCell> res = [];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      //height: 158.0,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: gC(),
      ),
    );
  }

  gC() {
    List<Widget> xxx = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const Icon(
                        Icons.public,
                        color: Colors.black,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      Text(finalResult['finalResult'][0].toString())
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                //width: width,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Icon(
                      Icons.accessibility_new,
                      color: Colors.black,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                    Text(finalResult['finalResult'][1].toString())
                  ],
                ),
              )),
              Expanded(
                child: Container(
                  //width: width,
                  color: Colors.yellow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const Icon(
                        Icons.undo,
                        color: Colors.black,
                        size: 24.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      Text(finalResult['finalResult'][2].toString())
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                //width: width,
                color: Colors.orange,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Icon(
                      Icons.logout,
                      color: Colors.black,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                    Text(finalResult['finalResult'][3].toString()),
                  ],
                ),
              ))
            ],
          )
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Table(
            border: TableBorder.all(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: gtr(),
          ),
          SizedBox(height: 5.0),
          GestureDetector(onTap:() async {
            await this.handler.clearTables();
            await this.handler.calculateResult().then((res) {
              finalResult = res;
            });
            setState(() {

            });
          },
            child: new Container(

            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            height: 40.0,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.green.withOpacity(0.25)),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
              child: Text(
                'Очисть все.',
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 20.0,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          )),
          SizedBox(height: 10.0),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.0),
        ],
      ),
    ];
    for (int i = 0; i < 4; i++) {
      for (int k = 0; k < finalResult['textFromTextField'][i][k].length; k++) {
        xxx.insert(
            xxx.length,
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(color: i==0 ? Colors.blue : i == 1? Colors.green: i==2? Colors.yellow: Colors.orange),

              child: Center(child: Text(
                  finalResult['textFromTextField'][i][k].toString() + ""),
              ),));
        xxx.insert(
            xxx.length,
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(color: i==0 ? Colors.blue : i == 1? Colors.green: i==2? Colors.yellow: Colors.orange),

              child: Center(child: Text(
                  finalResult['slicesInfo'][i][k].toString() + ""),
              ),));
        xxx.insert(
            xxx.length,
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(color: i==0 ? Colors.blue : i == 1? Colors.green: i==2? Colors.yellow: Colors.orange),

              child: Center(child: Text(
                  finalResult['extraInfo'][i][k].toString() + ""),
              ),));
        xxx.insert(
            xxx.length,
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(color: i==0 ? Colors.blue : i == 1? Colors.green: i==2? Colors.yellow: Colors.orange),

              child: Center(child: Text(
                  finalResult['book'][i][k].toString() + ""),
              ),));

        // xxx.insert(
        //     xxx.length,
        //     Padding(
        //       padding: EdgeInsets.only(left: 15.0, right: 15.0, ),
        //       child: Center(
        //         child: Container(
        //           padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
        //           decoration: BoxDecoration(color: i==0 ? Colors.blue : i == 1? Colors.green: i==2? Colors.yellow: Colors.orange),
        //
        //           child: Text(finalResult['slicesInfo'][i][k].toString() + ""),
        //         ),
        //       ),
        //     ));
        //
        //
        // xxx.insert(
        //     xxx.length,
        //     Padding(
        //       padding: EdgeInsets.only(left: 15.0, right: 15.0, ),
        //       child: Center(
        //         child: Container(
        //           padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
        //           decoration: BoxDecoration(color: i==0 ? Colors.blue : i == 1? Colors.green: i==2? Colors.yellow: Colors.orange),
        //
        //           child: Text(finalResult['extraInfo'][i][k].toString() + ""),
        //         ),
        //       ),
        //     ));
        //
        // xxx.insert(
        //     xxx.length,
        //     Padding(
        //       padding: EdgeInsets.only(left: 15.0, right: 15.0,),
        //       child: Center(
        //         child: Container(
        //           padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0 ),
        //           decoration: BoxDecoration(color: i==0 ? Colors.blue : i == 1? Colors.green: i==2? Colors.yellow: Colors.orange),
        //           child: Text(finalResult['book'][i][k].toString() + ""),
        //         ),
        //       ),
        //     ));

        xxx.insert(xxx.length, Divider(
            color: Colors.black
        ));
        xxx.insert(xxx.length, SizedBox(height: 10,));

      }


    }

    return xxx;
  }

  List<TableRow> gtr() {
    print(finalResult);
    List<TableRow> x = [
      TableRow(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        children: <Widget>[
          Container(
            child: Text("Земли"),
          ),
          TableCell(
            child: Container(
              color: Colors.blue,
              child: Text("Человека"),
            ),
          ),
          TableCell(
            child: Text("Возврата"),
          ),
          TableCell(
            child: Text("Выхода"),
          ),
        ],
      ),
    ];

    int maxLength = 0;
    maxLength >= finalResult['linesWithCalculation'][0].length
        ? 0
        : maxLength = finalResult['linesWithCalculation'][0].length;
    maxLength >= finalResult['linesWithCalculation'][1].length
        ? 0
        : maxLength = finalResult['linesWithCalculation'][1].length;
    maxLength >= finalResult['linesWithCalculation'][2].length
        ? 0
        : maxLength = finalResult['linesWithCalculation'][2].length;
    maxLength >= finalResult['linesWithCalculation'][3].length
        ? 0
        : maxLength = finalResult['linesWithCalculation'][3].length;

    for (int i = 0; i < maxLength - 1; i++) {
      TableRow tr;
      Text text1;
      Text text2;
      Text text3;
      Text text4;
      // if (snapshot.data![3][0].isNotEmpty){
      //
      // }
      finalResult['linesWithCalculation'][0].asMap().containsKey(i)
          ? text1 = Text(finalResult['linesWithCalculation'][0][i])
          : text1 = const Text('');
      finalResult['linesWithCalculation'][1].asMap().containsKey(i)
          ? text2 = Text(finalResult['linesWithCalculation'][1][i])
          : text2 = const Text('');
      finalResult['linesWithCalculation'][2].asMap().containsKey(i)
          ? text3 = Text(finalResult['linesWithCalculation'][2][i])
          : text3 = Text('');
      finalResult['linesWithCalculation'][3].asMap().containsKey(i)
          ? text4 = Text(finalResult['linesWithCalculation'][3][i])
          : text4 = const Text('');

      tr = TableRow(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        children: <Widget>[
          text1,
          text2,
          TableCell(
            child: text3,
          ),
          TableCell(
            child: text4,
          ),
        ],
      );
      x.insert(x.length, tr);
    }

// TableRow tr = TableRow(
//   decoration: const BoxDecoration(
//     color: Colors.blue,
//   ),
//   children: <Widget>[
//     Text(finalResult['linesWithCalculation'][0][0]),
//     Text("data"),
//     TableCell(
//       child: Text("data"),
//     ),
//     TableCell(
//       child: Text("data"),
//     ),
//   ],
// );
//x.insert(x.length, tr);
    return x;
  }

  late DatabaseHandler handler;
  late List<List<Container>> result = [];
  late List<Slice> dataFromDB;
  late Map<String, dynamic> finalResult;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB();
    this.handler.retrieveSlices(_selectedIndex).then((result) {
      loading = false;
      dataFromDB = result;

      for (var map in dataFromDB) {
        // print(map.selectedInterval);
        // print(map.selectedSlice);
        // print(map.activity);
      }
      setState(() {
        // for (var map in result) {
        // //activity[map.key]= map.activity == 0 ? false: true;
        // // print(map.activity);
        // }
      });
    });
    this.handler.calculateResult().then((value) {
      loading = false;
      finalResult = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Загружается..."), //Text(widget.title!),
          ),
          body: const Center(
            child: LinearProgressIndicator(
              value: 0.5,
              backgroundColor: Colors.lightBlue,
              color: Colors.white,
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              title[this.handler.getSelectedIndex()]), //Text(widget.title!),
        ),
        body: _selectedIndex != 4
            ? ListView.builder(
                itemCount: dataFromDB.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: UniqueKey(),
                    onDismissed: (DismissDirection direction) async {
                      this.handler.retrieveSlices(_selectedIndex);

                      // print("-----");
                      // print(index);
                      // print(dataFromDB.length);
                      // print(dataFromDB[index].id!);
                      // // if (dataFromDB[index+1] != null && dataFromDB.length > index) {
                      // //   print(dataFromDB[index+1].id);
                      // // }
                      // print("-----");
                      // //
                      await handler.deleteSlice(
                          dataFromDB[index].id!, _selectedIndex);
                      dataFromDB.removeAt(index);
                      setState(() {
                        //snapshot.data![0].remove(snapshot.data![0][index]);
                      });
                    },
                    child: Container(
                      constraints: BoxConstraints.expand(
                        height:
                            Theme.of(context).textTheme.headline4!.fontSize! *
                                    1.1 +
                                170.0,
                      ),
                      padding: const EdgeInsets.all(10.0),
                      //color: Colors.,
                      alignment: Alignment.center,
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        children: getChildrensNew(
                            index, dataFromDB), //this.result[index],
                      ),
                    ),
                  );
                },
              )
            : getRes(finalResult),
        // body: FutureBuilder(
        //   future: Future.wait([
        //     this.handler.retrieveSlices(this.handler.getSelectedIndex()),
        //     this.handler.calculateResult(),
        //     this.handler.getIndex(),
        //     this.handler.resultsForATable()
        //     //Future that returns bool
        //   ]),
        //   builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        //     if (snapshot.hasData) {
        //       if (snapshot.data![2][0] == 4) {
        //         return getRes(snapshot);
        //       }
        //
        //       return raysPage(snapshot);
        //     } else {
        //       return Center(child: CircularProgressIndicator());
        //     }
        //   },
        // ),
        floatingActionButton: Visibility(
          visible: _selectedIndex != 4 ? true : false,
          child: FloatingActionButton(
            onPressed: () async {
              await addSlices(_selectedIndex);
              await this.handler.retrieveSlices(_selectedIndex).then((result) {
                // loading = false;
                dataFromDB = result;
              });
              //await
              setState(() {});
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.public),
                label: 'Земли',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.accessibility_new),
                label: 'Человека',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.undo),
                label: 'Возврата',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Выхода',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.calculate),
                label: 'Итог',
                backgroundColor: Colors.blue)
          ],
          currentIndex: _selectedIndex, //this.handler.getSelectedIndex(),
          selectedItemColor: Colors.yellow,
          onTap: switchBetweenRays,
        ),
      );
    }
  }

  Future<int> addSlices(selectedIndex) async {
    Slice firstSlice = Slice(
        selectedSlice: "Указать срез",
        mealName: "",
        selectedInterval: getTime[selectedIndex]);
    return await this.handler.insertSlice(firstSlice, selectedIndex);
  }
}

class Slice {
  final int? id;
  String? mealName;
  String selectedSlice;
  String selectedInterval;

  Slice(
      {this.id,
      this.mealName,
      required this.selectedSlice,
      required this.selectedInterval});

  Slice.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        mealName = res["mealName"],
        selectedSlice = res["selectedSlice"],
        selectedInterval = res["selectedInterval"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'mealName': mealName,
      'selectedSlice': selectedSlice,
      'selectedInterval': selectedInterval
    };
  }
}

class DatabaseHandler {
  static const rayname = [
    'RayOfEarth',
    'RayOfHuman',
    'RayOfReturn',
    'RayOfExit',
    "Results"
  ];

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'rn20.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE RayOfEarth(id INTEGER PRIMARY KEY AUTOINCREMENT, mealName string, selectedSlice string, selectedInterval string)",
        );
        await database.execute(
          "CREATE TABLE RayOfHuman(id INTEGER PRIMARY KEY AUTOINCREMENT, mealName string, selectedSlice string, selectedInterval string)",
        );
        await database.execute(
          "CREATE TABLE RayOfReturn(id INTEGER PRIMARY KEY AUTOINCREMENT, mealName string, selectedSlice string, selectedInterval string)",
        );
        await database.execute(
          "CREATE TABLE RayOfExit(id INTEGER PRIMARY KEY AUTOINCREMENT,  mealName string, selectedSlice string, selectedInterval string)",
        );
        await database.execute(
          "CREATE TABLE Results(id INTEGER PRIMARY KEY AUTOINCREMENT, RayOfEarth int NOT NULL,RayOfHuman int NOT NULL, RayOfReturn int NOT NULL, RayOfExit int NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertSlice(Slice slices, int _selectedIndex) async {
    int result = 0;
    final Database db = await initializeDB();

    result = await db.insert(rayname[_selectedIndex], slices.toMap());

    return result;
  }

  Future<List<Slice>> retrieveSlices(int _selectedIndex) async {
    final Database db = await initializeDB();
    List<Map<String, Object?>> queryResult =
        await db.query(rayname[_selectedIndex]);
    print(")(");
    print(queryResult);
    print(")(");
    return queryResult.map((e) => Slice.fromMap(e)).toList();
  }

  Future<void> deleteSlice(int id, int _selectedIndex) async {
    final db = await initializeDB();

    await db.delete(
      rayname[_selectedIndex],
      where: "id = ?",
      whereArgs: [id],
    );

    final List<Map<String, Object?>> queryResult =
        await db.query(rayname[_selectedIndex]);
    //   print(")(");
    // print(queryResult);
    //   print(")(");
  }
  Future<void> clearTables() async {


    final db = await initializeDB();
    await db.rawDelete("DELETE FROM RayOfEarth");
    await db.rawDelete("DELETE FROM RayOfHuman");
    await db.rawDelete("DELETE FROM RayOfReturn");
    await db.rawDelete("DELETE FROM RayOfExit");

  }

  updateSlice(Slice slice, int _selectedIndex) async {
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
    final List<Map<String, Object?>> queryResult =
        await db.query(rayname[_selectedIndex]);
    // print("++++++++");
    // print(queryResult);
    queryResult.map((e) => Slice.fromMap(e)).toList();
  }

  int getRayCoefficient(String rayName, String slice) {
    final coefficientRayOfEarth = {
      Data.data[0][0][0]: 27,
      Data.data[0][1][0]: 20,
      Data.data[0][2][0]: 14,
      Data.data[0][3][0]: 7
    };

    final coefficientRayOfHuman = {
      Data.data[1][0][0]: 27,
      Data.data[1][1][0]: 23,
      Data.data[1][2][0]: 18,
      Data.data[1][3][0]: 14,
      Data.data[1][4][0]: 9,
      Data.data[1][5][0]: 5
    };

    final coefficientRayOfReturn = {
      Data.data[2][0][0]: 27,
      Data.data[2][1][0]: 24,
      Data.data[2][2][0]: 20,
      Data.data[2][3][0]: 16,
      Data.data[2][4][0]: 12,
      Data.data[2][5][0]: 8,
      Data.data[2][6][0]: 4
    };

    final coefficientRayOfExit = {
      Data.data[3][0][0]: 27,
      Data.data[3][1][0]: 24,
      Data.data[3][2][0]: 21,
      Data.data[3][3][0]: 18,
      Data.data[3][4][0]: 15,
      Data.data[3][5][0]: 12,
      Data.data[3][6][0]: 9,
      Data.data[3][7][0]: 6,
      Data.data[3][8][0]: 3
    };

    switch (rayName) {
      case 'RayOfEarth':
        // print("iiiiiiiii");
        // print(coefficientRayOfEarth[slice]!);
        // print("iiiiiiiii");
        return coefficientRayOfEarth[slice]!;
        break;
      case 'RayOfHuman':
        return coefficientRayOfHuman[slice]!;
        break;
      case 'RayOfReturn':
        return coefficientRayOfReturn[slice]!;
        break;
      case 'RayOfExit':
        return coefficientRayOfExit[slice]!;
        break;
      default:
        return 0;
    }
  }

  getIntervalCoefficient(String intetval) {
    switch (intetval) {
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

  Future<dynamic> calculateResult() async {
    final db = await initializeDB();
    Map<String, dynamic> finalResult = {
      "finalResult": [0, 0, 0, 0],
      "linesWithCalculation": [
        [''],
        [''],
        [''],
        ['']
      ],
      "textFromTextField": [
        [''],
        [''],
        [''],
        ['']
      ],
      "slicesInfo": [
        [''],
        [''],
        [''],
        ['']
      ],
      "book": [
        [''],
        [''],
        [''],
        ['']
      ],
      "extraInfo": [
        [''],
        [''],
        [''],
        ['']
      ]
    };

    for (int i = 0; i < rayname.length - 1; i++) {
      final List<Map<String, Object?>> queryResult = await db.query(rayname[i]);
      var listWithSlices = queryResult.map((e) => Slice.fromMap(e)).toList();

      if (listWithSlices.isNotEmpty) {
        if (listWithSlices.length > 0) {
          for (int e = 0; e < listWithSlices.length; e++) {
            // print("||||||||||||");
            // print(listWithSlices);
            // print("||||||||||||");
            if (listWithSlices[e].selectedSlice == "Указать срез") {
              finalResult['finalResult'][i] = finalResult['finalResult'][i] + 0;
            } else {
              int rc = getRayCoefficient(
                  rayname[i], listWithSlices[e].selectedSlice);
              int ri =
                  getIntervalCoefficient(listWithSlices[e].selectedInterval);
              int fr = rc * ri;

              finalResult['linesWithCalculation'][i]
                  .insert(e, "$rc * $ri =$fr");
              finalResult['textFromTextField'][i]
                  .insert(e, listWithSlices[e].mealName);
              finalResult['finalResult'][i] =
                  finalResult['finalResult'][i] + fr;
              finalResult['slicesInfo'][i]
                  .insert(e, listWithSlices[e].selectedSlice);
              finalResult['book'][i]
                  .insert(e, getBook(listWithSlices[e].selectedSlice, i));
              finalResult['extraInfo'][i]
                  .insert(e, getExtraInfo(listWithSlices[e].selectedSlice, i));
            print("09090909");
              print(listWithSlices[e].selectedSlice);
              print(i);
            print("09090909");

            }
          }
        }
      }
    }

    return finalResult;
  }

  // Future<List> resultsForATable() async {
  //   final db = await initializeDB();
  //   //List finalResult = [0, 0, 0, 0];
  //   List<List<String>> finalResult = [[], [], [], []];
  //
  //   for (int i = 0; i < rayname.length - 1; i++) {
  //     final List<Map<String, Object?>> queryResult = await db.query(rayname[i]);
  //     var x = queryResult.map((e) => Slice.fromMap(e)).toList();
  //     if (x.isNotEmpty) {
  //       if (x.length > 0) {
  //         for (int e = 0; e < x.length; e++) {
  //           if (x[e].selectedSlice == 0) {
  //             finalResult[i] = finalResult[i];
  //           } else {
  //             // int rc =
  //             //     getRayCoefficient(rayname[i], x[e].selectedSlice.toInt() - 1);
  //             // int ri = getIntervalCoefficient(x[e].selectedInterval);
  //             // int fr = rc * ri;
  //             // finalResult[i].insert(finalResult[i].length, "$rc * $ri =$fr");
  //             // finalResult['finalResult'][i] = finalResult['finalResult'][i] + fr ;
  //           }
  //         }
  //       }
  //     }
  //   }
  //
  //   return finalResult;
  // }

  int _selectedIndex = 0;

  getExtraInfo (String nameOfSlice, int i) {

    for (int k = 0; k < Data.data[i].length; k++) {
      if (Data.data[i][k].contains(nameOfSlice)) {
        return Data.data[i][k][1];
      }
    }

    return "000";
  }

  String getBook(String nameOfSlice, int i) {
    // print('uuu');
    // print(i);
    // print(nameOfSlice);
    for (int k = 0; k < Data.data[i].length; k++) {
      if (Data.data[i][k].contains(nameOfSlice)) {
        return Data.data[i][k][2];
      }
    }

    return "000";
  }

  Future<List> getIndex() async {
    List x = [_selectedIndex];
    return x;
  }

  int getSelectedIndex() {
    return _selectedIndex;
  }

  setIndex(int selectedIndex) async {
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
        child: Stack(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 0.0),
                      child: Center(
                          child: CircleAvatar(
                        backgroundColor: const Color(0xff764abc),
                        child: Text(numberOfSlice),
                      ))),
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
          ],
        ));
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    final text = myController.text;
    print('Second text field: $text (${text.characters.length})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                print('First text field: $text (${text.characters.length})');
              },
            ),
            TextField(
              controller: myController,
            ),
          ],
        ),
      ),
    );
  }
}
