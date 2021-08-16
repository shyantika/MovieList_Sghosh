import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:movielist/addMovie.dart';
import 'package:movielist/models/movie-model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text('Log Out'),
                onTap: () {
                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.pushReplacementNamed(context, './login'));
                },
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Movie>>(
          future: DatabaseHelper.instance.getMovies(),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading....'),
              );
            }
            return ListView(
              children: snapshot.data!.map((movie) {
                return Center(
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMovieScreen(
                                          isEditing: true,
                                          movie: movie,
                                        ))).then((value) => setState(() {})),
                            child: Icon(
                              Icons.edit,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                DatabaseHelper.instance.deleteMovie(movie.id!);
                              });
                            },
                            child: Icon(Icons.delete))
                      ],
                    ),
                    title: Text(movie.movieName),
                    subtitle: Text(movie.directorName),
                    leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(
                                    width: 1.0, color: Colors.grey))),
                        child: Image.file(File(movie.bannerImage))),
                  ),
                );
              }).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddMovieScreen(
                      isEditing: false,
                      movie: null,
                    ))).then((value) => setState(() {})),
        child: Icon(Icons.add),
      ),
    );
  }
}
