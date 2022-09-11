import 'package:flutter/material.dart';
import 'package:sqlflutter/db_handler.dart';
import 'package:sqlflutter/notes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  List<dynamic> lst = [];
  var output = "";
  var email = "";
  var rollnum = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Notes SQL")),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: FutureBuilder(
              future: notesList,
              builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      reverse: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Text("Full Name"),
                                      content: TextField(onChanged: (value) {
                                        output = value;
                                      }),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: Text("Email"),
                                                      content: TextField(
                                                          onChanged: (value) {
                                                        email = value;
                                                      }),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                      title: Text(
                                                                          "Roll Number"),
                                                                      content: TextField(
                                                                          onChanged:
                                                                              (value) {
                                                                        rollnum =
                                                                            value;
                                                                      }),
                                                                      actions: [
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                            dbHelper!.update(
                                                                              NotesModel(id: snapshot.data![index].id!, name: output, email: email, gender: rollnum),
                                                                            );
                                                                            setState(() {
                                                                              notesList = dbHelper!.getNotesList();
                                                                            });
                                                                          },
                                                                          child:
                                                                              Text("Add"),
                                                                        ),
                                                                      ]);
                                                                });
                                                          },
                                                          child: Text("Add"),
                                                        ),
                                                      ]);
                                                });
                                          },
                                          child: Text("Add"),
                                        ),
                                      ]);
                                });
                          },
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              child: Icon(Icons.delete_forever),
                            ),
                            onDismissed: (DismissDirection direction) {
                              setState(() {
                                dbHelper!.delete(snapshot.data![index].id!);
                                notesList = dbHelper!.getNotesList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            key: ValueKey<int>(snapshot.data![index].id!),
                            child: Card(
                              child: ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title:
                                    Text(snapshot.data![index].name.toString()),
                                subtitle: Text(
                                    snapshot.data![index].email.toString()),
                                trailing: Text(
                                    snapshot.data![index].gender.toString()),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text("Full Name"),
                    content: TextField(onChanged: (value) {
                      output = value;
                    }),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Email"),
                                  content: TextField(onChanged: (value) {
                                    email = value;
                                  }),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Roll Number"),
                                                  content: TextField(
                                                      onChanged: (value) {
                                                    rollnum = value;
                                                  }),
                                                  actions: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          dbHelper!
                                                              .insert(
                                                            NotesModel(
                                                                name: output,
                                                                email: email,
                                                                gender:
                                                                    rollnum),
                                                          )
                                                              .then((value) {
                                                            print('Data Added');
                                                            setState(() {
                                                              notesList = dbHelper!
                                                                  .getNotesList();
                                                            });
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            print(error
                                                                .toString());
                                                          });
                                                          // Navigator.of(context)
                                                          //     .pop();
                                                          setState(() {
                                                            notesList = dbHelper!
                                                                .getNotesList();
                                                          });
                                                        },
                                                        child: Text("Add")),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text("Add")),
                                  ],
                                );
                              });
                        },
                        child: Text("Add"),
                      ),
                    ]);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
