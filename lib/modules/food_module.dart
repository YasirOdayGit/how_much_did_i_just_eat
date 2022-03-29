class FoodModule {
  double? sugar;
  double? fiber;
  double? servingSize;
  double? sodium; // yumyum
  String? nameOfFood;
  double? potassium;
  double? fatS;
  double? fatT;
  double? calories;
  double? cholestrol;
  double? protein; // muscles
  double? carbs;

  FoodModule({
    this.sugar,
    this.fiber,
    this.servingSize,
    this.sodium,
    this.nameOfFood,
    this.potassium,
    this.fatS,
    this.fatT,
    this.calories,
    this.cholestrol,
    this.protein,
    this.carbs,
  });

  factory FoodModule.fromJSON(map) {
    return FoodModule(
      sugar: map['sugar_g']?.toDouble() ?? 0,
      fiber: map['fiber_g']?.toDouble() ?? 0,
      servingSize: map['serving_size_g']?.toDouble() ?? 0,
      sodium: map['sodium_mg']?.toDouble() ?? 0,
      nameOfFood: map['name'] ?? "NaN",
      potassium: map['potassium_mg']?.toDouble() ?? 0,
      fatS: map['fat_saturated_g']?.toDouble() ?? 0,
      fatT: map['fat_total_g']?.toDouble() ?? 0,
      calories: map['calories']?.toDouble() ?? 0,
      cholestrol: map['cholesterol_mg']?.toDouble() ?? 0,
      protein: map['protein_g']?.toDouble() ?? 0,
      carbs: map['carbohydrates_total_g']?.toDouble() ?? 0,
    );
  }
}
