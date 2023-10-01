import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rotas/components/constantes.dart';

class OrderTrakingPage extends StatefulWidget {
  const OrderTrakingPage({super.key});

  @override
  State<OrderTrakingPage> createState() => _OrderTrakingPageState();
}

class _OrderTrakingPageState extends State<OrderTrakingPage> {
  static const LatLng sourceLocation = LatLng(13.277903, -8.808082);
  static const LatLng destination = LatLng(13.325472, -8.831973);

  List<LatLng> polyLineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googgle_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polyLineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  void initState() {
    getPolyPoints();
    super.initState();
  }

  final Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex =
      const CameraPosition(target: LatLng(13.277903, -8.808082), zoom: 13.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          polylines: {
            Polyline(
              polylineId: PolylineId(
                "route",
              ),
              points: polyLineCoordinates,
            )
          },
          markers: {
            Marker(
              markerId: MarkerId("souce"),
              position: sourceLocation,
            ),
            Marker(
              markerId: MarkerId("destination"),
              position: destination,
            ),
          },
        ),
      ),
    );
  }
}
