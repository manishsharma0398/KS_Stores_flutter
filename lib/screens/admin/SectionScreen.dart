import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './Products.dart';
import './AddEditForm.dart';
import '../../models/CategoryAndSections.dart';

class ProductSectionScreen extends StatefulWidget {
  static String routeName = "/sections";
  final String status;
  ProductSectionScreen({this.status = ""});

  @override
  ProductSectionScreenState createState() => ProductSectionScreenState();
}

class ProductSectionScreenState extends State<ProductSectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Categories"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditProductForm(
                    formType: "add",
                    productId: "",
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: GridView.builder(
          padding: EdgeInsets.all(5),
          itemCount: sectionList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        Products(title: sectionList[index].section),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.purpleAccent,
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: sectionList[index].imgUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, l) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.black38,
                          ),
                          child: Text(
                            sectionList[index].section,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
