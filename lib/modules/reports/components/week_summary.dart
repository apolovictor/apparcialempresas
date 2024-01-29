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

import '../models/laughing_data.dart';

class WeekSummary extends StatelessWidget {
  const WeekSummary({Key? key, required this.week}) : super(key: key);
  final int week;

  String calculateLaughs([String filter = '']) {
    final total = weeksData[week - 1].days.fold(0, (int acc, DayData cur) {
      if ((filter == 'weekday' && (cur.day == 0 || cur.day == 6)) ||
          (filter == 'weekend' && (cur.day > 0 && cur.day < 6))) {
        return acc;
      }
      return acc + cur.laughs;
    });
    return total.toString();
  }

  String calculateMinMax([String filter = '']) {
    final dayMax = weeksData[week - 1].days.reduce((DayData a, DayData b) {
      if (a.laughs > b.laughs) {
        return filter == 'worst' ? b : a;
      } else
        return filter == 'worst' ? a : b;
    });
    return [
      'Domingo',
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado'
    ][dayMax.day];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Semana $week',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListItem(label: 'Total vendas', value: calculateLaughs()),
          ListItem(
              label: 'Vendas na semana', value: calculateLaughs('weekday')),
          ListItem(
              label: 'Vendas final de semana',
              value: calculateLaughs('weekend')),
          ListItem(label: 'Top dia', value: calculateMinMax('funniest')),
          ListItem(
            label: 'Pior dia',
            value: calculateMinMax('worst'),
            hideDivider: true,
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem(
      {Key? key,
      required this.label,
      required this.value,
      this.hideDivider = false})
      : super(key: key);
  final String label;
  final String value;
  final bool hideDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFD4D4D4).withOpacity(hideDivider ? 0 : 1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF565656),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF565656),
            ),
          )
        ],
      ),
    );
  }
}
