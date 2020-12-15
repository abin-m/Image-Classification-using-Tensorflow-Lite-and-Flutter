import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: new ThemeData.dark(),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {
  File imageURI;
  String result;
  String path;
  Future getImageFromCamera() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageURI = image;
      path = image.path;
      result = null;
    });
  }

  Future getImageFromGallery() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageURI = image;
      path = image.path;
      result = null;
    });
  }

  Future classifyImage() async {
    result = null;
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
    var output = await Tflite.runModelOnImage(path: path);
    setState(() {
      result = output.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Mask Detection'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imageURI == null
                ? Text("No Image Selected", style: TextStyle(fontSize: 21))
                : Image.file(
                    imageURI,
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: MaterialButton(
                    height: 50,
                    onPressed: () => getImageFromCamera(),
                    child: Text('Take a Photo'),
                    textColor: Colors.white,
                    color: Colors.blueGrey[500],
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ))),
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: MaterialButton(
                    height: 50,
                    onPressed: () => getImageFromGallery(),
                    child: Text('From Gallery'),
                    textColor: Colors.white,
                    color: Colors.blueGrey[600],
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ))),
            Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: MaterialButton(
                    height: 50,
                    onPressed: () => classifyImage(),
                    child: Text('Check'),
                    textColor: Colors.white,
                    color: Colors.teal[500],
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ))),
            result == null ? Text('Add an Image') : Text(result)
          ],
        ),
      ),
    );
  }
}
