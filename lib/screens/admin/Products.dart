import 'package:KS_Stores/screens/admin/AddEditForm.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import './ProductForm.dart';

class Products extends StatefulWidget {
  final String title;
  const Products({@required this.title});

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("products")
              .where("section", isEqualTo: widget.title)
              .get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Text("No Products added.. Please add some"),
                );
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final dataAtThisIteration =
                        snapshot.data.docs[index].data();
                    return Card(
                      child: ListTile(
                        leading: Container(
                          width: 80,
                          child: CachedNetworkImage(
                            imageUrl:
                                (dataAtThisIteration['images'] as List).length >
                                        0
                                    ? dataAtThisIteration['images'][0]
                                    : "",
                            errorWidget: (context, url, error) =>
                                FittedBox(child: Text("error loading")),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            fit: BoxFit.contain,
                          ),
                        ),
                        title: Text(dataAtThisIteration['name']),
                        // subtitle: ,
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddEditProductForm(
                                        formType: "update",
                                        productId: snapshot.data.docs[index].id,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.create),
                                label: Text("Update "),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddEditProductForm(
                                        formType: "update&add",
                                        productId: snapshot.data.docs[index].id,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add),
                                label: Text("Add with update"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
