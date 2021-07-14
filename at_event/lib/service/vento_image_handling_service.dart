import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:at_event/utils/constants.dart';
import 'package:at_event/models/tiny_response.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;

Future<void> saveImagesFromUrl(
    List<File> _images, DocumentReference ref) async {
  // For each file in the File list, compress it and then save it to Cloud Storage
  _images.forEach((image) async {
    String compressImage =
        await tinyFile(image); // Will return the compressed image URL
    print("tiny: $compressImage");

    // If compression succeeded, proceed with uploading
    if (compressImage != "Fail") {
      String imageURL = await uploadNetworkImage(compressImage);
      ref.update({
        "images": FieldValue.arrayUnion([imageURL])
      });
    }
  });
}

Future<String> tinyFile(File file) async {
  var url = 'https://api.tinify.com/shrink';
  TinyResponse tinyResponse;
  try {
    var response = await http.post(
      Uri.parse(url),
      body: file.readAsBytesSync(),
      headers: {'Authorization': "Basic {${tinyPNG_base64}}"},
    );
    print("TinyPNG access succeeded");
    tinyResponse = TinyResponse.fromJson(jsonDecode(response.body));
    return tinyResponse.url;
  } catch (e) {
    print("TinyPNG access failed");
    print(e);
    return "Fail";
  }
}

Future<String> uploadNetworkImage(String _image) async {
  // Retrieve the image from the tinyPNG URL
  http.Response response = await http
      .get(Uri.parse(_image), headers: {"Content-Type": 'application/json'});
  print(response.body);
  // Convert to form that can be saved to Cloud Storage
  Uint8List networkBytes = response.bodyBytes;

  Reference storageReference = FirebaseStorage.instance
      .ref()
      .child('sightings/${Path.basename(_image)}');
  UploadTask uploadTask = storageReference.putData(networkBytes);
  await uploadTask.whenComplete(() => print('File Uploaded'));
  String returnURL;
  await storageReference.getDownloadURL().then((fileURL) {
    returnURL = fileURL;
  });
  return returnURL;
}
