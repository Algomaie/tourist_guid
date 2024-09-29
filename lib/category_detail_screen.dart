import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String category;
  final Position? currentPosition;

  CategoryDetailScreen({required this.category, this.currentPosition});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  List<Map<String, dynamic>> places = [];
  bool isLoading = true;
  final String apiKey = 'AIzaSyBP83emEDRVw2nVOUIIDkXpR2IouYz94-M';

  @override
  void initState() {
    super.initState();
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    if (widget.currentPosition == null) return;

    String type;
    switch (widget.category) {
      case 'Cafes':
        type = 'cafe';
        break;
      case 'Restaurants':
        type = 'restaurant';
        break;
      case 'Hotels':
        type = 'lodging';
        break;
      default:
        type = 'tourist_attraction';
        break;
    }

    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/nearbysearch/json',
      {
        'location':
            '${widget.currentPosition!.latitude},${widget.currentPosition!.longitude}',
        'radius': '5000',
        'type': type,
        'key': apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        places = (data['results'] as List).map((item) {
          return {
            'name': item['name'],
            'address': item['vicinity'] ?? 'No address',
            'rating': item['rating']?.toDouble() ?? 0.0,
            'photoReference': item['photos'] != null
                ? item['photos'][0]['photo_reference']
                : null,
          };
        }).toList();
        isLoading = false;
      });
    } else {
      print('Failed to fetch places');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details for ${widget.category}'),
        backgroundColor:
            Color.fromARGB(255, 20, 147, 238), //Color(0xFF14478E), // Dark blue
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : places.isEmpty
              ? Center(child: Text('No places found for ${widget.category}.'))
              : ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: places[index]['photoReference'] != null
                              ? Image.network(
                                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${places[index]['photoReference']}&key=$apiKey',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey,
                                  child: Icon(Icons.image, color: Colors.white),
                                ),
                        ),
                        title: Text(
                          places[index]['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 20, 147, 238),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address: ${places[index]['address']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            SizedBox(height: 5),
                            RatingBarIndicator(
                              rating: places[index]['rating'],
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                          ],
                        ),
                        onTap: () {
                          // Handle onTap event if needed
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
