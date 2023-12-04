import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../orders/views/add_order.dart';
import '../../products/controller/product_list.notifier.dart';
import '../../products/controller/products_notifier.dart';
import '../../products/model/products_model.dart';
import '../../products/views/product_add.dart';
import '../../products/views/product_quick_edit.dart';
import '../controller/routes_controller.dart';
import 'app_drawer.dart';
import 'top_bar_item.dart';

/// A responsive scaffold for our application.
/// Displays the navigation drawer alongside the [Scaffold] if the screen/window size is large enough
class AppScaffold extends HookConsumerWidget {
  const AppScaffold(
      {required this.body,
      this.pageTitle,
      // this.orderReceived,
      // this.orderReceived,
      // this.orders,
      required Key? key})
      : super(key: key);

  final Widget body;

  final String? pageTitle;

  // final orderReceived;
  // final orders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final routeListNotifier = ref.watch(routeListProvider);
    final isProductOpened = ref.watch(isProductsOpenedProvider);
    final bool isActiveEdit = ref.watch(isActiveEditNotifier);
    List<Product>? products = ref.watch(productProvider).value;
    final double minHeight = height * 0.1;

    AsyncValue<List<Product>> filteredProducts =
        ref.watch(filteredProductsProvider(products ?? []));

    int selected = ref.watch(selectedProductNotifier);

    return Scaffold(
      drawer: displayMobileLayout
          ? const AppDrawer(
              // orders: orders,
              permanentlyDisplay: false,
            )
          : null,
      body: Container(
        height: height,
        width: width,
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 375),
              width: isProductOpened || isActiveEdit ? width * 0.7 : width,
              height: height * 0.1,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: routeListNotifier
                          .map(
                            (e) => TopBarItem(
                                route: e,
                                indexRoute: routeListNotifier.indexWhere(
                                    (element) => element.title == e.title),
                                icon: e.title == '/'
                                    ? const Icon(Icons.home, size: 40)
                                    : e.title == '/produtos'
                                        ? const Icon(Icons.restaurant_menu,
                                            size: 40)
                                        : const Icon(Icons.table_bar, size: 40),
                                products: products),
                          )
                          .toList(),
                    ),
                    //
                  ),
                ],
              ),
            ),

            /// Body
            Positioned(
              top: height * 0.1,
              child: Container(
                  height: height * 0.9,
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.03),
                    child: body,
                  )),
            ),

            /// Add Product Widget
            Positioned(
              right: 0,
              child: ProductAdd(
                width: width,
                height: height,
              ),
            ),

            /// Edit Product Widget
            Positioned(
              right: 0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return products != null
                      ? filteredProducts.when(
                          data: (List<Product> data) {
                            return
                                //  filter['category'].isNotEmpty
                                //     ?
                                selected < data.length
                                    ? ProducQuickEdit(
                                        key: key,
                                        height: height,
                                        width: width,
                                        constraints: constraints,
                                        products: data)
                                    : const SizedBox();
                          },
                          error: (err, stack) => Text('Error: $err'),
                          loading: () => CircularProgressIndicator(),
                        )
                      : const SizedBox();
                },
              ),
            ),

            ///Add Order Widget
            AddOrderWidget(
                minHeight: minHeight, minWidth: width, height: height)
          ],
        ),
      ),
    );
  }
}
