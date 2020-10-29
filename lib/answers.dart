final List<int> numList = [for (var i = 1; i <= 30; i += 1) i];

final List<String> smallAzList = [
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z"
];

final List<String> largeAzList = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
];

List<dynamic> getAnswer(String selectedMode) {
  if (selectedMode == '1-30') {
    return numList;
  } else if (selectedMode == 'a-z') {
    return smallAzList;
  } else {
    return largeAzList;
  }
}
