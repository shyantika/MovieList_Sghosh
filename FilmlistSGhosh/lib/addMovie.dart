import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movielist/models/movie-model.dart';

class AddMovieScreen extends StatefulWidget {
  final bool isEditing;
  final movie;
  const AddMovieScreen({Key? key, required this.isEditing, this.movie})
      : super(key: key);

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  TextEditingController _movie = new TextEditingController();
  TextEditingController _director = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  var _image;
  var done = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEditing) {
      setState(() {
        _movie = TextEditingController(text: widget.movie.movieName);
        _director = TextEditingController(text: widget.movie.directorName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Movie' : 'Add Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = image!.path;
                    done = true;
                  });
                },
                child: Center(
                  child: Container(
                    height: 150,
                    child: done
                        ? Image.file(File(_image))
                        : widget.isEditing
                            ? Image.file(File(widget.movie.bannerImage))
                            : Center(child: Icon(Icons.add)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _movie,
                decoration: InputDecoration(
                    labelText: 'Movie Name',
                    labelStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _director,
                decoration: InputDecoration(
                    labelText: 'Director Name',
                    labelStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
                child: widget.isEditing
                    ? FloatingActionButton.extended(
                        icon: Icon(Icons.save),
                        onPressed: () async {
                          if (_movie.text.trim().isNotEmpty &&
                              _director.text.trim().isNotEmpty) {
                            await DatabaseHelper.instance.updateMovie(Movie(
                                id: widget.movie.id,
                                movieName: _movie.text,
                                bannerImage:
                                    done ? _image : widget.movie.bannerImage,
                                directorName: _director.text));
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                action: SnackBarAction(
                                  label: '',
                                  onPressed: () {
                                    // Code to execute.
                                  },
                                ),
                                content: const Text(
                                    'Field should be filled properly'),
                                duration: const Duration(milliseconds: 1500),
                                width: 280.0, // Width of the SnackBar.
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      8.0, // Inner padding for SnackBar content.
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            );
                          }
                        },
                        label: Text('Update'))
                    : FloatingActionButton.extended(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          if (_movie.text.trim().isNotEmpty &&
                              _director.text.trim().isNotEmpty &&
                              done) {
                            await DatabaseHelper.instance.addMovie(Movie(
                                movieName: _movie.text,
                                bannerImage: _image,
                                directorName: _director.text));
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                action: SnackBarAction(
                                  label: 'Ok',
                                  onPressed: () {
                                    // Code to execute.
                                  },
                                ),
                                content: const Text('Fill Correct Details'),
                                duration: const Duration(milliseconds: 1500),
                                width: 280.0, // Width of the SnackBar.
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      8.0, // Inner padding for SnackBar content.
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            );
                          }
                        },
                        label: Text('Add')))
          ],
        ),
      ),
    );
  }
}
