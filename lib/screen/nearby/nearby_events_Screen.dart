import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../network/places_service.dart';

class NearbyEventsScreen extends StatefulWidget {
  @override
  _NearbyEventsScreenState createState() => _NearbyEventsScreenState();
}

class _NearbyEventsScreenState extends State<NearbyEventsScreen> {
  late Future<List<dynamic>> _nearbyPlaces;
  String _query = 'nearby gyms';
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  void _fetchPlaces() {
    setState(() {
      _nearbyPlaces = PlacesService.fetchNearbyGyms(_query, _currentPage);
    });
  }

  void _updateQuery(String query) {
    setState(() {
      _query = query;
      _currentPage = 1;
      _fetchPlaces();
    });
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
      _fetchPlaces();
    });
  }

  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _fetchPlaces();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Nearby Events'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  _buildChip('Gyms', 'nearby gyms'),
                  _buildChip('Parks', 'nearby parks'),
                  _buildChip('Fitness Classes', 'fitness classes near me'),
                  _buildChip('Marathons', 'marathons near me'),
                  _buildChip('Yoga Sessions', 'yoga sessions near me'),
                  _buildChip('Boot Camps', 'boot camps near me'),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _nearbyPlaces,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var place = snapshot.data![index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(place['address']),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 5),
                                  Text('${place['rating']} (${place['ratingCount']} reviews)'),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (place['phoneNumber'] != null) ...[
                                Text('Phone: ${place['phoneNumber']}'),
                                const SizedBox(height: 5),
                              ],
                              if (place['website'] != null) ...[
                                GestureDetector(
                                  onTap: () async {
                                    var url = place['website'];
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.language, color: Colors.blue),
                                      SizedBox(width: 5),
                                      Text(
                                        'Website',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _prevPage,
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String query) {
    return GestureDetector(
      onTap: () => _updateQuery(query),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.blue.shade100,
      ),
    );
  }
}