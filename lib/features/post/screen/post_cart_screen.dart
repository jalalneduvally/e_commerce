import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Model_class/cart_model.dart';
import 'package:e_commerce/Model_class/user_model.dart';
import 'package:e_commerce/features/HomeScreen/feed_screen.dart';
import 'package:e_commerce/features/post/screen/post_details_screen.dart';
import 'package:e_commerce/features/post/screen/product_check_out.dart';
import 'package:e_commerce/features/product/controller/product_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model_class/product_model.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/firebase_constants.dart';
import '../../../core/common/loader.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../main.dart';
import '../../auth/controller/auth_controller.dart';

class PostCartScreen extends ConsumerStatefulWidget {
  const PostCartScreen({super.key});

  @override
  ConsumerState createState() => _PostCartScreenState();
}

class _PostCartScreenState extends ConsumerState<PostCartScreen> {
  void removeCart(WidgetRef ref, BuildContext context, Map product) async {
    ref.read(productControllerProvider.notifier).removeCart(context, product);
  }

  final counterProvider = StateProvider.autoDispose<int>((ref) => 1);

  void updateCart(WidgetRef ref, UserModel user, List cart) async {
    ref
        .read(productControllerProvider.notifier)
        .updateCart(user, context, cart);
  }

  double total = 0;
  int cartIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final count=ref.watch(productCounterProvider);

    return ref
        .watch(getCartProductProvider(ref.watch(userProvider)?.id ?? ''))
        .when(
          data: (data) {
            total=0;
            for (int i = 0; i < data.cart.length; i++) {
              total += data.cart[i]["quantity"] *
                  data.cart[i]["price"];
            }
            return data == null
                ? const Center(child: Text('noData'))
                : Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: const Text("Cart"),
              ),
              floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Container(
                height: w * 0.25,
                width: w * 1,
                padding: EdgeInsets.all(w * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(w * 0.03),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " Total",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: w * 0.06),
                        ),
                        Text(
                          " ₹$total",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.06,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CheckOutScreen(price: total),
                            ));
                      },
                      child: Container(
                        height: w * 0.12,
                        width: w * 0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(w * 0.05),
                            color: Colors.deepOrange),
                        child: Center(
                          child: Text(
                            "Check Out",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.055,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: w * 1.67,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: data.cart.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final cart = data.cart[index];
                        return Padding(
                          padding: EdgeInsets.all(w * 0.03),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(w * 0.03),
                                border: Border.all(color: Colors.white)),
                            child: SizedBox(
                              height: w * 0.5,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: w * 0.4,
                                    width: w * 0.3,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                        image: DecorationImage(
                                            image:
                                            NetworkImage(cart["image"]),
                                            fit: BoxFit.cover)),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("Name: ${cart["prdctName"]}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: w * 0.04)),
                                      Text("Brand: ${cart["brand"]}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: w * 0.04)),
                                      Text("Color: ${cart["color"]}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: w * 0.04)),
                                      Text("Size: ${cart["size"]}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: w * 0.04)),
                                      Text(
                                        "quantity: ${cart["quantity"]}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "discount: ${cart["discount"]}%",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          "price: ${cart["price"].toString()}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: w * 0.04)),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () =>
                                            removeCart(ref, context, cart),
                                        child: Container(
                                          height: w * 0.1,
                                          width: w * 0.1,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                            size: w * 0.07,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Total:\n ${cart["quantity"] * cart["price"]}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: w * 0.06),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              var a = CartModel(
                                                prdctName:
                                                cart["prdctName"],
                                                price: cart["price"],
                                                image: cart["image"],
                                                id: cart["id"],
                                                category: cart["category"],
                                                brand: cart["brand"],
                                                color: cart["color"],
                                                size: cart["size"],
                                                quantity:
                                                cart["quantity"] == 1
                                                    ? cart["quantity"] =
                                                1
                                                    : cart["quantity"] -
                                                    1,
                                                discount: cart["discount"],
                                              );
                                              final snapshot = await ref
                                                  .read(firestoreProvider)
                                                  .collection(
                                                  Constants.user)
                                                  .doc(ref
                                                  .read(userProvider)!
                                                  .id)
                                                  .get();
                                              UserModel model =
                                              UserModel.fromjson(
                                                  snapshot.data());
                                              if (model.cartId
                                                  .contains(cart["id"])) {
                                                for (int i = 0;
                                                i < model.cart.length;
                                                i++) {
                                                  if (cart["prdctName"] ==
                                                      model.cart[i][
                                                      "prdctName"] &&
                                                      cart["image"] ==
                                                          model.cart[i]
                                                          ["image"] &&
                                                      cart["category"] ==
                                                          model.cart[i][
                                                          "category"] &&
                                                      cart["brand"] ==
                                                          model.cart[i]
                                                          ["brand"] &&
                                                      cart["color"] ==
                                                          model.cart[i]
                                                          ["color"] &&
                                                      cart["size"] ==
                                                          model.cart[i]
                                                          ["size"]) {
                                                    cartIndex = i;
                                                    var cart = model.cart;
                                                    cart.removeAt(
                                                        cartIndex);
                                                    cart.insert(cartIndex,
                                                        a.toJson());
                                                    updateCart(
                                                        ref, model, cart);
                                                    break;
                                                  }
                                                }
                                              }
                                            },
                                            child: Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.white,
                                                size: w * 0.1),
                                          ),
                                          SizedBox(
                                            width: w * 0.01,
                                          ),
                                          Text(
                                            "${cart["quantity"]}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: w * 0.01,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              var a = CartModel(
                                                prdctName:
                                                cart["prdctName"],
                                                price: cart["price"],
                                                image: cart["image"],
                                                id: cart["id"],
                                                category: cart["category"],
                                                brand: cart["brand"],
                                                color: cart["color"],
                                                size: cart["size"],
                                                quantity:
                                                cart["quantity"] + 1,
                                                discount: cart["discount"],
                                              );
                                              final snapshot = await ref
                                                  .read(firestoreProvider)
                                                  .collection(
                                                  Constants.user)
                                                  .doc(ref
                                                  .read(userProvider)!
                                                  .id)
                                                  .get();
                                              UserModel model =
                                              UserModel.fromjson(
                                                  snapshot.data());
                                              if (model.cartId
                                                  .contains(cart["id"])) {
                                                for (int i = 0;
                                                i < model.cart.length;
                                                i++) {
                                                  if (cart["prdctName"] ==
                                                      model.cart[i][
                                                      "prdctName"] &&
                                                      cart["image"] ==
                                                          model.cart[i]
                                                          ["image"] &&
                                                      cart["category"] ==
                                                          model.cart[i][
                                                          "category"] &&
                                                      cart["brand"] ==
                                                          model.cart[i]
                                                          ["brand"] &&
                                                      cart["color"] ==
                                                          model.cart[i]
                                                          ["color"] &&
                                                      cart["size"] ==
                                                          model.cart[i]
                                                          ["size"]) {
                                                    cartIndex = i;
                                                    var cart = model.cart;
                                                    cart.removeAt(
                                                        cartIndex);
                                                    cart.insert(cartIndex,
                                                        a.toJson());
                                                    updateCart(
                                                        ref, model, cart);
                                                    break;
                                                  }
                                                }
                                              }
                                            },
                                            child: Icon(
                                                Icons
                                                    .add_circle_outline_outlined,
                                                color: Colors.white,
                                                size: w * 0.1),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: w * 0.01,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
