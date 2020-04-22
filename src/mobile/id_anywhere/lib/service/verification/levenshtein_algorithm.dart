import 'dart:math';

class LevenshteinAlgorithm {
  static Future<bool> run(String a, String b, int threshold) async{
    a = a.toLowerCase();
    b = b.toLowerCase();

    if(b.length < (a.length / 2)){
      return false;
    }

    if (a?.isEmpty ?? true) {
      if (b?.isNotEmpty ?? true) {
        return b.length < threshold;
      }
      return 0 < threshold;
    }

    if (b?.isEmpty ?? true) {
      return threshold < a.length;
    }

    // If our source is greater than the
    if (a.length > b.length) {
      String temp = b;
      b = a;
      a = temp;
    }

    int m = b.length;
    int n = a.length;
    // create and initialise the distance matrix
    var distance = new List.generate(2, (_) => new List<int>.filled(m + 1, 0));

    for (int j = 1; j <= m; j++) {
      distance[0][j] = j;
    }

    int currentRow = 0;
    try {
      for (int i = 1; i <= n; ++i) {
        currentRow = i & 1;
        distance[currentRow][0] = i;
        int previousRow = currentRow ^ 1;
        for (int j = 1; j <= m; j++) {
          int cost = (b[j - 1] == a[i - 1] ? 0 : 1);
          distance[currentRow][j] = (min(
              min((distance[previousRow][j] + 1),
                  (distance[currentRow][j - 1])),
              (distance[previousRow][j - 1] + cost)));
        }
      }
    } on Exception catch (e) {
      print(e);
      return false;
    }

    return distance[currentRow][m] < threshold;
  }
}
