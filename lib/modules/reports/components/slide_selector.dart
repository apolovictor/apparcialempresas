/*
Copyright (c) 2022 Razeware LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
distribute, sublicense, create a derivative work, and/or sell copies of the
Software in any work that is designed, intended, or marketed for pedagogical or
instructional purposes related to programming, coding, application development,
or information technology.  Permission for such use, copying, modification,
merger, publication, distribution, sublicensing, creation of derivative works,
or sale is expressly withheld.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
import 'package:flutter/material.dart';

class SlideSelector extends StatefulWidget {
  List items;
  int defaultSelectedIndex;
  bool tappable;
  SlideSelector(
      {Key? key,
      required this.items,
      this.defaultSelectedIndex = 0,
      this.tappable = true})
      : super(key: key);
  @override
  _SlideSelectorState createState() => _SlideSelectorState();
}

class _SlideSelectorState extends State<SlideSelector> {
  int activeItemIndex = 0;

  @override
  void initState() {
    setState(() {
      activeItemIndex = widget.defaultSelectedIndex;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final buttonWidth = (constraints.maxWidth) / 3;
      return Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              top: 0,
              left: activeItemIndex * buttonWidth,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
              child: Container(
                width: buttonWidth,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0.0, 3.0),
                      color: Colors.black.withOpacity(0.12),
                    ),
                    BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(0.0, 3.0),
                      color: Colors.black.withOpacity(0.04),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value as SlideSelectorItem;
                return Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.tappable) {
                        item.onTap();
                        setState(() {
                          activeItemIndex = index;
                        });
                      }
                    },
                    child: Container(
                      height: 52,
                      // GestureDetector requires a color on the
                      // Container in order to recognize it
                      color: Colors.black.withOpacity(0.01),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          item.text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: index == activeItemIndex
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}

class SlideSelectorItem {
  String text;
  Function onTap;
  SlideSelectorItem({required this.text, required this.onTap});
}
