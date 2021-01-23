import '../provider/product.dart';
import '../provider/products_provider.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class EditUserProduct extends StatefulWidget {
  static const routeName = 'editProduct';
  @override
  _EditUserProductState createState() => _EditUserProductState();
}

class _EditUserProductState extends State<EditUserProduct> {
  final priceFocusNode = FocusNode();
  final descFocusNode = FocusNode();
  final imageController = TextEditingController();
  final imageUrlFocusNode = FocusNode();
  final form = GlobalKey<FormState>();
  var editedProd = Product(id: null, title: '', desc: '', image: '', price: 0);
  var iNit=true;
  var isLoading= false;
  var initVal={
    'title':'',
    'desc':'',
    'price': '',
    'image': '',
  };

  @override
  void initState() {
    imageUrlFocusNode.addListener(updateImage);

    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(iNit){
     final productId= ModalRoute.of(context).settings.arguments as String;
     if(productId!= null){
editedProd= Provider.of<ProductsProvider>(context).findById(productId);
     initVal={
       'title': editedProd.title,
       'desc': editedProd.desc,
       'price': editedProd.price.toString(),
       'image': '',

     };
     imageController.text=editedProd.image;
     }
     
    }
    iNit=false;
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    imageUrlFocusNode.removeListener(updateImage);
    priceFocusNode.dispose();
    descFocusNode.dispose();
    imageController.dispose();
    imageUrlFocusNode.dispose();
    super.dispose();
  }

  void updateImage() {
    if (!imageUrlFocusNode.hasFocus) {
      if ((!imageController.text.startsWith('http') &&
              !imageController.text.startsWith('https')) ||
          (!imageController.text.endsWith('.png') &&
              !imageController.text.endsWith('.jpg') &&
              !imageController.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  void saveForm() {
    final isValid=form.currentState.validate();
    if(!isValid){
      return;
    }
    form.currentState.save();
    setState(() {
      isLoading=true;
    });
    if(editedProd.id!=null){
  Provider.of<ProductsProvider>(context).updateProd(editedProd.id, editedProd); 
  setState(() {
      isLoading=false;
    });
    Navigator.of(context).pop();
    }
    else{
  Provider.of<ProductsProvider>(context).addProduct(editedProd).then((_){
setState(() {
      isLoading=false;
    });
  Navigator.of(context).pop();
  }); 
    }
  
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: Icon(Icons.save),
          )
        ],
        title: Text('Edit Product'),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) :Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: initVal['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProd = Product(
                      id: editedProd.id,
                      isFavourite: editedProd.isFavourite,
                      title: value,
                      desc: editedProd.desc,
                      image: editedProd.image,
                      price: editedProd.price);
                },
              ),
              TextFormField(
                initialValue: initVal['price'],
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(descFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a price.';
                    }
                    if (int.parse(value) <= 0) {
                      return 'Please enter a number greater than 0';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    editedProd = Product(
                        id: editedProd.id,
                      isFavourite: editedProd.isFavourite,
                        title: editedProd.title,
                        desc: editedProd.desc,
                        image: editedProd.image,
                        price: int.parse(value));
                  }),
              TextFormField(
                initialValue: initVal['desc'],
                  decoration: InputDecoration(labelText: 'Description'),
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: descFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(imageUrlFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Description.';
                    }
                    if (value.length < 10) {
                      return 'Should be atleast 10 characters long. ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    editedProd = Product(
                        id: editedProd.id,
                      isFavourite: editedProd.isFavourite,
                        title: editedProd.title,
                        desc: value,
                        image: editedProd.image,
                        price: editedProd.price);
                  }),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  width: 130,
                  height: 130,
                  margin: EdgeInsets.only(top: 15, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: imageController.text.isEmpty
                      ? Text('Enter a Url')
                      : FittedBox(
                          child: Image.network(imageController.text,
                              fit: BoxFit.cover),
                        ),
                ),
                Expanded(
                  child: TextFormField(
                   
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageController,
                      focusNode: imageUrlFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a image Url.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid Url';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid Image Url';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        editedProd = Product(
                            id: editedProd.id,
                      isFavourite: editedProd.isFavourite,
                            title: editedProd.title,
                            desc: editedProd.desc,
                            image: value,
                            price: editedProd.price);
                      }),
                )
              ]),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(
                    child: RaisedButton(
                  onPressed: saveForm,
                  textColor: Colors.white70,
                  color: Theme.of(context).primaryColor,
                  child: Text('Submit'),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
