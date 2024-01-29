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

List<WeekData> weeksData = [
  WeekData(
    days: [
      DayData(
        day: 0,
        laughs: 2,
      ),
      DayData(
        day: 1,
        laughs: 8,
      ),
      DayData(
        day: 2,
        laughs: 3,
      ),
      DayData(
        day: 3,
        laughs: 1,
      ),
      DayData(
        day: 4,
        laughs: 7,
      ),
      DayData(
        day: 5,
        laughs: 9,
      ),
      DayData(
        day: 6,
        laughs: 5,
      ),
    ],
  ),
  WeekData(
    days: [
      DayData(
        day: 0,
        laughs: 9,
      ),
      DayData(
        day: 1,
        laughs: 6,
      ),
      DayData(
        day: 2,
        laughs: 11,
      ),
      DayData(
        day: 3,
        laughs: 8,
      ),
      DayData(
        day: 4,
        laughs: 14,
      ),
      DayData(
        day: 5,
        laughs: 10,
      ),
      DayData(
        day: 6,
        laughs: 4,
      ),
    ],
  ),
  WeekData(
    days: [
      DayData(
        day: 0,
        laughs: 0,
      ),
      DayData(
        day: 1,
        laughs: 2,
      ),
      DayData(
        day: 2,
        laughs: 3,
      ),
      DayData(
        day: 3,
        laughs: 0,
      ),
      DayData(
        day: 4,
        laughs: 4,
      ),
      DayData(
        day: 5,
        laughs: 3,
      ),
      DayData(
        day: 6,
        laughs: 3,
      ),
    ],
  ),
];

WeekData zeroStateData = WeekData(
  days: [
    DayData(
      day: 0,
      laughs: 0,
    ),
    DayData(
      day: 1,
      laughs: 0,
    ),
    DayData(
      day: 2,
      laughs: 0,
    ),
    DayData(
      day: 3,
      laughs: 0,
    ),
    DayData(
      day: 4,
      laughs: 0,
    ),
    DayData(
      day: 5,
      laughs: 0,
    ),
    DayData(
      day: 6,
      laughs: 0,
    ),
  ],
);

class WeekData {
  WeekData({required this.days});
  List<DayData> days;
}

class DayData {
  DayData({required this.day, required this.laughs});
  int day;
  int laughs;
}
