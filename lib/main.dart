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

  // Future<String> _future;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  setStateOfSlice(int index, int row, Slice slice){
    slice.selected = row+1;
    this.handler.updateSlice(slice);

  }
  List<Container> te(int index, int selected, Slice slice){

    List<Container> x = [];

    for (int i = 0; i < 3; i++){
      print("-----------------------------");

      var s = false;
      if (i+1 == selected){
        s = true;
      }
      print(s);
      x.insert(x.length, Container(
        height: 77,
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
                  Text('Фрукты, ягоды, сметана,',
                      textDirection: TextDirection.ltr),
                  Text('Звездный План.',
                      textDirection: TextDirection.ltr),
                  Text('Будущее.',
                      textDirection: TextDirection.ltr),
                ],
              )
          ),
          onTap: () {
            setState(() {

              setStateOfSlice(index, i, slice);
              
              // selectedIndex = 0;
            });
          },
        ),
      ));

    }
    var d = Container(height: 77,
        color: Colors.blue,
        child: DropdownButton<String>(
          value: "One",//selectedIntervals[index],
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {

              // selectedIntervals[index] = newValue!;
            });
          },
          items: <String>['One', 'Two', 'Three', 'Four']
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

  late DatabaseHandler handler;
  late List<List<Container>> result = [];
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();

    this.handler.initializeDB().whenComplete(() async {
      //await this.addSlices();
      var t =  await this.handler.retrieveSlices();
      for (int i = 0; i < t.length; i++){
        // print("--------");
        //
        // print(t[i].selected);
        this.result.add(te(i+1,t[i].selected,t[i]));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title[_selectedIndex]),//Text(widget.title!),
      ),
      body: FutureBuilder(
        future: this.handler.retrieveSlices(),
        builder: (BuildContext context, AsyncSnapshot<List<Slice>> snapshot) {
          if (snapshot.hasData) {
            print('===================');
            return ListView.builder(
              itemCount: snapshot.data?.length,//data.length,//
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  key: UniqueKey(),//ValueKey<int>(index),//(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await this.handler.deleteSlice(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);

                    });
                  },
                  child: Container(
                    constraints: BoxConstraints.expand(
                      height: Theme.of(context).textTheme.headline4!.fontSize! * 1.1 + 295.0,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.blue[600],
                    alignment: Alignment.center,
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: this.result[index],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addSlices();
          setState(() {
            //selectedIndex = 0;
          });
        },

        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
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
    //this.handler.deleteSlice(0);
     //data.add([false,false,false]);
    Slice firstSlice = Slice(firstParametr: "Первый срез", secondParametr: "jn", product: "Название продукта",selected: 0);
    List<Slice> listOfSlices = [firstSlice];
    //selectedIntervals.add("One");
    return await this.handler.insertSlice(listOfSlices);
  }


}


class Slice {
  final int? id;
  final String firstParametr;
  final String secondParametr;
  final String product;
  final String? email;
  int selected;

  Slice(
      { this.id,
        required this.firstParametr,
        required this.secondParametr,
        required this.product,
        this.email,
        required this.selected
      });

  Slice.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        firstParametr = res["firstParametr"],
        secondParametr = res["secondParametr"],
        product = res["product"],
        email = res["email"],
        selected = res["selected"];

  Map<String, Object?> toMap() {
    return {'id':id,'firstParametr': firstParametr, 'secondParametr': secondParametr, 'product': product, 'email': email, 'selected': selected};
  }
}



class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'rn1.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE slices(id INTEGER PRIMARY KEY AUTOINCREMENT, firstParametr TEXT NOT NULL,secondParametr STRING NOT NULL, product TEXT NOT NULL, email TEXT, selected int)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertSlice(List<Slice> slices) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var slice in slices){
      result = await db.insert('slices', slice.toMap());
    }
    return result;
  }

  Future<List<Slice>> retrieveSlices() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('slices');

    return queryResult.map((e) => Slice.fromMap(e)).toList();
    print(")(");
    print(queryResult);
    print(")(");
  }

  Future<void> deleteSlice(int id) async {

    final db = await initializeDB();

    await db.delete(
      'slices',
      where: "id = ?",
      whereArgs: [id],
    );

    final List<Map<String, Object?>> queryResult = await db.query('slices');
  //   print(")(");
  // print(queryResult);
  //   print(")(");
  }

  updateSlice(Slice slice){

     updateSliceInDB(slice);
  }
   updateSliceInDB(Slice slice) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Update the given Dog.
    await db.update(
      'slices',
      slice.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [slice.id],
    );
    final List<Map<String, Object?>> queryResult = await db.query('slices');
    print(queryResult);
    queryResult.map((e) => Slice.fromMap(e)).toList();

  }
}



