import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/CustomTextFormField.dart';
import '../../components/CommonButton.dart';
import '../../models/Unit.dart';
import '../../models/CategoryAndSections.dart';
import '../../providers/ProductProvider.dart';
import './AddingBulkPricesAndImages.dart';

class AddEditProductForm extends StatefulWidget {
  static String routeName = "/add-edit-form";
  final String formType;
  final String productId;

  AddEditProductForm({
    this.formType,
    this.productId,
  });

  @override
  _AddEditProductFormState createState() => _AddEditProductFormState();
}

class _AddEditProductFormState extends State<AddEditProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productNameFocusNode = FocusNode();
  final _quantityController = TextEditingController();
  final _quantityFocusNode = FocusNode();
  final _priceController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _descriptionController = TextEditingController();
  final _descriptionFocusNode = FocusNode();

  Unit _selectedUnit;
  List<Unit> _unitDropdownList = [];
  List<DropdownMenuItem<Unit>> _unitDropdownMenuItems;
  Category _selectedCategory;
  List<Category> _categoryDropdownList = [];
  List<DropdownMenuItem<Category>> _categoryDropdownMenuItems;

  @override
  void initState() {
    for (var i = 0; i < sectionList.length; i++) {
      for (var j = 0; j < sectionList[i].categories.length; j++) {
        _categoryDropdownList.add(
          Category(category: sectionList[i].categories[j].category),
        );
      }
    }
    _categoryDropdownMenuItems =
        buildCategoryDropDownMenuItems(_categoryDropdownList);
    for (var i = 0; i < unitsList.length; i++) {
      _unitDropdownList.add(unitsList[i]);
    }
    _unitDropdownMenuItems = buildUnitDropDownMenuItems(_unitDropdownList);
    if (widget.formType == "add") {
      _selectedCategory = _categoryDropdownMenuItems[0].value;
      _selectedUnit = _unitDropdownMenuItems[0].value;
    }
    if (widget.formType != "add") {
      Provider.of<ProductProvider>(context, listen: false)
          .prefillFormValues(widget.productId)
          .then((data) {
        print("######################");
        print(data);
        print("######################");
        setState(() {
          _productNameController.text = data['name'];
          _quantityController.text = data['quantity'].toString();
          _selectedUnit = _prefillUnitValue(data['unit']);
          _priceController.text = data['amount'].toString();
          _selectedCategory = _prefillCategoryValue(data['category']);
          _descriptionController.text = data['desc'];
        });
      });
    }
    super.initState();
  }

  List<DropdownMenuItem<Unit>> buildUnitDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<Unit>> items = List();
    for (Unit listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text("${listItem.unit} (${listItem.abbr})"),
          value: listItem,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Category>> buildCategoryDropDownMenuItems(
      List listItems) {
    List<DropdownMenuItem<Category>> items = List();
    for (Category listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.category),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Category _prefillCategoryValue(String cat) {
    Category val;
    for (var i = 0; i < _categoryDropdownMenuItems.length; i++) {
      if (cat == _categoryDropdownMenuItems[i].value.category) {
        val = _categoryDropdownMenuItems[i].value;
      }
    }
    return val;
  }

  Unit _prefillUnitValue(String cat) {
    Unit val;
    for (var i = 0; i < _unitDropdownMenuItems.length; i++) {
      if (cat == _unitDropdownMenuItems[i].value.abbr) {
        val = _unitDropdownMenuItems[i].value;
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ProductProvider>(context, listen: false).clearAll();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Provider.of<ProductProvider>(context, listen: false).clearAll();
                Navigator.of(context).pop();
              }),
          title: Text(widget.formType == "add"
              ? "Adding New Product"
              : "Updating Product"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus();
                FocusManager.instance.primaryFocus.unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    CustomTextFormField(
                      placeholder: "Product Title",
                      label: "Product Name",
                      currentFocusNode: _productNameFocusNode,
                      nextFocusNode: _quantityFocusNode,
                      controller: _productNameController,
                    ),
                    Row(
                      children: [
                        // quantity
                        Expanded(
                          flex: 1,
                          child: CustomTextFormField(
                            controller: _quantityController,
                            currentFocusNode: _quantityFocusNode,
                            label: "Quantity",
                            placeholder: "Quantity",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 10),
                        // ? Unit Dropdown
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 31.0),
                            child: DropdownButton<Unit>(
                                value: _selectedUnit,
                                items: _unitDropdownMenuItems,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedUnit = value;
                                  });
                                }),
                          ),
                        ),
                      ],
                    ),
                    // ? Price
                    CustomTextFormField(
                      placeholder: "Price",
                      controller: _priceController,
                      currentFocusNode: _priceFocusNode,
                      label: "Price (in rupees)",
                      keyboardType: TextInputType.number,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: DropdownButton<Category>(
                          isExpanded: true,
                          value: _selectedCategory,
                          items: _categoryDropdownMenuItems,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                    ),
                    // ? Description
                    CustomTextFormField(
                      placeholder: "Description",
                      controller: _descriptionController,
                      currentFocusNode: _descriptionFocusNode,
                      label: "Product Description",
                      maxLines: 5,
                    ),
                    SizedBox(height: 10),
                    CommonButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Provider.of<ProductProvider>(context, listen: false)
                            .setProductValues(
                          {
                            "name": _productNameController.text,
                            "quantity": int.parse(_quantityController.text),
                            "unit": _selectedUnit.abbr,
                            "amount": int.parse(_priceController.text),
                            "category": _selectedCategory.category,
                            "desc": _descriptionController.text.trim(),
                          },
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddingBulkPricesAndImages(
                              formType: widget.formType,
                              category: _selectedCategory.category,
                              productId: widget.productId,
                            ),
                          ),
                        );
                      },
                      btnText: "NEXT",
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
