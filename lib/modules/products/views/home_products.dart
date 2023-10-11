import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
            top: 0,
            left: !displayMobileLayout ? 30 : 15,
            right: !displayMobileLayout ? 25 : 15,
            bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: !displayMobileLayout ? 4 : 2,
              child: SizedBox(
                width: double.infinity,
                child: Column(children: [
                  Row(children: [
                    Text(
                      ' CATEGORIAS ',
                      style: Theme.of(context).textTheme.titleMedium,
                      // TextStyle(
                      //   fontWeight:
                      //       FontWeight.w900, // fontFamily: "HelveticaNeueBold",
                      //   fontSize: 16,
                      // ),
                    ),
                  ]),
                  // Expanded(child: CategoryHorizontalList()),
                ]),
              ),
            ),
            SizedBox(
              height: !displayMobileLayout ? 10 : 10,
            ),
            SizedBox(
              height: !displayMobileLayout ? 0 : 10,
            ),
            Expanded(
              flex: !displayMobileLayout ? 12 : 4,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' PRODUTOS',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      // Expanded(
                      //   child: watch(tables.tableChangeNotifier).when(
                      //       loading: () => const Center(
                      //           child: CircularProgressIndicator()),
                      //       error: (err, stack) =>
                      //           Center(child: Text(err.toString())),
                      //       data: (tables) {
                      //         // return CardsTable(table: tables[0]);
                      //         return tables!.length > 0
                      //             ? GridView(
                      //                 gridDelegate:
                      //                     SliverGridDelegateWithMaxCrossAxisExtent(
                      //                   maxCrossAxisExtent: 225.0,
                      //                   crossAxisSpacing: 20.0,
                      //                   mainAxisSpacing: 20.0,
                      //                 ),
                      //                 children: <Widget>[
                      //                   for (var table in tables)
                      //                     CardsTable(table: table),
                      //                 ],
                      //               )
                      //             : Container();
                      //       }),
                      // ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
