import 'package:flutter/material.dart';
import 'package:yamly/services/api_service.dart';
import 'package:yamly/values/colors.dart';
import 'package:yamly/products.dart';
import 'package:yamly/profile.dart';
import 'package:yamly/recipe.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _pageController = PageController(initialPage: 1);
  List<NavTab> tabList;
  var currentPage = 0;
  var canChangePage = true;

  @override
  initState() {
    super.initState();

    initTabData();

    _tabController =
        TabController(length: tabList.length, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        onPageChange(_tabController.index, p: _pageController);
      }
    });

    //APIService().addProduct();
  }

  initTabData() {
    tabList = [
      NavTab(1, Icon(Icons.person), ProfilePage()),
      NavTab(2, Icon(Icons.view_carousel), ProductsPage()),
      NavTab(3, Icon(Icons.fastfood), RecipeScreen())
    ];
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      canChangePage = false;
      await _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
      canChangePage = true;
    } else {
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: PageView.builder(
                itemCount: tabList.length,
                onPageChanged: (index) {
                  if (canChangePage) {
                    onPageChange(index);
                  }
                },
                controller: _pageController,
                itemBuilder: (BuildContext context, int index) {
                  return tabList[index].widget;
                })),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: new Border(
                  top: BorderSide(
                      color: Theme.of(context).unselectedWidgetColor,
                      width: 0.5))),
          child: SafeArea(
              child: Container(
                  height: 60,
                  child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.black,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorWeight: 1,
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 0),
                          insets: EdgeInsets.all(0)),
                      tabs: tabList.map((item) {
                        return Tab(icon: item.icon);
                      }).toList()))),
        ));
  }
}

class NavTab {
  int id;
  Icon icon;
  Widget widget;

  NavTab(this.id, this.icon, this.widget);
}
