import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/provider/providerExports.dart';
import 'package:e_commerce_app/screens/cartScreen.dart';
import 'package:e_commerce_app/screens/contactUs.dart';
import 'package:e_commerce_app/screens/contactUs2.dart';
import 'package:e_commerce_app/screens/detailScreen.dart';
import 'package:e_commerce_app/screens/listProduct.dart';
import 'package:e_commerce_app/screens/screensExports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:e_commerce_app/model/modelExports.dart';
import 'package:e_commerce_app/widgets/widgetsExports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Product? menData;
Product? womenData;
Product? bulbData;
Product? smartPhoneData;

var featureSnapShot;
var newAchivesSnapShot;

CategoryProvider? categoryProvider;
ProductProvider? productProvider;

UserModel? userModel;

class _HomePageState extends State<HomePage> {
  Widget _buildCategoryProduct({required String image, required int color}) {
    return CircleAvatar(
      maxRadius: 37,
      backgroundColor: Color(color),
      child: Container(
        height: 45,
        child: Image(
          color: Colors.white,
          image: NetworkImage(image),
        ),
      ),
    );
  }

  bool homeColor = true;
  bool cartColor = false;
  bool aboutColor = false;
  bool contactUsColor = false;
  bool profileColor = false;

  Widget _buildUserAccountsDrawerHeader() {
    List<UserModel> userModel = productProvider!.userModelList;
    return Column(
      children: userModel.map((e) {
        return UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xfff8f8f8),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: e.userImage == null
                ? AssetImage('assets/images/User Image.png')
                : NetworkImage(e.userImage ?? "") as ImageProvider,
          ),
          accountName: Text(
            e.userName!,
            style: TextStyle(color: Colors.black),
          ),
          accountEmail: Text(
            e.userEmail!,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUserAccountsDrawerHeader2() {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          var myDoc = snapshot.data!.docs;
          myDoc.forEach((checkDocs) {
            if (checkDocs.data()['UserId'].toString() == user!.uid) {
              userModel = UserModel(
                userName: checkDocs.data()['UserName'].toString(),
                userEmail: checkDocs.data()['UserEmail'].toString(),
                userImage: checkDocs.data()['UserImage'],
              );
            }
          });
          return Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xfff8f8f8),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: userModel!.userImage == null
                      ? AssetImage('assets/images/User Image.png')
                      : NetworkImage(userModel!.userImage ?? "")
                          as ImageProvider,
                ),
                accountName: Text(
                  userModel!.userName!,
                  style: TextStyle(color: Colors.black),
                ),
                accountEmail: Text(
                  userModel!.userEmail!,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildMyDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _buildUserAccountsDrawerHeader2(),
          ListTile(
            selected: homeColor,
            onTap: () {
              setState(() {
                homeColor = true;
                contactUsColor = false;
                cartColor = false;
                aboutColor = false;
                profileColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            leading: const Icon(Icons.home),
            title: const Text('Home'),
          ),
          ListTile(
            selected: cartColor,
            onTap: () {
              setState(() {
                cartColor = true;
                contactUsColor = false;
                homeColor = false;
                profileColor = false;
                aboutColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
          ),
          ListTile(
            selected: aboutColor,
            onTap: () {
              setState(() {
                aboutColor = true;
                contactUsColor = false;
                cartColor = false;
                profileColor = false;
                homeColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AboutUs(),
                ),
              );
            },
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
          ),
          ListTile(
            selected: profileColor,
            onTap: () {
              setState(() {
                aboutColor = false;
                contactUsColor = false;
                cartColor = false;
                profileColor = true;
                homeColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            leading: const Icon(Icons.face),
            title: const Text('Profile'),
          ),
          ListTile(
            selected: contactUsColor,
            onTap: () {
              setState(() {
                contactUsColor = true;
                homeColor = false;
                cartColor = false;
                aboutColor = false;
                profileColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ContactUs2(),
                ),
              );
            },
            leading: const Icon(Icons.phone),
            title: const Text('Contact Us'),
          ),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    return Container(
      height: 240,
      child: Carousel(
        boxFit: BoxFit.fill,
        autoplay: true,
        showIndicator: false,
        images: const [
          AssetImage('assets/images/Shirt 2.png'),
          AssetImage('assets/images/Hood.png'),
          AssetImage('assets/images/Man Watch 2.jpg'),
          AssetImage('assets/images/Shoe 6.jpg'),
          AssetImage('assets/images/Suits.jpg'),
        ],
      ),
    );
  }

  Widget _buildDressIcon() {
    List<Product> dress = categoryProvider!.getDressList;
    List<CategoryIcon> dressIcon = categoryProvider!.getDressIcon;
    return Row(
      children: dressIcon.map(
        (e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ListProduct(name: 'Dress', snapShot: dress),
                ),
              );
            },
            child: _buildCategoryProduct(image: e.image, color: 0xff33dcfd),
          );
        },
      ).toList(),
    );
  }

  Widget _buildShirtIcon() {
    List<Product> shirts = categoryProvider!.getShirtList;
    List<CategoryIcon> shirtIcon = categoryProvider!.getShirtIcon;
    return Row(
      children: shirtIcon.map(
        (e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ListProduct(name: 'Shirt', snapShot: shirts),
                ),
              );
            },
            child: _buildCategoryProduct(image: e.image, color: 0xfff38cdd),
          );
        },
      ).toList(),
    );
  }

  Widget _buildShoeIcon() {
    List<Product> shoes = categoryProvider!.getshoesList;
    List<CategoryIcon> shoeIcon = categoryProvider!.getShoeIcon;
    return Row(
      children: shoeIcon.map(
        (e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ListProduct(name: 'Shoe', snapShot: shoes),
                ),
              );
            },
            child: _buildCategoryProduct(image: e.image, color: 0xff4ff2af),
          );
        },
      ).toList(),
    );
  }

  Widget _buildPantIcon() {
    List<Product> pant = categoryProvider!.getPantList;
    List<CategoryIcon> pantIcon = categoryProvider!.getPantIcon;
    return Row(
      children: pantIcon.map(
        (e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ListProduct(name: 'Pants', snapShot: pant),
                ),
              );
            },
            child: _buildCategoryProduct(image: e.image, color: 0xff74acf7),
          );
        },
      ).toList(),
    );
  }

  Widget _buildTieIcon() {
    List<Product> tie = categoryProvider!.getTieList;
    List<CategoryIcon> tieIcon = categoryProvider!.getTieIcon;
    return Row(
      children: tieIcon.map(
        (e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListProduct(name: 'Tie', snapShot: tie),
                ),
              );
            },
            child: _buildCategoryProduct(image: e.image, color: 0xfffc6c8d),
          );
        },
      ).toList(),
    );
  }

  Widget _buildCategory() {
    return Column(
      children: [
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          child: Row(
            children: [
              _buildDressIcon(),
              _buildShirtIcon(),
              _buildShoeIcon(),
              _buildPantIcon(),
              _buildTieIcon(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeature() {
    List<Product> featureProduct;
    List<Product> homeFeatureProduct;

    homeFeatureProduct = productProvider!.getHomeFeatureList;
    featureProduct = productProvider!.getFeatureList;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Featured',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ListProduct(
                      name: 'Featured',
                      isCategory: false,
                      snapShot: featureProduct,
                    ),
                  ),
                );
              },
              child: const Text(
                'View more',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: homeFeatureProduct.map(
            (e) {
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                image: e.image,
                                price: e.price,
                                name: e.name,
                              ),
                            ),
                          );
                        },
                        child: SingleProduct(
                          image: e.image,
                          price: e.price,
                          name: e.name,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              image: e.image,
                              price: e.price,
                              name: e.name,
                            ),
                          ),
                        );
                      },
                      child: SingleProduct(
                        image: e.image,
                        price: e.price,
                        name: e.name,
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildNewAchives() {
    List<Product> newAchivesProduct = productProvider!.getNewAchivesList;
    return Column(
      children: [
        Container(
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Achives',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ListProduct(
                            name: 'New Achives',
                            isCategory: false,
                            snapShot: newAchivesProduct,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "View more",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: productProvider!.getHomeAchiveList.map((e) {
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        image: e.image,
                                        price: e.price,
                                        name: e.name,
                                      ),
                                    ),
                                  );
                                },
                                child: SingleProduct(
                                  image: e.image,
                                  price: e.price,
                                  name: e.name,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      image: e.image,
                                      price: e.price,
                                      name: e.name,
                                    ),
                                  ),
                                );
                              },
                              child: SingleProduct(
                                image: e.image,
                                price: e.price,
                                name: e.name,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    categoryProvider = Provider.of<CategoryProvider>(context);
    categoryProvider!.getShirtData();
    categoryProvider!.getDressData();
    categoryProvider!.getShoesData();
    categoryProvider!.getPantData();
    categoryProvider!.getTieData();
    categoryProvider!.getDressIconData();
    categoryProvider!.getShirtIconData();
    categoryProvider!.getShoesIconData();
    categoryProvider!.getPantIconData();
    categoryProvider!.getTieIconData();
    productProvider = Provider.of<ProductProvider>(context);
    productProvider!.getNewAchivesData();
    productProvider!.getFeatureData();
    productProvider!.getHomeFeatureData();
    productProvider!.getHomeAchiveData();
    productProvider!.getUserData();

    return Scaffold(
      key: _key,
      drawer: _buildMyDrawer(),
      appBar: AppBar(
        title: const Text(
          'HomePage',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            _key.currentState!.openDrawer();
          },
        ),
        actions: [
          NotificationButton(),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSlider(),
                    _buildCategory(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildFeature(),
                    _buildNewAchives(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
