import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Category {
  final String category;

  Category({@required this.category});
}

class Section {
  final String section;
  final String imgUrl;
  final List<Category> categories;

  Section({
    @required this.section,
    @required this.categories,
    @required this.imgUrl,
  });
}

final List<Section> sectionList = [
  Section(
    section: "Grocery",
    imgUrl:
        "https://cdn.grofers.com/app/images/category/cms_images/icon/icon_cat_16_v_3_500_1580063793.jpg",
    categories: [
      Category(category: "Choose a Category"),
      Category(category: "Pulses"),
      Category(category: "Atta And Other Flours"),
      Category(category: "Rice And Other Grains"),
      Category(category: "Dry Fruits And Nuts"),
      Category(category: "Edible Oils"),
      Category(category: "Ghee And Vanaspati"),
      Category(category: "Spices"),
      Category(category: "Salt And Sugar"),
      Category(category: "Organic Staples"),
    ],
  ),
  Section(
    imgUrl:
        "https://cdn.grofers.com/app/images/category/cms_images/icon/icon_cat_1487_v_3_500_1580063978.jpg",
    section: "Fruits And Vegetables",
    categories: [
      Category(category: "Vegetables"),
      Category(category: "Fruits"),
      Category(category: "Mangoes"),
      Category(category: "Vegetables And Fruits Cleaners"),
    ],
  ),
  Section(
    imgUrl:
        "https://cdn.grofers.com/app/images/category/cms_images/icon/icon_cat_163_v_3_500_1584073368.jpg",
    section: "Personal Care",
    categories: [
      Category(category: "Personal Care Best offers"),
      Category(category: "Safety Must Haves"),
      Category(category: "Bath And Body"),
      Category(category: "Hair Care"),
      Category(category: "Skin Care"),
      Category(category: "Oral Care"),
      Category(category: "Fragrances"),
      Category(category: "Face Care"),
      Category(category: "Feminine Hygiene"),
      Category(category: "Men's Grooming"),
      Category(category: "Health And Wellness"),
      Category(category: "Cosmetics"),
      Category(category: "Disinfectants"),
      Category(category: "Buy 1 Get 1 Free"),
    ],
  ),
  Section(
    imgUrl:
        "https://cdn.grofers.com/app/images/category/cms_images/icon/icon_cat_18_v_3_500_1584355882.jpg",
    section: "Households",
    categories: [
      Category(category: "Household Best Offers"),
      Category(category: "Laundry Detergents"),
      Category(category: "Cleaners"),
      Category(category: "Dishwashers"),
      Category(category: "Liquid Detergents"),
      Category(category: "Repellents"),
      Category(category: "Tissues And Disposables"),
      Category(category: "Pooja Needs"),
      Category(category: "Home And Car Fresheners"),
      Category(category: "Shoe Care"),
    ],
  ),
  Section(
    imgUrl:
        "https://cdn.grofers.com/app/images/category/cms_images/icon/icon_cat_13_v_3_500_1580068677.jpg",
    section: "Biscuits, Chocolates And Snacks",
    categories: [
      Category(category: "Chocolates And Candies"),
      Category(category: "Biscuits And Cookies"),
      Category(category: "Namkeen And Snacks"),
      Category(category: "Chips And Crisps"),
      Category(category: "Sweets"),
      Category(category: "Biscuits And Chocolates Offers"),
      Category(category: "Best Offers"),
    ],
  ),
  Section(
    imgUrl:
        "https://cdn.grofers.com/app/images/category/cms_images/icon/icon_cat_14_v_3_500_1580063018.jpg",
    section: "Diary And Breakfast",
    categories: [
      Category(category: "Breakfast And Dairy Best Offers"),
      Category(category: "Milk And Milk Products"),
      Category(category: "Bread And Eggs"),
      Category(category: "Paneer And Curd"),
      Category(category: "Butter And Cheese"),
      Category(category: "Breakfast Cereal And Mixes"),
      Category(category: "Jams"),
      Category(category: "Honey And Spreads"),
      Category(category: "Fresh Sweets"),
      Category(category: "Batter"),
    ],
  ),
  Section(
    imgUrl:
        "https://cdn.grofers.com/app/images/category/cms_images/icon/icon_cat_12_v_3_500_1580062743.jpg",
    section: "Beverages",
    categories: [
      Category(category: "Cold Drinks"),
      Category(category: "Juices And Drinks"),
      Category(category: "Tea And Coffee"),
      Category(category: "Health And Energy Drinks"),
      Category(category: "Water And Soda"),
      Category(category: "Milk Drinks"),
    ],
  ),
  Section(
    imgUrl:
        "https://cdn.grofers.com/app/images/category/cms_images/icon/icon_cat_15_v_3_500_1580064306.jpg",
    section: "Noodles, Sauces & Instant Food",
    categories: [
      Category(category: "Noodles And Sauces Best Offers"),
      Category(category: "Noodles And Vermicelli"),
      Category(category: "Sauces And Ketchups"),
      Category(category: "Jams"),
      Category(category: "Honey And Spreads"),
      Category(category: "Pasta And Soups"),
      Category(category: "Ready Made Meals And Mixes"),
      Category(category: "Pickles And Chutneys"),
      Category(category: "Baking And Dessert Items"),
      Category(category: "Chyawanprash And Health Foods"),
    ],
  ),
  Section(
    imgUrl:
        "https://cdn.grofers.com/app/images/category/cms_images/icon/icon_cat_7_v_3_500_1580062720.jpg",
    section: "Baby Care",
    categories: [
      Category(category: "Baby Food"),
      Category(category: "Diapers And Wipes"),
      Category(category: "Baby Skin And Hair Care"),
      Category(category: "Baby Accessories And More"),
      Category(category: "Buy 1 Get 1 And More"),
    ],
  )
];
