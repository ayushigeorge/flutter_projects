import 'dart:io';


import 'package:flutter/material.dart';import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<File> ? imageFile;
  File? _image;
  String result= '';
  ImagePicker? imagePicker;
//function to upload picture from gallery
  selectPhotoFromGallery()async{
    XFile ? pickedFile =await imagePicker!.pickImage(source: ImageSource.gallery);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageClassification();
    });
  }
//function to upload image from camera
  captureFromCamera()async{
    XFile ? pickedFile =await imagePicker!.pickImage(source: ImageSource.gallery);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageClassification();
    });
  }
  loadDataModuleFiles()async{
    String? output= await Tflite.loadModel(model: 'assets/model_unquant.tflite',
      labels: 'assests/labels.txt',
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,

    );
    print(output);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker= ImagePicker();
    loadDataModuleFiles();
  }
  doImageClassification()async{
    var recog= await Tflite.runModelOnImage(
    path: _image!.path,
    imageMean: 0.0,
    imageStd: 255.0,
    numResults: 2,
    threshold: 0.1,
    asynch: true,
    );
    print(recog!.length.toString());
    setState((){
    result ='';
    });
    recog.forEach((element){
    setState((){
    print(element.toString());
    result += element['label']+'\n\n';
    });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('asset/backgroundmodel.jpg'),
            fit: BoxFit.cover
      )
            ),
    child: Column(
        children: [
         const SizedBox(width: 100.0),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Stack(
              children: <Widget>[
                Center(
                  child: TextButton(
                    onPressed: selectPhotoFromGallery,
                    onLongPress: captureFromCamera,
                    child: Container(
                      margin: const EdgeInsets.only(top: 50.0, right: 35.0, left:18),
                      child: _image! =null
                       ?
                              Image.file(
                                _image! ,
                                  height: 360.0,
                                  width: 400.0,
                                  fit: BoxFit.cover,
                              )
                              :
                              Container(
                                  width: 140.0,
                                  height: 190.0,
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.black,
                        ),
                      )
),
),
)
              ],
    ),
          ),
                    const SizedBox(height: 160.0),
                    Container(
                      margin: const EdgeInsets.only(top: 25.0) ,
                      child: Text(
                        '$result' ,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 40.0,
    color: Colors.pinkAccent,
    backgroundColor: Colors.white60,
    ),
    ),

    ),
      ],
    )
    )

    );

  }
}

