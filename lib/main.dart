import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        dropdownMenuEntries:
            Data.slicesData[_selectedIndex].map<DropdownMenuEntry<String>>((String value) {
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


  // var w;
  getRes(AsyncSnapshot<List<dynamic>> snapshot) {
    //Возвращает страницу с результатами
    // Future<List> _futureOfList = handler.calculateResult();
    // List list = await _futureOfList;
    double width = 98;
    List<TableCell> res = [];
//print(snapshot.data![1]![1][0].length);
//print(snapshot.data![1]![1]);
    //for (int i = 0; i < snapshot.data![1]![0].length; i++) {}
    //w =
    if (snapshot.data != null) {
      if (snapshot.data![1] != null) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          //height: 158.0,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
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
                              Text(snapshot.data![1]![0][0] != null
                                  ? snapshot.data![1]![0][0].toString()
                                  : "0"),
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
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            Text(snapshot.data![1][0][1] != null
                                ? snapshot.data![1][0][1]!.toString()
                                : "0"),
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
                              Text(snapshot.data![1]![0][2] != null
                                  ? snapshot.data![1]![0][2].toString()
                                  : "0"),
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
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            Text(snapshot.data![1]![0][3] != null
                                ? snapshot.data![1]![0][3].toString()
                                : "0"),
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
                    children: gtr(snapshot),
                  ),
                  SizedBox(height: 5.0),
                  new Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 40.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.green.withOpacity(0.25)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 8.0),
                      child: Text(
                        'Очисть все.(В разработке)',
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 20.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0)
                ],
              )
            ],
          ),
        );
      }
    }
  }

  List<TableRow> gtr(AsyncSnapshot<List<dynamic>> snapshot) {
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
    maxLength >= snapshot.data![3][0].length
        ? 0
        : maxLength = snapshot.data![3][0].length;
    maxLength >= snapshot.data![3][1].length
        ? 0
        : maxLength = snapshot.data![3][1].length;
    maxLength >= snapshot.data![3][2].length
        ? 0
        : maxLength = snapshot.data![3][2].length;
    maxLength >= snapshot.data![3][3].length
        ? 0
        : maxLength = snapshot.data![3][3].length;

    for (int i = 0; i < maxLength; i++) {
      TableRow tr;
      Text text1;
      Text text2;
      Text text3;
      Text text4;
      // if (snapshot.data![3][0].isNotEmpty){
      //     if (snapshot.data![3][0][0]){}
      // }
      snapshot.data![3][0].asMap().containsKey(i)
          ? text1 = Text(snapshot.data![3][0][i])
          : text1 = const Text('');
      snapshot.data![3][1].asMap().containsKey(i)
          ? text2 = Text(snapshot.data![3][1][i])
          : text2 = const Text('');
      snapshot.data![3][2].asMap().containsKey(i)
          ? text3 = Text(snapshot.data![3][2][i])
          : text3 = Text('');
      snapshot.data![3][3].asMap().containsKey(i)
          ? text4 = Text(snapshot.data![3][3][i])
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
    return x;
  }

  late DatabaseHandler handler;
  late List<List<Container>> result = [];
  late List<Slice> dataFromDB;
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
        body: ListView.builder(
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

                print("-----");
                print(index);
                print(dataFromDB.length);
                print(dataFromDB[index].id!);
                // if (dataFromDB[index+1] != null && dataFromDB.length > index) {
                //   print(dataFromDB[index+1].id);
                // }
                print("-----");
                //
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
                      Theme.of(context).textTheme.headline4!.fontSize! * 1.1 +
                          170.0,
                ),
                padding: const EdgeInsets.all(10.0),
                //color: Colors.,
                alignment: Alignment.center,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  children:
                      getChildrensNew(index, dataFromDB), //this.result[index],
                ),
              ),
            );
          },
        ),
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

  int getRayCoefficient(String rayName, int slice) {
    final coefficientRayOfEarth = [27, 20, 14, 7];

    final coefficientRayOfHuman = [27, 23, 18, 14, 9, 5];

    final coefficientRayOfReturn = [27, 24, 20, 16, 12, 8, 4];

    final coefficientRayOfExit = [27, 24, 21, 18, 15, 12, 9, 6, 3];

    switch (rayName) {
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

  Future<List> calculateResult() async {
    final db = await initializeDB();
    //List finalResult = [0, 0, 0, 0];
    List<List<dynamic>> finalResult = [
      [0, 0, 0, 0],
      [
        [''],
        [''],
        [''],
        ['']
      ]
    ];
    for (int i = 0; i < rayname.length - 1; i++) {
      final List<Map<String, Object?>> queryResult = await db.query(rayname[i]);
      var x = queryResult.map((e) => Slice.fromMap(e)).toList();
      if (x.isNotEmpty) {
        if (x.length > 0) {
          for (int e = 0; e < x.length; e++) {
            if (x[e].selectedSlice == 0) {
              finalResult[0][i] = finalResult[0][i] + 0;
            } else {
              // int rc =
              //     getRayCoefficient(rayname[i], x[e].selectedSlice.toInt() - 1);
              // int ri = getIntervalCoefficient(x[e].selectedInterval);
              // int fr = rc * ri;
              // finalResult[1][i] = "$rc * $ri =$fr";
              // finalResult[0][i] = finalResult[0][i] + fr;
            }
          }
        }
      }
    }

    return finalResult;
  }

  Future<List> resultsForATable() async {
    final db = await initializeDB();
    //List finalResult = [0, 0, 0, 0];
    List<List<String>> finalResult = [[], [], [], []];

    for (int i = 0; i < rayname.length - 1; i++) {
      final List<Map<String, Object?>> queryResult = await db.query(rayname[i]);
      var x = queryResult.map((e) => Slice.fromMap(e)).toList();
      if (x.isNotEmpty) {
        if (x.length > 0) {
          for (int e = 0; e < x.length; e++) {
            if (x[e].selectedSlice == 0) {
              finalResult[i] = finalResult[i];
            } else {
              // int rc =
              //     getRayCoefficient(rayname[i], x[e].selectedSlice.toInt() - 1);
              // int ri = getIntervalCoefficient(x[e].selectedInterval);
              // int fr = rc * ri;
              // finalResult[i].insert(finalResult[i].length, "$rc * $ri =$fr");
              // finalResult[0][i] = finalResult[0][i] + fr ;
            }
          }
        }
      }
    }

    return finalResult;
  }

  int _selectedIndex = 0;

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
