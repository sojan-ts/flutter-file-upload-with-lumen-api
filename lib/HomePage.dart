import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  final picker = FilePicker.platform;
  File? uploadfile;

  Future<void> chooseFile() async {
    var pickedFile = await picker.pickFiles(
      type: FileType.any,
    );
    setState(() {
      uploadfile = File(pickedFile!.files.single.path!);
    });
  }

  Future<void> uploadFile() async {
    var uploadurl = Uri.parse('baseurl+api/upload');
    try {
      var request = http.MultipartRequest('POST', uploadurl);
      request.files
          .add(await http.MultipartFile.fromPath('image', uploadfile!.path));
      var response = await request.send();

      if (response != null) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var jsondata = json.decode(responseString);
        print(jsondata);
      } else {
        print("Error during connection to server: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during uploading file");
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Upload File to Server"),
        ),
        backgroundColor: Color.fromARGB(255, 147, 64, 255),
      ),
      body: Container(
        height: 300,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: uploadfile == null
                    ? Container()
                    : SizedBox(
                        height: 150,
                        child: getFileWidget(uploadfile!),
                      )),
            Container(
                child: uploadfile == null
                    ? Container()
                    : ElevatedButton.icon(
                        onPressed: () {
                          uploadFile();
                        },
                        icon: const Icon(Icons.file_upload),
                        label: const Text("UPLOAD FILE"),
                      )),
            ElevatedButton.icon(
              onPressed: () {
                chooseFile();
              },
              icon: const Icon(Icons.folder_open),
              label: const Text("CHOOSE FILE"),
            )
          ],
        ),
      ),
    );
  }

  Widget getFileWidget(File file) {
    String extension = file.path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return const Icon(Icons.image);
      case 'mp4':
      case 'avi':
      case 'mov':
        return const Icon(Icons.video_camera_back_outlined);
      case 'pdf':
        return const Icon(Icons.picture_as_pdf);
      case 'doc':
      case 'docx':
        return const Icon(Icons.description);
      case 'apk':
        return const Icon(Icons.android);
      default:
        return const Icon(Icons.insert_drive_file);
    }
  }
}
