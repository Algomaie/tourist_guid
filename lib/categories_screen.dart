import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'category_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 0;
  Position? _currentPosition;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 5, 40, 64),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topRight: Radius.circular(30))),
      //padding: EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  height: 200,
                  width: double.infinity,
                  child: Image.asset(
                    'images/back.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 200,
                  color: Colors.black.withOpacity(0.3),
                  alignment: Alignment.center,
                  child: const Text(
                    'Categories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 130,
                  child: Opacity(
                    opacity: 0.7,
                    child: ElevatedButton.icon(
                      label: const Text("your Location",
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 40, 64),
                          )),
                      icon: const Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 5, 40, 64),
                      ),
                      onPressed: _getCurrentLocation,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(40),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: <Widget>[
                  CategoryCard(
                    iconData: Icons.local_cafe,
                    label: 'Cafes',
                    context: context,
                    position: _currentPosition,
                  ),
                  CategoryCard(
                    iconData: Icons.restaurant,
                    label: 'Restaurants',
                    context: context,
                    position: _currentPosition,
                  ),
                  CategoryCard(
                    iconData: Icons.landscape,
                    label: 'Tourist Places',
                    context: context,
                    position: _currentPosition,
                  ),
                  CategoryCard(
                    iconData: Icons.hotel,
                    label: 'Hotels',
                    context: context,
                    position: _currentPosition,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(2),
          height: 80,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 136, 186, 219),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30))),
          child: BottomNavigationBar(
            iconSize: 30,
            elevation: 20,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color: _selectedIndex == 0
                        ? const Color.fromARGB(255, 70, 85, 97)
                        : Colors.grey),
                label: 'Home',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.tour,
                    color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
                label: 'Tour guide',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone,
                    color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
                label: 'Emergency contact',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule,
                    color: _selectedIndex == 3 ? Colors.blue : Colors.grey),
                label: 'Suggest schedule',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color: _selectedIndex == 4 ? Colors.blue : Colors.grey),
                label: 'Profile',
                backgroundColor: Colors.white,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: const Color.fromARGB(255, 5, 40, 64),
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
          ),
        ),
      ),
    ));
  }
}

class CategoryCard extends StatelessWidget {
  final IconData iconData;
  final String label;
  final BuildContext context;
  final Position? position;
  const CategoryCard({
    Key? key,
    required this.iconData,
    required this.label,
    required this.context,
    this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryDetailScreen(
            category: label,
            currentPosition: position,
          ),
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Opacity(
              opacity: 1,
              child: ElevatedButton.icon(
                label: const Text(""),
                icon: Icon(
                  iconData,
                  color: const Color.fromARGB(255, 5, 40, 64),
                ),
                onPressed: null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 40, 64),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
