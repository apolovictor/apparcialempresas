import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        double height = constraints.maxHeight;
        return Container(
          height: double.infinity,
          child: Column(
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Resumo do dia",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer ? 0 : 1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: height - 40,
                    child: categoriesScroller),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Container(
            width: 150,
            margin: const EdgeInsets.only(right: 20),
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.orange.shade400,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: const Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total\nVendas",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "R\$ 2.500,00",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 150,
            margin: EdgeInsets.only(right: 20),
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue.shade400,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: const Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Top\nProdutos",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Queijo Coalho - 45",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          "Heineken - 40",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          "Alcatra 37",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 150,
            margin: EdgeInsets.only(right: 20),
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent.shade400,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total por\nCategoria",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bebidas\nR\$ 1.750,00",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Espetos\nR\$ 750,00",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
