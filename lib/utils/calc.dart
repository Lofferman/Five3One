class calcUtil {
  static List<Map<String, dynamic>> calcWeights(String metric, num maxWeight) {
    num trainingMax = maxWeight * 0.9;
    Map<String, List<num>> percentages = {
      '5/5/5': [0.65, 0.75, 0.85],
      '3/3/3': [0.70, 0.80, 0.90],
      '5/3/1': [0.75, 0.85, 0.95],
      'Deload': [0.40, 0.50, 0.60]
    };
    Map<String, List<int>> reps = {
      '5/5/5': [5, 5, 5],
      '3/3/3': [3, 3, 3],
      '5/3/1': [5, 3, 1],
      'Deload': [5, 5, 5]
    };

    return List.generate(3, (index) {
      num weight = (trainingMax * percentages[metric]![index]).roundToDouble();
      weight = (weight / 5).round() * 5;
      //round to the nearest 5lbs
      return {'reps': reps[metric]![index], 'weight': weight};
    });
  }

  static Map<String, num> calculatePlates(num targetWeight) {
    double barWeight = 45.0; // Weight of the barbell in pounds
    double totalWeight =
        targetWeight - barWeight; // The weight to be added with plates

    if (totalWeight < 0) {
      throw Exception(
          "Target weight cannot be less than the weight of the barbell.");
    }

    // Divide by 2 to get the weight for one side of the barbell
    totalWeight /= 2;

    // Define the plate sizes
    List<double> plateSizes = [45.0, 25.0, 10.0, 5.0, 2.5];
    Map<String, double> platesNeeded = {
      '45': 0,
      '25': 0,
      '10': 0,
      '5': 0,
      '2.5': 0
    };

    // Loop through the plate sizes and calculate how many plates we need for one side
    for (var plate in plateSizes) {
      double plateCount = (totalWeight / plate).floorToDouble();
      platesNeeded[plate.toString()] = plateCount;
      totalWeight -= plateCount * plate;

      // Round to the nearest .5 if remaining weight is less than 0.5
      totalWeight = (totalWeight * 2).roundToDouble() / 2;
    }

    // Ensure the sum matches the total weight to avoid rounding issues
    if (totalWeight > 0) {
      double remainingWeight = (totalWeight * 2).roundToDouble() / 2;
      if (remainingWeight > 0) {
        platesNeeded['2.5'] = platesNeeded['2.5']! + remainingWeight / 2.5;
      }
    }

    //Remove if the the plate count is 0
    platesNeeded.removeWhere((k, v) => v == 0);

    return platesNeeded;
  }
}
