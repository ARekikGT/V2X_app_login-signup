import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  final uuid = const Uuid();
  final String _apiKey = 'AIzaSyC5LrwMbcAdSFTDi52UwulCdM0i4kyVaQs';

  LatLng? _start;
  LatLng? _end;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  String _distance = '';

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    await Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find a Route")),
      body: Column(
        children: [
          _buildTextField("Start Location", _startController, true),
          _buildTextField("Destination", _endController, false),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(36.8065, 10.1815),
                zoom: 12,
              ),
              onMapCreated: (controller) => _mapController.complete(controller),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
            ),
          ),
          if (_distance.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Distance: $_distance km',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _calculateRoute,
        child: const Icon(Icons.alt_route),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isStart,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _openSearchDialog(controller, isStart),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }

  Future<void> _openSearchDialog(
    TextEditingController controller,
    bool isStart,
  ) async {
    final sessionToken = uuid.v4();
    final input = controller.text;

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_apiKey&sessiontoken=$sessionToken';

    final response = await http.get(Uri.parse(url));
    final predictions = json.decode(response.body)['predictions'];

    final List<String> suggestions =
        predictions.map<String>((p) => p['description'] as String).toList();

    final result = await showSearch(
      context: context,
      delegate: _PlaceSearchDelegate(suggestions),
    );

    if (result != null) {
      controller.text = result;
      _getCoordinates(result, isStart);
    }
  }

  Future<void> _getCoordinates(String place, bool isStart) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$place&key=$_apiKey';
    final response = await http.get(Uri.parse(url));
    final location =
        json.decode(response.body)['results'][0]['geometry']['location'];

    final LatLng position = LatLng(location['lat'], location['lng']);

    setState(() {
      if (isStart) {
        _start = position;
      } else {
        _end = position;
      }
      _setMarkers();
    });

    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  void _setMarkers() {
    final markers = <Marker>{};
    if (_start != null) {
      markers.add(Marker(markerId: const MarkerId("start"), position: _start!));
    }
    if (_end != null) {
      markers.add(Marker(markerId: const MarkerId("end"), position: _end!));
    }
    setState(() {
      _markers = markers;
    });
  }

  Future<void> _calculateRoute() async {
    if (_start == null || _end == null) return;

    final url =
        'https://router.project-osrm.org/route/v1/driving/${_start!.longitude},${_start!.latitude};${_end!.longitude},${_end!.latitude}?overview=full&geometries=geojson';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    final coordinates = data['routes'][0]['geometry']['coordinates'] as List;
    final distanceMeters = data['routes'][0]['distance'];
    final distanceKm = (distanceMeters / 1000).toStringAsFixed(2);

    final polyPoints =
        coordinates.map<LatLng>((e) => LatLng(e[1], e[0])).toList();

    setState(() {
      _distance = distanceKm;
      _polylines = {
        Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.blue,
          width: 4,
          points: polyPoints,
        ),
      };
    });

    final controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(_getBounds(polyPoints), 60),
    );
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    final southwest = LatLng(
      points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
      points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
    );
    final northeast = LatLng(
      points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
      points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
    );
    return LatLngBounds(southwest: southwest, northeast: northeast);
  }
}

class _PlaceSearchDelegate extends SearchDelegate<String> {
  final List<String> suggestions;

  _PlaceSearchDelegate(this.suggestions);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSuggestionList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSuggestionList();

  Widget _buildSuggestionList() {
    final filtered =
        suggestions
            .where((s) => s.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder:
          (context, index) => ListTile(
            title: Text(filtered[index]),
            onTap: () => close(context, filtered[index]),
          ),
    );
  }
}
