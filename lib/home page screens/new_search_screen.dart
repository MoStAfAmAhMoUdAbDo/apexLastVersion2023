// import 'package:apexxxxxxx/qr_scanner.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'cart_items.dart';
// import 'cart_screen.dart';
// import 'items.dart';
//
//
//
// class search_test extends StatefulWidget {
//   const search_test({Key? key}) : super(key: key);
//
//   @override
//   State<search_test> createState() => _search_testState();
// }
//
// class _search_testState extends State<search_test> {
//
//   // List<Item> myCart=[
//   //   Item(name:"s22", id:1, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"s23", id:2, price: 23,cpuVersion:"7core" , inStock: 50),
//   //   Item(name:"s24", id:3, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"s25", id:4, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"s26", id:5, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"s7", id:6, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"s5", id:7, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"s9", id:8, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"s11", id:9, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"s10", id:10, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"iphon", id:11, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"samsong", id:12, price: 22,cpuVersion:"8core" , inStock: 50),
//   //   Item(name:"relme", id:13, price: 22,cpuVersion:"8core" , inStock: 50),
//   //
//   // ];
//   List<Item>my_cart=[];
//   TextEditingController txtPriceControler=TextEditingController();
//   GlobalKey<ScaffoldState> _globalkey = new GlobalKey<ScaffoldState>();
//   @override
//   bool searchChange=true;
//   bool isOpend=true;
//   var search_val;
//   List<Item> new_listsearch = [];
//   bool isconvert = true;
//   int shopping_cart_count = 0;
//   int  qty_menue_count=0;
//   int  price_menue_count=0;
//   TextEditingController txt_value_controler=TextEditingController();
//   TextEditingController txt_search_controler=TextEditingController();
//   Widget build(BuildContext context) {
//     var result = ModalRoute.of(context)!.settings.arguments;
//      //isOpend=_globalkey.currentState!.isDrawerOpen;
//     return Scaffold(
//
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black
//         ),
//         backgroundColor: Colors.grey,
//         leading: IconButton(
//           onPressed: () {
//             if (_globalkey.currentState!.isDrawerOpen == false) {
//               setState(() {
//                 _globalkey.currentState!.openDrawer();
//               });
//
//             }
//             else{
//               _globalkey.currentState!.closeDrawer();
//             }
//           },
//           icon:isOpend?  Icon(Icons.dehaze) : Icon(Icons.arrow_back),
//         ),
//         title: searchChange ? Text("الصفحه الرئيسيه" ,style: TextStyle(color: Colors.black),) : search(),
//         actions: [
//           searchChange ? appBar() : Container(),
//         ],
//       ),
//       body:Scaffold(
//         //isOpend=false;
//         onDrawerChanged:(val){
//           if(val){
//             setState(() {
//               isOpend = !val;
//               print("the drawer is opend ${val}");
//             });
//           }else{
//             setState(() {
//               isOpend = !val;
//               print("the drawer is close ${val}");
//             });
//           }
//         },
//       key: _globalkey,
//         floatingActionButton: FloatingActionButton.large(
//           backgroundColor: Colors.indigo,
//           foregroundColor: Colors.white,
//           tooltip: "added to the card",
//           onPressed: () {
//             //HapticFeedback.vibrate();
//             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_basket()));
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.shopping_cart_rounded),
//
//               Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.white
//                   ),
//                   child:Consumer<Cart_Items>(builder: (context,prov,child){
//                     return Text("${prov.get_cart_count()}.0",style: TextStyle(color: Colors.black),);
//                   },)
//               ),
//             ],
//           ),
//         ),
//         drawer: Drawer(
//
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text("التصنيفات"),
//               Center(
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.description_sharp,
//                       color: Colors.indigo,
//                     ),
//                     Text(
//                       "No Categories",
//                       style: TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     //here some change
//                     isOpend= true;
//                     Navigator.of(context).pop();
//                     //Navigator.pushReplacementNamed(context, Main_Screen.rout);
//                   },
//                   child: Center(
//                     child: Text("جميع المنتجات"),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Container(
//             color: Colors.amber,
//             child: Center(
//               child: Container(
//                 child: Column(
//                   children: [
//                     Text(
//                       "the result of scanning is  ${result.toString()}",
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                     ),
//                     cheack(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//     ));
//   }
//
//   Widget appBar(){
//     return Row(
//       children: [
//         IconButton(
//           onPressed: () {
//             setState(() {
//               searchChange =false;
//             });
//           },
//           icon: const Icon(
//             Icons.search,
//           ),
//         ),
//         IconButton(
//           onPressed: () async{
//             Navigator.pushNamed(context, Qr_scanner.rout);
//             // Navigator.of(context).push(
//             //     MaterialPageRoute(builder: (context) => Qr_scanner()));
//             setState(() {});
//           },
//           icon: const Icon(
//             Icons.qr_code_scanner_outlined,
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             setState(() {
//               isconvert = !isconvert;
//             });
//             // print("in grid btn isconvert is : ${isconvert}");
//           },
//           icon: const Icon(
//             Icons.grid_on_outlined,
//           ),
//         ),
//
//       ],
//     );
//   }
//
//   Widget cheack() {
//     // print("the value of is convert is : ${isconvert}");
//     if (isconvert) {
//       return ListTile_convert();
//     } else
//       return Gridview_convert();
//   }
//
//   Widget search(){
//     return TextFormField(
//        controller: txt_search_controler,
//       decoration: text_field_style_search(),
//       autofocus: true,
//       cursorColor: Colors.black,
//       onChanged: (value) {
//          setState(() {
//            search_val =value;
//          });
//       },
//
//     );
//   }
//
//
//
//   Widget Gridview_convert() {
//     on_search();
//     return GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: new_listsearch.length,
//         // physics: NeverScrollableScrollPhysics(),
//         itemBuilder: (context, i) {
//           return Card(
//             color: Colors.grey,
//             child: ListTile(
//               onTap: () {
//                 print("the list of provider is ${Provider.of<Cart_Items>(context,listen: false).bascet_item.isEmpty ? "is empty " : "is not empty"}");
//                 txt_value_controler.text =new_listsearch[i].qty.toString();
//                 txtPriceControler.text =new_listsearch[i].price.toString();
//                 showDialog(context: context, builder: (context)=> Custom_dialog( i ));
//               },
//               title: Text("${new_listsearch[i].name}"),
//               subtitle: Text("${new_listsearch[i].price}"),
//               trailing: Text("${new_listsearch[i].cpuVersion}"),
//             ),
//           );
//         });
//   }
//
//   Widget ListTile_convert() {
//     on_search();
//     return ListView.builder(
//         itemCount: new_listsearch.length,
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemBuilder: (context, i) {
//           return Consumer<Cart_Items>(builder: (context,prov ,child){
//             return Card(
//               child: ListTile(
//                 onTap: () {
//
//                   txt_value_controler.text =new_listsearch[i].qty.toString();
//                   txtPriceControler.text =new_listsearch[i].price.toString();
//                   showDialog(context: context, builder: (context)=> Custom_dialog( i ));
//
//                 },
//                 title: Text("${new_listsearch[i].name}"),
//                 subtitle: Text("${new_listsearch[i].price}"),
//                 trailing: Text("${new_listsearch[i].cpuVersion}"),
//
//               ),
//             );
//           },);
//         });
//   }
//
//   InputDecoration text_field_style(){
//     return InputDecoration(
//         filled: true,
//         fillColor: Colors.grey[400],
//
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.black26),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.black ,width: 2),
//           borderRadius: BorderRadius.circular(25),
//         ));
//   }
//
//   InputDecoration text_field_style_search() {
//     return InputDecoration(
//         filled: true,
//         fillColor: Colors.grey,
//
//         hintText: "search",
//         border: InputBorder.none,
//
//         suffixIcon:         IconButton(
//           onPressed: (){
//             setState(() {
//               searchChange =true;
//               txt_search_controler.clear();
//               search_val=null;
//             });
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//         ),
//         prefixIcon:IconButton(
//           onPressed: (){
//            setState(() {
//              txt_search_controler.clear();
//              search_val=null;
//              //on_search();
//            });
//           },
//           icon: const Icon(
//             Icons.close,
//             color: Colors.black,
//           ),
//         ),
//
//
//     );
//   }
//   on_search() {
//     //print("in search fn ");
//     if (search_val == null) {
//       new_listsearch.clear();
//       for (var item in myCart) {
//         new_listsearch.add(item);
//       }
//     }
//     if (search_val != null) {
//       new_listsearch.clear();
//       for (var item in myCart) {
//         if (item.name.toLowerCase().contains(search_val.toString())) {
//           new_listsearch.add(item);
//         }
//       }
//     }
//   }
//
//   Widget Custom_dialog(int i ){
//     int count=0;
//     return  Consumer<Cart_Items>(builder: (context,provid,child){
//       return Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         child: Container(
//           height: 390,
//           child: Column(
//             children: [
//               Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(topLeft:Radius.circular(5) ,topRight:Radius.circular(5), ),
//                     color: Colors.indigo,
//                   ),
//                   width: double.infinity,
//                   alignment:Alignment.center,
//                   child: Text("${myCart[i].name}",style: TextStyle(fontSize: 50),)),
//
//               Container(
//                 height: 190,
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Text("سعر الوحده"),
//                         // SizedBox(width: 100,),
//                         Text("القيمه"),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Container(
//                           width: 100,
//                           child: TextFormField(
//                             controller: txtPriceControler,
//                             textAlign: TextAlign.center,
//                             decoration: text_field_style(),
//                           ),
//                         ),
//                         Container(
//                           width: 100,
//                           child: TextFormField(
//
//                             controller: txt_value_controler,
//                             decoration: text_field_style(),
//                             textAlign: TextAlign.center,
//
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 35),
//                       child: Row(
//                         //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         //mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(width: 37,),
//                           IconButton(onPressed: (){
//                             count=int.parse(txt_value_controler.text.toString());
//                             txt_value_controler.text=(++count).toString();
//
//                           }, icon: Icon(Icons.add_circle,size: 50)),
//                           SizedBox(width: 25,),
//                           Container(
//                             width: 50,
//                             child: TextFormField(
//                               controller: txtPriceControler,
//                               textAlign: TextAlign.center,
//                               decoration: text_field_style(),
//                             ),
//                           ),
//                           SizedBox(width: 5,),
//                           IconButton(onPressed: (){
//                             count=int.parse(txt_value_controler.text.toString());
//                             txt_value_controler.text=(--count).toString();
//                           }, icon: Icon(Icons.do_not_disturb_on,size: 50,)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: 70,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SizedBox(
//                     height: 50,
//                     width: 110,
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.indigo,
//                         ),
//                         onPressed: (){
//                           myCart[i].qty=int.parse(txt_value_controler.text);
//                           provid.add_item(myCart[i]);
//                           print("the total count of list in daialog is : ${provid.get_cart_count()}");
//                           Navigator.pop(context);
//                         }, child: Text("confirm")),
//                   ),
//                   SizedBox(
//                     height: 50,
//                     width: 110,
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.indigo,
//                         ),
//                         onPressed: (){
//                           Navigator.pop(context);
//                         }, child:  Text("cancel")),
//                   ),
//                 ],
//               ),
//
//             ],
//           ),
//         ),
//       );
//     },);
//   }
//
//   // Widget ListTile_convert() {
//   //   on_search();
//   //   return ListView.builder(
//   //       itemCount: new_listsearch.length,
//   //       shrinkWrap: true,
//   //       physics: NeverScrollableScrollPhysics(),
//   //       itemBuilder: (context, i) {
//   //         return Consumer<Cart_Items>(builder: (context,prov ,child){
//   //           return Card(
//   //             child: ListTile(
//   //               onTap: () {
//   //
//   //                 //txt_value_controler.text =new_listsearch[i].qty.toString();
//   //                 txtPriceControler.text =new_listsearch[i].price.toString();
//   //                 //showDialog(context: context, builder: (context)=> Custom_dialog( i ));
//   //
//   //               },
//   //               title: Text("${new_listsearch[i].name}"),
//   //               subtitle: Text("${new_listsearch[i].price}"),
//   //               trailing: Text("${new_listsearch[i].cpuVersion}"),
//   //
//   //             ),
//   //           );
//   //         },);
//   //       });
//   // }
// Widget popuo_menu(){
//     return PopupMenuButton(
//       icon: Icon(Icons.filter_list),
//         itemBuilder:(context)=>[
//       PopupMenuItem(child: Text("Item 1"),),
//       PopupMenuItem(child: Text("Item 2"),),
//       PopupMenuItem(child: Text("Item 3"),),
//     ] );
// }
//
// }
import 'package:apex/home%20page%20screens/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api_directory/get_home_data.dart';
import 'cart_items.dart';
import 'cart_screen.dart';
import '../models/items.dart';
import 'menu_provider.dart';

class search_test extends StatefulWidget {
  const search_test({Key? key}) : super(key: key);

  @override
  State<search_test> createState() => _search_testState();
}

class _search_testState extends State<search_test> {
  var searchValue;
  List<Item> myCart = [];
  TextEditingController txtPriceControler = TextEditingController();
  GlobalKey<ScaffoldState> _globalkey = new GlobalKey<ScaffoldState>();
  bool searchChange = true;
  bool isOpend = true;
  var search_val;
  List<Item> new_listsearch = [];
  bool isconvert = true;
  int shopping_cart_count = 0;
  int qty_menue_count = 0;
  int price_menue_count = 0;
  TextEditingController txt_value_controler = TextEditingController();
  TextEditingController txt_price_controler = TextEditingController();
  TextEditingController txt_search_controler = TextEditingController();

  late ScrollController _scrollController;
  bool isLoadMore = false;
  int pageNumber = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHomeData().getCategoryData(pageNumber,myCart.length-1).then((value) {
      setState(() {
        myCart.addAll(value);
      });
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollLisner);
  }

  Future<void> _scrollLisner() async {
    print("postion pixel ${_scrollController.position.pixels}");
    print("maxscrol pixel ${_scrollController.position.maxScrollExtent}");
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 1200.0) {
      setState(() {
        isLoadMore = true;
      });

      pageNumber++;
      await getHomeData().getCategoryData(pageNumber,myCart.length-1).then((value) {
        myCart.addAll(value);
      });

      setState(() {
        isLoadMore = false;
      });
    }
  }

  Widget build(BuildContext context) {
    var result = ModalRoute.of(context)!.settings.arguments;
    //isOpend=_globalkey.currentState!.isDrawerOpen;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey,
          leading: IconButton(
            onPressed: () {
              if (_globalkey.currentState!.isDrawerOpen == false) {
                setState(() {
                  _globalkey.currentState!.openDrawer();
                });
              } else {
                _globalkey.currentState!.closeDrawer();
              }
            },
            icon: isOpend ? Icon(Icons.dehaze) : Icon(Icons.arrow_back),
          ),
          title: searchChange
              ? Text(
                  "الصفحه الرئيسيه",
                  style: TextStyle(color: Colors.black),
                )
              : search(),
          actions: [
            searchChange ? appBar() : Container(),
          ],
        ),
        body: Scaffold(
          //isOpend=false;
          onDrawerChanged: (val) {
            if (val) {
              setState(() {
                isOpend = !val;
                //print("the drawer is opend ${val}");
              });
            } else {
              setState(() {
                isOpend = !val;
                print("the drawer is close ${val}");
              });
            }
          },
          key: _globalkey,
          floatingActionButton: FloatingActionButton.large(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            tooltip: "added to the card",
            onPressed: () {
              //HapticFeedback.vibrate();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => My_basket()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_rounded),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Consumer<Cart_Items>(
                      builder: (context, prov, child) {
                        return Text(
                          "${prov.get_cart_count()}.0",
                          style: TextStyle(color: Colors.black),
                        );
                      },
                    )),
              ],
            ),
          ),
          drawer: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("التصنيفات"),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.description_sharp,
                        color: Colors.indigo,
                      ),
                      Text(
                        "No Categories",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //here some change
                      isOpend = true;
                      Navigator.of(context).pop();
                      //Navigator.pushReplacementNamed(context, Main_Screen.rout);
                    },
                    child: Center(
                      child: Text("جميع المنتجات"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: myCart.isEmpty
              ? Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()),
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    color: Colors.white54,
                    child: Center(
                      child: Container(
                        child:
                        Column(
                          children: [
                            if(true)
                              Text("ugfebfhbf"),

                            Text(
                              "the result of scanning is  ${result.toString()}",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            cheack(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }

  var result;
  Widget appBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              searchChange = false;
            });
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: () async {
            result = await Navigator.pushNamed(context, Qr_scanner.rout);
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => Qr_scanner()));
            setState(() {});
          },
          icon: const Icon(
            Icons.qr_code_scanner_outlined,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              isconvert = !isconvert;
            });
            // print("in grid btn isconvert is : ${isconvert}");
          },
          icon: const Icon(
            Icons.grid_on_outlined,
          ),
        ),
      ],
    );
  }

  Widget cheack() {
    // print("the value of is convert is : ${isconvert}");
    if (isconvert) {
      return ListTile_convert();
    } else
      return Gridview_convert();
  }

  Widget search() {
    return TextFormField(
      controller: txt_search_controler,
      decoration: text_field_style_search(),
      autofocus: true,
      cursorColor: Colors.black,
      onChanged: (value) {
        setState(() {
          search_val = value;
        });
      },
    );
  }

  Widget Gridview_convert() {
    on_search();
    return GridView.builder(
        // controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10,),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: new_listsearch.length,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              txt_value_controler.text = new_listsearch[i].qty.toString();
              txt_price_controler.text =
                  new_listsearch[i].units[0].salePrice1.toString();
              showDialog(
                  context: context, builder: (context) => Custom_dialog(i));
            },
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: FittedBox(
                      child: new_listsearch[i].imageUrl == null
                          ? CircleAvatar(
                              child:
                                  Text(new_listsearch[i].itemTypeId.toString()),
                            )
                          : Image.network(
                              new_listsearch[i].imageUrl.toString()),
                    ),
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 20,
                      child: Text("${new_listsearch[i].latinName}")),
                  Text("${new_listsearch[i].units[0].salePrice1}"),
                ],
              ),
            ),
          );
        });
  }

  Widget ListTile_convert() {
    on_search();
    return ListView.builder(
        itemCount: new_listsearch.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          // if(i >= new_listsearch.length){
          //   return Center(child: CircularProgressIndicator());
          // }
          //   else{
          return Consumer<Cart_Items>(
            builder: (context, prov, child) {
              return Card(
                child: Consumer<menuProviderOptions>(
                  builder: (context, pro, child) {
                    if (pro.disableImage == false) {
                      return ListTile(
                        onTap: () {
                          //print("the list of provider is ${Provider.of<Cart_Items>(context,listen: false).bascet_item.isEmpty ? "is empty " : "is not empty"}");
                          if (pro.enablePopup == true) {
                            txt_value_controler.text =
                                new_listsearch[i].qty.toString();
                            txt_price_controler.text = new_listsearch[i]
                                .units[0]
                                .salePrice1
                                .toString();
                            showDialog(
                                context: context,
                                builder: (context) => Custom_dialog(i));
                          } else {
                            prov.add_item(myCart[i]);
                          }
                        },
                        title: Text("${new_listsearch[i].latinName}"),
                        subtitle:
                            Text("${new_listsearch[i].units[0].salePrice1}"),
                        trailing: CircleAvatar(
                            child: new_listsearch[i].imageUrl == null
                                ? Text(new_listsearch[i].itemTypeId.toString())
                                : Image.network(
                                    new_listsearch[i].imageUrl.toString())),
                      );
                    } else {
                      return ListTile(
                        onTap: () {
                          //print("the list of provider is ${Provider.of<Cart_Items>(context,listen: false).bascet_item.isEmpty ? "is empty " : "is not empty"}");
                          if (pro.enablePopup == true) {
                            txt_value_controler.text =
                                new_listsearch[i].qty.toString();
                            txt_price_controler.text = new_listsearch[i]
                                .units[0]
                                .salePrice1
                                .toString();
                            showDialog(
                                context: context,
                                builder: (context) => Custom_dialog(i));
                          } else {
                            prov.add_item(myCart[i]);
                          }
                        },
                        title: Text("${new_listsearch[i].latinName}"),
                        subtitle:
                            Text("${new_listsearch[i].units[0].salePrice1}"),
                      );
                    }
                  },
                ),
              );
            },
          );
          //}
        });
  }

  InputDecoration text_field_style() {
    return InputDecoration(
        filled: true,
        fillColor: Colors.grey[400],
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(25),
        ));
  }

  InputDecoration text_field_style_search() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey,
      hintText: "search",
      border: InputBorder.none,
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            searchChange = true;
            txt_search_controler.clear();
            search_val = null;
          });
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      prefixIcon: IconButton(
        onPressed: () {
          setState(() {
            txt_search_controler.clear();
            search_val = null;
            //on_search();
          });
        },
        icon: const Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
    );
  }

  on_search() {
    //print("in search fn ");
    if (searchValue == null) {
      new_listsearch.clear();
      for (var item in myCart) {
        new_listsearch.add(item);
      }
    }
    if (searchValue != null) {
      new_listsearch.clear();
      for (var item in myCart) {
        if (item.latinName!.toLowerCase().contains(searchValue.toString())) {
          new_listsearch.add(item);
          //print("the value in new list is ${new_listsearch[0]}");
        }
      }
    }
  }

  Widget Custom_dialog(int i) {
    int count = 0;
    return Consumer<Cart_Items>(
      builder: (context, provid, child) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 390,
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      color: Colors.indigo,
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "${myCart[i].latinName}",
                      style: TextStyle(fontSize: 50),
                    )),
                Container(
                  height: 190,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("سعر الوحده"),
                          // SizedBox(width: 100,),
                          Text("القيمه"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 100,
                            child: TextFormField(
                              controller: txtPriceControler,
                              textAlign: TextAlign.center,
                              decoration: text_field_style(),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: TextFormField(
                              controller: txt_value_controler,
                              decoration: text_field_style(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 37,
                            ),
                            IconButton(
                                onPressed: () {
                                  count = int.parse(
                                      txt_value_controler.text.toString());
                                  txt_value_controler.text =
                                      (++count).toString();
                                },
                                icon: Icon(Icons.add_circle, size: 50)),
                            SizedBox(
                              width: 25,
                            ),
                            Container(
                              width: 50,
                              child: TextFormField(
                                controller: txtPriceControler,
                                textAlign: TextAlign.center,
                                decoration: text_field_style(),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () {
                                  count = int.parse(
                                      txt_value_controler.text.toString());
                                  txt_value_controler.text =
                                      (--count).toString();
                                },
                                icon: Icon(
                                  Icons.do_not_disturb_on,
                                  size: 50,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 110,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                          ),
                          onPressed: () {
                            myCart[i].qty = double.parse(txt_value_controler.text);
                            provid.add_item(myCart[i]);
                            print(
                                "the total count of list in daialog is : ${provid.get_cart_count()}");
                            Navigator.pop(context);
                          },
                          child: Text("confirm")),
                    ),
                    SizedBox(
                      height: 50,
                      width: 110,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("cancel")),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget popuo_menu() {
    return PopupMenuButton(
        icon: Icon(Icons.filter_list),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Item 1"),
              ),
              PopupMenuItem(
                child: Text("Item 2"),
              ),
              PopupMenuItem(
                child: Text("Item 3"),
              ),
            ]);
  }
}
