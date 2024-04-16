import 'package:flutter/material.dart';
import 'package:super_meals/data/dummy_data.dart';
import 'package:super_meals/screens/filter_screen.dart';
import 'package:super_meals/widgets/category_grid_item.dart';

import '../models/category.dart';
import '../models/meal.dart';
import 'meals_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final void Function(Meal meal) onToggleFavourite;
  final Map<Filter, bool> selectedFilters;

  const CategoriesScreen({
    super.key,
    required this.onToggleFavourite,
    required this.selectedFilters,
  });

  void _onSelectCategory(BuildContext context, Category category) {
    //filtering by category
    final filteredMeals = dummyMeals
        .where((meal) {
          bool filter = meal.categories.contains(category.id);
          if (filter) {
            selectedFilters.forEach((key, value) {
              if(selectedFilters[key]!) {
                switch(key) {
                  case Filter.glutenFree:
                    filter = meal.isGlutenFree == selectedFilters[Filter.glutenFree];
                    break;
                  case Filter.lactoseFree:
                    filter = meal.isLactoseFree == selectedFilters[Filter.lactoseFree];

                    break;
                  case Filter.vegan:
                    filter = meal.isVegan == selectedFilters[Filter.vegan];
                    break;
                  case Filter.vegetarian:
                    filter = meal.isVegetarian == selectedFilters[Filter.vegetarian];
                    break;
                }
              }
            });
          }
          return filter;

          return meal.categories.contains(category.id)
              && meal.isGlutenFree == selectedFilters[Filter.glutenFree]
              && meal.isLactoseFree == selectedFilters[Filter.lactoseFree]
              && meal.isVegan == selectedFilters[Filter.vegan]
              && meal.isVegetarian == selectedFilters[Filter.vegetarian];
        }) //true or false
        .toList();

    //Lifting the state up

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          onToggleFavourite: (meal) {
            onToggleFavourite(meal);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        //availableCategories.map((category) => CategoryGridItem(category: category)).toList()
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _onSelectCategory(context, category);
            },
          )
      ],
    );
  }
}
