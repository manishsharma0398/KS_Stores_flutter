import 'dart:io';
import 'package:KS_Stores/components/CommonButton.dart';
import 'package:KS_Stores/providers/ProductProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagesPreview extends StatefulWidget {
  final String formType;
  final Function returnImagesData;

  ImagesPreview({
    this.formType,
    this.returnImagesData,
  });

  @override
  _ImagesPreviewState createState() => _ImagesPreviewState();
}

class _ImagesPreviewState extends State<ImagesPreview> {
  List<Map<String, dynamic>> _allImages = [];
  bool _continueAdding = false;

  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final pickedFile =
        await picker.getImage(source: imageSource, imageQuality: 50);
    Provider.of<ProductProvider>(context, listen: false).addToAllImages({
      "path": File(
        pickedFile.path,
      ),
      "file": true
    });
    Provider.of<ProductProvider>(context, listen: false)
        .addToAddImgsList(File(pickedFile.path));
  }

  @override
  void initState() {
    // if (widget.formType == "update") {
    //   Map<String, dynamic> data =
    //       Provider.of<ProductProvider>(context, listen: false).formValues;
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _allImages = Provider.of<ProductProvider>(context).allImages;
    _continueAdding = Provider.of<ProductProvider>(context).continueEditingMode;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text("Select Images from either :"),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          btnText: "Camera"),
                    ),
                    Expanded(
                      child: CommonButton(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          btnText: "Gallery"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          // color: Colors.pinkAccent,
          height: 300,
          child: _allImages.length == 0
              ? Center(
                  child: Container(
                    child: Text(
                      'No images selected',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _allImages.length,
                  // separatorBuilder: null,
                  itemBuilder: (context, index) {
                    return imagePreview(_allImages[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget imagePreview(Map<String, dynamic> image) {
    return Container(
      key: UniqueKey(),
      decoration: BoxDecoration(border: Border.all(width: 3)),
      margin: EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          image['file']
              ? Image.file(
                  image['path'],
                  fit: BoxFit.contain,
                  key: UniqueKey(),
                )
              : CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl: image['path'],
                  fit: BoxFit.cover,
                ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  if (image['file']) {
                    Provider.of<ProductProvider>(context, listen: false)
                        .delFromAddImgsList(image['path']);
                    Provider.of<ProductProvider>(context, listen: false)
                        .removeFromAllImages(
                            true, (image['path'] as File).path);
                  } else {
                    Provider.of<ProductProvider>(context, listen: false)
                        .addToDelImgsList(image['path']);
                    Provider.of<ProductProvider>(context, listen: false)
                        .removeFromAllImages(false, image['path']);
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
