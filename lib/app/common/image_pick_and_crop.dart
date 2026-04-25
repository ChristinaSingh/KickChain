import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kickchain/app/common/text_styles.dart';
import '../data/constants/string_constants.dart';
import 'common_pickImage.dart';

class ImagePickerAndCropper {
  String string = "";

  static List<File> convertXFilesToFiles({required List<XFile> xFiles}) {
    List<File> files = xFiles.map((xFile) => File(xFile.path)).toList();
    return files;
  }

  static Future<File?> pickImage({
    bool pickImageFromGallery = false,
    bool wantCropper = false,
    required BuildContext context,
    Color color = Colors.lightGreenAccent,
  }) async {
    XFile? imagePicker;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MyAlertDialog(
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                StringConstants.camera,
                style: MyTextStyle.titleStyle12bb,
              ),
              onPressed: () async {
                pickImageFromGallery = false;
                try {
                  imagePicker =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                } catch (e) {
                  //handle error
                  print('e:::::::::::::$e');
                }
                Get.back();
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                StringConstants.gallery,
                style: MyTextStyle.titleStyle12bb,
              ),
              onPressed: () async {
                pickImageFromGallery = true;
                try {
                  imagePicker = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                } catch (e) {
                  //handle error
                  print('e:::::::::::::$e');
                }
                Get.back();
              },
            ),
          ],
          title: Text(StringConstants.selectImage,
              style: MyTextStyle.titleStyle18bb),
          content: Text(
            StringConstants.chooseImageFromTheOptionsBelow,
            style: MyTextStyle.titleStyle14bb,
          ),
        );
      },
    );

    if (imagePicker != null) {
      if (wantCropper) {
        CroppedFile? cropImage = await ImageCropper().cropImage(
          sourcePath: imagePicker!.path,
          compressQuality: 80,
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: color,
              toolbarTitle: "Cropper",
              activeControlsWidgetColor: color,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
            IOSUiSettings(
              title: "Cropper",
              aspectRatioLockEnabled: false,
            ),
          ],
        );

        if (cropImage != null) {
          return File(cropImage.path);
        } else {
          // return File(imagePicker.path);
          return null;
        }
      } else {
        //return File(imagePicker.path);
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<XFile>> pickMultipleImages() async {
    final ImagePicker imagePicker = ImagePicker();
    List<XFile> imageFileList = [];

    final List<XFile> selectedImages = await imagePicker.pickMultiImage() ?? [];
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
      if (kDebugMode) {
        print("Selected Image List Length:${imageFileList.length}");
      }
      return imageFileList;
    } else {
      return [];
    }
  }
}
