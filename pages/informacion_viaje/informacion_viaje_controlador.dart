import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:radio_taxi_alfa_app/src/api/environment.dart';
import 'package:radio_taxi_alfa_app/src/models/historial_viaje.dart';
import 'package:radio_taxi_alfa_app/src/utils/colors.dart' as utils;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class InformacionViajeControlador {
  BuildContext context;
  Function refresh;

  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(17.5694024, -99.5181556), zoom: 14.0);

  HistorialViaje historialViaje;

  Set<Polyline> polylines = {};
  List<LatLng> points = new List();

  Map<MarkerId, Marker> marcadores = <MarkerId, Marker>{};

  BitmapDescriptor origenMarcador;
  BitmapDescriptor destinoMarcador;


  Future init(BuildContext context, Function refresh) async {
    print('Se Inicio Mapa Informacion Cliente Controlador');
    this.context = context;
    this.refresh = refresh;

    historialViaje = ModalRoute.of(context).settings.arguments;

    origenMarcador = await crearMarcadorImagen('assets/img/map_pin_blue.png');
    destinoMarcador = await crearMarcadorImagen('assets/img/map_pin_red.png');
    
    animarCamaraPosicion(historialViaje.origenLat, historialViaje.origenLng);
  }


  void onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    await setPolylines();
  }

  void Regresar() {
    Navigator.of(context).pop();
  }


  Future<void> setPolylines() async {
   PointLatLng pointOrigenLatLng = PointLatLng(historialViaje.origenLat, historialViaje.origenLng);
    PointLatLng pointDestinoLatLng = PointLatLng(historialViaje.destinoLat, historialViaje.destinoLng);

    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointOrigenLatLng,
        pointDestinoLatLng
    );

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: utils.Colors.temaColor,
        points: points,
        width: 6
    );

    polylines.add(polyline);

    agregarMarcador('origen', historialViaje.origenLat, historialViaje.origenLng, 'Origen', historialViaje.origen, origenMarcador);
    agregarMarcador('destino', historialViaje.destinoLat, historialViaje.destinoLng, 'Destino', historialViaje.destino, destinoMarcador);

    refresh();
  }

  Future animarCamaraPosicion(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0, target: LatLng(latitude, longitude), zoom: 15)));
    }
  }

  Future<BitmapDescriptor> crearMarcadorImagen(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
    await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void agregarMarcador(String marcadorId, double lat, double lng, String titulo, String content, BitmapDescriptor iconMarcador) {
    MarkerId id = MarkerId(marcadorId);
    Marker marcador = Marker(
        markerId: id,
        icon: iconMarcador,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: titulo, snippet: content),
        );

    marcadores[id] = marcador;
  }
}
