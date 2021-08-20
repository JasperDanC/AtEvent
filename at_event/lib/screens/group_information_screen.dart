import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;
import '../Widgets/custom_toast.dart';
import 'package:at_event/models/group_model.dart';
import 'package:at_event/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_event/Widgets/invite_box.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_event/service/vento_services.dart';
import 'package:at_event/screens/something_went_wrong.dart';
import 'chat_screen.dart';

final Reference storageReference =
    FirebaseStorage.instance.ref().child("GroupPictures");

final uploadReference = FirebaseFirestore.instance.collection("Uploads");

class GroupInformation extends StatefulWidget {
  final GroupModel? group;

  const GroupInformation({this.group});

  @override
  _GroupInformationState createState() => _GroupInformationState();
}

class _GroupInformationState extends State<GroupInformation> {
  final _picker = ImagePicker();
  String activeAtSign = '';
  File? _image;
  bool uploading = false;
  String postId = Uuid().v4();
  late bool isCreator;
  late PermissionStatus _photoStatus;
  late PermissionStatus _cameraStatus;

  @override
  void initState() {
    _listenForPermissionStatus();
    getAtSign();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isCreator = VentoService.getInstance()
        .compareAtSigns(activeAtSign, widget.group!.atSignCreator);
    SizeConfig().init(context);
    InviteBox inviteBox = InviteBox(
      addToList: false,
      invitees: widget.group!.atSignMembers,
      isCreator: isCreator,
      width: 300,
      height: SizeConfig().screenHeight * 0.5,
    );
    inviteBox.onAdd = () async {
      CustomToast().show('Invite Sent!', context);
      widget.group!.invitees.add(inviteBox.controller.value.text);
      await _updateAndInvite();
    };
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10.0),
                height: SizeConfig().screenHeight * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: (widget.group!.imageURL == '' ||
                                  widget.group!.imageURL == null
                              ? AssetImage('assets/images/group_landscape.jpg')
                              : NetworkImage(widget.group!.imageURL!))
                          as ImageProvider<Object>,
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                height: SizeConfig().screenHeight * 0.5,
                padding: EdgeInsets.all(40.0),
                width: SizeConfig().screenWidth,
                decoration: BoxDecoration(
                  color: kGroupInfoImageBackground.withOpacity(0.7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: isCreator
                          ? [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  Icon(
                                    Icons.group,
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.add_photo_alternate,
                                      size: 40.0,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (_photoStatus.isGranted &&
                                          _cameraStatus.isGranted) {
                                        _showPicker(context);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoAlertDialog(
                                            title:
                                                Text('Camera/Photo Permission'),
                                            content: Text(
                                                'This app needs camera access to take pictures or open gallery for group photos'),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                child: Text('Deny'),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                              CupertinoDialogAction(
                                                child: Text('Settings'),
                                                onPressed: () =>
                                                    openAppSettings(),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.chat_bubble,
                                      size: 40.0,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VentoChatScreen(
                                            chatID: widget.group!.key,
                                            groupMembers:
                                                widget.group!.atSignMembers,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ]
                          : [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  Icon(
                                    Icons.group,
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                ],
                              ),
                              MaterialButton(
                                shape: CircleBorder(),
                                padding: EdgeInsets.zero,
                                minWidth: 0.0,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VentoChatScreen(
                                        chatID: widget.group!.key,
                                        groupMembers:
                                            widget.group!.atSignMembers,
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.chat_bubble,
                                  color: Colors.white,
                                  size: 30.0.toWidth,
                                ),
                              ),
                            ],
                    ),
                    Container(
                      width: 90.0,
                      child: Divider(
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Expanded(
                      child: Text(
                        widget.group!.title!,
                        style: kTitleTextStyle.copyWith(fontSize: 35.0),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Capacity Indicator: For now it will just be a random generated value until we can implement capacity functions to our groups
                        Expanded(
                          child: Container(
                            child: LinearProgressIndicator(
                              backgroundColor:
                                  Color.fromRGBO(209, 224, 224, 0.2),
                              value: widget.group!.atSignMembers.length /
                                  widget.group!.capacity!,
                              valueColor: AlwaysStoppedAnimation(Colors.green),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Capacity',
                              style: kNormalTextStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(7.0),
                            decoration: BoxDecoration(
                              color: kColorStyle1.withOpacity(0.5),
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                  'Total:\n  ' +
                                      widget.group!.atSignMembers.length
                                          .toString(),
                                  style: kSubHeadingTextStyle.copyWith(
                                      fontSize: 20.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: SizeConfig().screenHeight * 0.5,
            width: SizeConfig().screenWidth,
            decoration: BoxDecoration(color: kColorStyle1),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Container(
                    height: SizeConfig().screenHeight * 0.2,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        widget.group!.description!,
                        style: kNormalTextStyle.copyWith(
                            fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: MaterialButton(
                    color: kColorStyle2,
                    shape: StadiumBorder(),
                    elevation: 0.1,
                    child: Text('Show Members', style: kButtonTextStyle),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: SizeConfig().screenHeight * 2.0,
                            decoration: BoxDecoration(
                              color: kColorStyle3,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                inviteBox,
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //simple atSign getter
  getAtSign() async {
    String? currentAtSign = await VentoService.getInstance().getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
  }

  _updateAndInvite() async {
    setState(() {});
    //create and update the event in the secondary so that the invitee added
    //is kept track of in the secondary as well
    AtKey atKey = AtKey();
    atKey.key = widget.group!.key;
    atKey.namespace = MixedConstants.NAMESPACE;
    atKey.sharedWith = activeAtSign;
    atKey.sharedBy = activeAtSign;
    Metadata metadata = Metadata();
    metadata.ccd = true;
    atKey.metadata = metadata;

    String storedValue = GroupModel.convertGroupToJson(widget.group!);

    await VentoService.getInstance().put(atKey, storedValue);
    await VentoService.getInstance().shareWithMany(
        atKey.key, storedValue, activeAtSign, widget.group!.invitees);
  }

  _imgFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
      _controlUploadAndSave();
      print('Image path: ' + _image!.path);
    });
  }

  _imgFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
      _controlUploadAndSave();
      print('Image path: ' + _image!.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void savePostInfoToFireStore({String? url}) {
    uploadReference
        .doc(activeAtSign)
        .collection("atSignUpload")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": activeAtSign,
      "timeStamp": DateTime.now().millisecondsSinceEpoch,
      "url": url,
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    await storageReference
        .child('post_$postId.jpg')
        .putFile(mImageFile)
        .then((taskSnapshot) {
      print("task done");

// download url when it is uploaded
      if (taskSnapshot.state == TaskState.success) {
        storageReference.child('post_$postId.jpg').getDownloadURL().then((url) {
          print("Here is the URL of Image $url");
          widget.group!.imageURL = url;
          _updateAndInvite();
          return url;
        }).catchError((onError) {
          print("Got Error $onError");
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SomethingWentWrongScreen()));
        });
      }
    });
    return 'failed';
  }

  Future<void> compressImage() async {
    final tempDirectory = await getTemporaryDirectory();
    final path = tempDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(_image!.readAsBytesSync())!;
    final compressedImageFile = File('$path/img_$postId')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 90));
    _image = compressedImageFile;
  }

  Future<void> _controlUploadAndSave() async {
    setState(() {
      uploading = true;
      print("uploading...");
    });

    if (_image != null) {
      await compressImage();
      print("compressed");
      String downloadUrl = await uploadPhoto(_image);
      print("download url: " + downloadUrl);
      savePostInfoToFireStore(url: downloadUrl);
      print("saved to firestore");
      setState(() {
        _image = null;
        uploading = false;
        postId = Uuid().v4();
      });
      print("finished upload");
    }
  }

  void _listenForPermissionStatus() async {
    final cameraStatus = await Permission.camera.status;
    final photoStatus = await Permission.photos.status;
    setState(() {
      _cameraStatus = cameraStatus;
      _photoStatus = photoStatus;
    });
  }
}
