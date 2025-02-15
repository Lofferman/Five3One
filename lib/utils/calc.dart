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
}

class WeightPlateUtil {
  // List of available plates in pounds
  static const List<num> plateWeights = [
    45,
    25,
    10,
    5,
    2
  ]; // 45lbs, 25lbs, 10lbs, 5lbs, 2.5lbs

  // Function to calculate the plates required for a given weight on one side of the bar
  static Map<num, num> calculatePlates(num targetWeight) {
    // Subtract the weight of the bar (45 lbs)
    targetWeight -= 45;

    // Initialize a map to hold the number of plates required for each plate size
    Map<num, num> platesRequired = {45: 0, 25: 0, 10: 0, 5: 0, 2: 0};

    // Loop through the available plates and calculate how many we need
    for (num plate in plateWeights) {
      if (targetWeight <= 0) break;
      num count = (targetWeight ~/ plate).toInt(); // Number of plates that fit
      platesRequired[plate] = count;
      targetWeight -= plate * count; // Deduct the weight accounted for
    }

    // Return the number of plates for each size (only for plates that are used)
    platesRequired.removeWhere((key, value) => value == 0);
    return platesRequired;
  }
}
