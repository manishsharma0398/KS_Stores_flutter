import 'package:KS_Stores/components/CommonButton.dart';
import 'package:KS_Stores/components/ImagesPreview.dart';
import 'package:KS_Stores/models/CategoryAndSections.dart';
import 'package:KS_Stores/providers/ProductProvider.dart';
import 'package:KS_Stores/screens/admin/SectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddingBulkPricesAndImages extends StatefulWidget {
  static String routeName = "/bulk-images";
  final String formType;
  final String category;
  final String productId;

  AddingBulkPricesAndImages(
      {@required this.formType, @required this.category, this.productId});

  @override
  _AddingBulkPricesAndImagesState createState() =>
      _AddingBulkPricesAndImagesState();
}

class _AddingBulkPricesAndImagesState extends State<AddingBulkPricesAndImages> {
  int _showBulk = 2;
  bool _isLoading = false;

  _getIndexForBulkTextConrollersOrFocusNodes(int index) {
    int upperBound = (index * 1) + (index - 1);
    int lowerBound = upperBound - 1;
    Map<String, int> bounds = {
      "upperBound": upperBound,
      "lowerBound": lowerBound,
    };
    return bounds;
  }

  final _bulk1QuantityController = TextEditingController();
  final _bulk1QuantityFocusNode = FocusNode();
  final _bulk1PriceController = TextEditingController();
  final _bulk1PriceFocusNode = FocusNode();
  final _bulk2QuantityController = TextEditingController();
  final _bulk2QuantityFocusNode = FocusNode();
  final _bulk2PriceController = TextEditingController();
  final _bulk2PriceFocusNode = FocusNode();
  final _bulk3QuantityController = TextEditingController();
  final _bulk3QuantityFocusNode = FocusNode();
  final _bulk3PriceController = TextEditingController();
  final _bulk3PriceFocusNode = FocusNode();
  final _bulk4QuantityController = TextEditingController();
  final _bulk4QuantityFocusNode = FocusNode();
  final _bulk4PriceController = TextEditingController();
  final _bulk4PriceFocusNode = FocusNode();
  final _bulk5QuantityController = TextEditingController();
  final _bulk5QuantityFocusNode = FocusNode();
  final _bulk5PriceController = TextEditingController();
  final _bulk5PriceFocusNode = FocusNode();

  List<TextEditingController> _bulkTextEditingControllers;
  List<FocusNode> _bulkFocusNodes;
  _fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    _bulkTextEditingControllers = [
      _bulk1PriceController,
      _bulk1QuantityController,
      _bulk2PriceController,
      _bulk2QuantityController,
      _bulk3PriceController,
      _bulk3QuantityController,
      _bulk4PriceController,
      _bulk4QuantityController,
      _bulk5PriceController,
      _bulk5QuantityController,
    ];
    _bulkFocusNodes = [
      _bulk1PriceFocusNode,
      _bulk1QuantityFocusNode,
      _bulk2PriceFocusNode,
      _bulk2QuantityFocusNode,
      _bulk3PriceFocusNode,
      _bulk3QuantityFocusNode,
      _bulk4PriceFocusNode,
      _bulk4QuantityFocusNode,
      _bulk5PriceFocusNode,
      _bulk5QuantityFocusNode,
    ];
    Map<String, dynamic> data =
        Provider.of<ProductProvider>(context, listen: false).formValues;
    for (var i = 1; i <= data['bulkPrices'].length; i++) {
      Map<String, int> quantityIndex =
          _getIndexForBulkTextConrollersOrFocusNodes(i);
      _bulkTextEditingControllers[quantityIndex["upperBound"]].text =
          data['bulkPrices'][i - 1]["price"].toString();
      _bulkTextEditingControllers[quantityIndex["lowerBound"]].text =
          data['bulkPrices'][i - 1]["quantity"].toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding Images and Bulk Prices"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ImagesPreview(
                    formType: widget.formType,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 25,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Bulk Prices',
                          style: TextStyle(fontSize: 18),
                        ),
                        for (var i = 1; i <= _showBulk; i++)
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Bulk Quantity"),
                                  focusNode: _bulkFocusNodes[
                                      _getIndexForBulkTextConrollersOrFocusNodes(
                                          i)['lowerBound']],
                                  controller: _bulkTextEditingControllers[
                                      _getIndexForBulkTextConrollersOrFocusNodes(
                                          i)['lowerBound']],
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () {
                                    _fieldFocusChange(
                                        context,
                                        _bulkFocusNodes[
                                            _getIndexForBulkTextConrollersOrFocusNodes(
                                                i)['lowerBound']],
                                        _bulkFocusNodes[
                                            _getIndexForBulkTextConrollersOrFocusNodes(
                                                i)['upperBound']]);
                                  },
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: "Price"),
                                  focusNode: _bulkFocusNodes[
                                      _getIndexForBulkTextConrollersOrFocusNodes(
                                          i)['upperBound']],
                                  controller: _bulkTextEditingControllers[
                                      _getIndexForBulkTextConrollersOrFocusNodes(
                                          i)['upperBound']],
                                  textInputAction: TextInputAction.done,
                                  // onEditingComplete: () {},
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        if (_showBulk < 5)
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                if (_showBulk < 5) {
                                  print(_showBulk);
                                  setState(() {
                                    _showBulk = _showBulk + 1;
                                  });
                                  print(_showBulk);
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  CommonButton(
                    onPressed: () => submitForm(),
                    btnText: widget.formType == "add"
                        ? "Add Product"
                        : "Update Product",
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }

  List<Map<String, int>> _getBulkPricesInList() {
    List<Map<String, int>> _bulkData = [];
    for (var i = 1; i <= _showBulk; i++) {
      String quantity = _bulkTextEditingControllers[
              _getIndexForBulkTextConrollersOrFocusNodes(i)['lowerBound']]
          .text;
      String price = _bulkTextEditingControllers[
              _getIndexForBulkTextConrollersOrFocusNodes(i)['upperBound']]
          .text;
      if (quantity != "" && price != "") {
        _bulkData.add({
          "quantity": int.parse(quantity),
          "price": int.parse(price),
        });
      }
    }
    return _bulkData;
  }

  String _getProductSection(String category) {
    String _section;
    for (var i = 0; i < sectionList.length; i++) {
      for (var j = 0; j < sectionList[i].categories.length; j++) {
        if (category == sectionList[i].categories[j].category) {
          _section = sectionList[i].section;
          return _section;
        }
      }
    }
    return _section;
  }

  submitForm() async {
    setState(() {
      _isLoading = true;
    });

    FocusManager.instance.primaryFocus.unfocus();

    Provider.of<ProductProvider>(context, listen: false).setProductValues({
      "bulkPrices": _getBulkPricesInList(),
      "section": _getProductSection(widget.category),
    });

    if (widget.formType == "add") {
      await Provider.of<ProductProvider>(context, listen: false)
          .addNewProduct();
    } else {
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(widget.productId);
    }

    setState(() {
      _isLoading = false;
    });

    bool goToHomePage = await showCRUDstatus(status: "success");

    if (goToHomePage) {
      Provider.of<ProductProvider>(context, listen: false).clearAll();
      Navigator.of(context).pushNamedAndRemoveUntil(
          ProductSectionScreen.routeName, (route) => false);
    } else {
      Provider.of<ProductProvider>(context, listen: false)
          .continueEditingModeSet(true);
      Provider.of<ProductProvider>(context, listen: false).setProductValues({
        "images": [],
      });
    }

    // Map<String, String> tryAgain = await showCRUDstatus(status: "error");
    // if (tryAgain["tryAgain"] == "yes") {
    //   submitForm();
    // }
  }

  Future<dynamic> showCRUDstatus({String status}) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            status == "success" ? "Successfuly Added" : "Error Occured",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/${status == "success" ? "success" : "error"}.svg",
                fit: BoxFit.cover,
                width: 60,
              )
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          actions: [
            if (status == "success")
              FlatButton(
                child: Text(
                  "Add With Some Changes",
                  style: TextStyle(
                    color: Colors.green[900],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            if (status == "error")
              FlatButton(
                child: Text(
                  "Try Again",
                  style: TextStyle(
                    color: Colors.green[900],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop({"tryAgain": "yes"});
                },
              ),
            if (status == "success")
              FlatButton(
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.green[900],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
          ],
        );
      },
    );
  }
}
