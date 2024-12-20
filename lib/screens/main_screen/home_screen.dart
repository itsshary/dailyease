import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy data for categories
  final List<Map<String, String>> categories = [
    {
      'name': 'Meat',
      'image': 'images/meat.png',
    },
    {
      'name': 'Grocery',
      'image': 'images/gro.png',
    },
    {
      'name': 'Vegetables',
      'image': 'images/veg.png',
    },
  ];

  // Dummy data for products
  final List<Map<String, String>> allProducts = [
    {
      'name': 'Chicken',
      'image':
          'https://binksberryhollow.com/wp-content/uploads/2021/01/Whole-Chicken-1030x1030.png',
      'category': 'Meat',
    },
    {
      'name': 'Beef',
      'image':
          'https://storage.googleapis.com/duckr-b8e76.appspot.com/resized/i_j_d6hoo-05cd8a2fd535d119d6ff43bffe6f37ca7fcf65a252326439b2165e755fc47e30_896x504.png',
      'category': 'Meat',
    },
    {
      'name': 'Rice',
      'image':
          'https://foodsbymughal.com/wp-content/uploads/2023/03/Royal-Classic.png',
      'category': 'Grocery',
    },
    {
      'name': 'Milk',
      'image':
          'https://sapinsdairy.com/wp-content/uploads/2021/12/milk-bottle.png',
      'category': 'Grocery',
    },
    {
      'name': 'Carrot',
      'image':
          'https://wallpapers.com/images/featured/carrot-png-7crm54jnhoaaa46f.jpg',
      'category': 'Vegetables',
    },
    {
      'name': 'Potato',
      'image':
          'https://cheeseclub.hk/wp-content/uploads/2024/02/Agria_Potatoes_FPOTA35.png',
      'category': 'Vegetables',
    },
  ];

  // Selected category
  String selectedCategory = 'Meat';

  @override
  Widget build(BuildContext context) {
    // Filter products based on selected category
    List<Map<String, String>> filteredProducts = allProducts
        .where((product) => product['category'] == selectedCategory)
        .toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: const [
            CircleAvatar(),
            SizedBox(width: 10.0),
          ],
          title: const Text(
            "DailyEase",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue.shade100,
          centerTitle: true,
        ),
        drawer: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search Item',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Categories section
              const Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index]['name']!;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor:
                                  selectedCategory == categories[index]['name']
                                      ? Colors.blue.shade100
                                      : Colors.grey.shade300,
                              backgroundImage:
                                  AssetImage(categories[index]['image']!),
                            ),
                            const SizedBox(height: 5.0),
                            Text(categories[index]['name']!),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),

              // Products section
              const Text(
                "Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 3.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10.0),
                              ),
                              child: Image.network(
                                filteredProducts[index]['image']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              filteredProducts[index]['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
