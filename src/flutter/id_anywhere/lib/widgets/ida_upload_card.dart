import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:id_anywhere/helper/media_helper.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:id_anywhere/service/service_result.dart';
import 'package:image_picker/image_picker.dart';

class IDAnywhereUploadCard extends StatefulWidget {
  IDAnywhereUploadCard(
      {Key key,
      this.title,
      this.validateImageCallback,
      this.informationDialog,
      this.complete,
      this.flag})
      : super(key: key);

  final String title;

  final Future<ServiceResult> Function(File) validateImageCallback;

  final SimpleDialog informationDialog;

  final String flag;

  final bool complete;

  @override
  State createState() {
    return _IDAnywhereUploadCardState(
        title: this.title,
        imageSelectedCallback: this.validateImageCallback,
        informationDialog: this.informationDialog,
        complete: this.complete,
        flag: this.flag);
  }
}

class _IDAnywhereUploadCardState extends State<IDAnywhereUploadCard>
    with SingleTickerProviderStateMixin {
  _IDAnywhereUploadCardState(
      {this.title,
      this.imageSelectedCallback,
      this.informationDialog,
      this.flag,
      this.complete});

  final String title;
  final bool complete;
  final String flag;
  final Future<ServiceResult> Function(File) imageSelectedCallback;
  final SimpleDialog informationDialog;

  AnimationController _animationController;
  bool uploaded = false;
  Animation _colorTween;

  void upload() async {
    // Select a picture, then pass that picture to the image selected callback

    if (this.informationDialog != null) {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => this.informationDialog);
    }

    MediaOption mediaOption = await MediaHelper.getUserMediaChoice(context);
    if (mediaOption != null) {
      final image = await ImagePicker.pickImage(
          imageQuality: 100,
          source: mediaOption == MediaOption.CAMERA
              ? ImageSource.camera
              : ImageSource.gallery);

      final result = await this.imageSelectedCallback(image);

      if (result.valid()) {
        // Show a snackbar that it worked
        // also run the animator.
        setState(() {
          uploaded = true;
        });
        await _animationController.forward();
        // Get the flag to state that it is uploaded.
        resolver<FlutterSecureStorage>().write(key: this.flag, value: 'true');
        return;
      }

      // Show a snackbar that it did not validate.
      return;
    }
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _colorTween = ColorTween(begin: Colors.pinkAccent, end: Colors.green)
        .animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If this is uploaded

    return AnimatedBuilder(
        animation: _colorTween, builder: (context, child) => _card());
  }

  Center _card() => Center(
        child: Card(
          color: widget.complete ? Colors.green : _colorTween.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.image_aspect_ratio, color: Colors.white),
                title: Text(
                  this.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Open Sans",
                      fontSize: 22),
                ),
                subtitle: Text(
                    uploaded || widget.complete
                        ? 'Uploaded'
                        : 'Please select and upload',
                    style: TextStyle(color: Colors.white)),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: uploaded || widget.complete
                        ? null
                        : const Text('Upload',
                            style: TextStyle(color: Colors.white)),
                    onPressed: uploaded || widget.complete ? null : upload,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
