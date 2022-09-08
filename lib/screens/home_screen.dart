import 'package:flutter/material.dart';
import 'package:persistence/helpers/database_helper.dart';
import 'package:persistence/models/cat_model.dart';

//ctrl+. para convertir a statefulwidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //variables para guardar los datos de los text form fields
    final textControllerRace = TextEditingController();
    final textControllerName = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite Example with Cats"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          //que la lista sea scrollable con un pequeño numero de hijos
          shrinkWrap: true,
          children: [
            //Raza
            TextFormField(
                controller: textControllerRace,
                decoration: const InputDecoration(
                    icon: Icon(Icons.view_comfortable),
                    labelText: "Input the race of the cat")),
            //Nombre
            TextFormField(
                controller: textControllerName,
                decoration: const InputDecoration(
                    icon: Icon(Icons.text_format_outlined),
                    labelText: "Input the cat's name")),
            Center(
              child: (
                  //Ideal guardar lo siguiente en un widget independiente
                  FutureBuilder<List<Cat>>(
                //data source del widget
                future: DatabaseHelper.instance.getCats(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Cat>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: const Text("Loading..."),
                      ),
                    );
                  } else {
                    //snapshot no esta vacio?
                    return snapshot.data!.isEmpty
                        ? Center(
                            child: Container(
                              child: Text("No cats in the list"),
                            ),
                          )
                        : ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.map((cat) {
                              return Center(
                                  child: ListTile(title: Text(cat.name)));
                            }).toList());
                  }
                },
              )),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          DatabaseHelper.instance.add(Cat(
              race: textControllerRace.text, name: textControllerName.text));
          setState(() {
            textControllerName.clear();
            textControllerRace.clear();
          });
        },
      ),
    );
  }
}
