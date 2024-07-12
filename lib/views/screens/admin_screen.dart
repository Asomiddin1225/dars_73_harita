import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminScreen extends StatefulWidget {
  final Set<Marker> restaurantMarkers;
  final Function addRestaurant;
  final Function editRestaurant;
  final Function deleteRestaurant;

  const AdminScreen({
    Key? key,
    required this.restaurantMarkers,
    required this.addRestaurant,
    required this.editRestaurant,
    required this.deleteRestaurant,
  }) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: ListView(
        children: widget.restaurantMarkers.map((marker) {
          return ListTile(
            title: Text(marker.infoWindow.title ?? 'Unknown'),
            subtitle: Text(marker.infoWindow.snippet ?? 'No details available'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Logic to edit the restaurant
                    _editRestaurantDialog(marker);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Logic to delete the restaurant
                    widget.deleteRestaurant(marker);
                    setState(() {});
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to add a new restaurant
          addRestaurantDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void addRestaurantDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String address = '';
        String phone = '';
        double rating = 0.0;

        return AlertDialog(
          title: Text('Add Restaurant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) => address = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Phone'),
                onChanged: (value) => phone = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                onChanged: (value) => rating = double.parse(value),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                widget.addRestaurant(name, address, phone, rating);
                setState(() {});
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editRestaurantDialog(Marker marker) {
    showDialog(
      context: context,
      builder: (context) {
        String name = marker.infoWindow.title ?? '';
        String address = marker.infoWindow.snippet ?? '';
        String phone = ''; // Assuming you store phone separately
        double rating = 0.0; // Assuming you store rating separately

        return AlertDialog(
          title: Text('Edit Restaurant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: TextEditingController(text: name),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Address'),
                controller: TextEditingController(text: address),
                onChanged: (value) => address = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Phone'),
                onChanged: (value) => phone = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                onChanged: (value) => rating = double.parse(value),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                widget.editRestaurant(marker, name, address, phone, rating);
                setState(() {});
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
