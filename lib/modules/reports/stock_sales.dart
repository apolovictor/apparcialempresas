import 'package:flutter/material.dart';

class StockSales extends StatelessWidget {
  const StockSales({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constranints) {
      double width = constranints.maxWidth;
      double height = constranints.maxHeight;

      return Container(
        height: constranints.maxHeight,
        width: constranints.maxWidth,
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -1),
              child: Container(
                width: width * 0.85,
                height: height * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.6),
              child: Material(
                  color: Colors.transparent,
                  child: Text('R\$ 45.000,00',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600))),
            ),
            Align(
              alignment: Alignment(0, -0.5),
              child: Material(
                  color: Colors.transparent,
                  child: Text('Receita Bruta',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600))),
            ),
            Align(
              alignment: Alignment(-1, 0.3),
              child: Container(
                width: width * 0.57,
                height: height * 0.57,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100],
                    border: Border.all(width: 2, color: Colors.white)),
              ),
            ),
            Align(
              alignment: Alignment(-0.5, 0),
              child: Material(
                  color: Colors.transparent,
                  child: Text('R\$ 35.000,00',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600))),
            ),
            Align(
              alignment: Alignment(-0.5, 0.1),
              child: Material(
                  color: Colors.transparent,
                  child: Text('Estoque atual',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600))),
            ),
            Align(
              alignment: Alignment(0, 1),
              child: Container(
                width: width * 0.45,
                height: height * 0.45,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(width: 2, color: Colors.white)),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.5),
              child: Material(
                  color: Colors.transparent,
                  child: Text('R\$ 25.000,00',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600))),
            ),
            Align(
              alignment: Alignment(0, 0.6),
              child: Material(
                  color: Colors.transparent,
                  child: Text('CMV',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600))),
            ),
          ],
        ),
      );
    });
  }
}
