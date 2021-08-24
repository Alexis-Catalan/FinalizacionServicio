import 'package:flutter/material.dart';
import 'package:radio_taxi_alfa_app/src/models/historial_viaje.dart';
import 'package:radio_taxi_alfa_app/src/providers/historial_viaje_provider.dart';
import 'package:radio_taxi_alfa_app/src/utils/snackbar.dart' as utils;

class ClienteCalificacionViajeControlador {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey();

  String idHistorialViaje;

  HistorialViajeProvider _historialViajeProvider;
  HistorialViaje historialViaje;

  double calificacion;

  Future init (BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;

    idHistorialViaje = ModalRoute.of(context).settings.arguments as String;

    _historialViajeProvider = new HistorialViajeProvider();

    print('ID DEL TRAVBEL HISTORY: $idHistorialViaje');

    obtenerHistorialViaje();
  }

  void obtenerHistorialViaje() async {
    historialViaje = await _historialViajeProvider.obtenerId(idHistorialViaje);
    refresh();
  }

  void Calificacion() async {
    if (calificacion == null) {
      utils.Snackbar.showSnackbar(context, key, Colors.red, 'Por favor califica a tu taxista');
      return;
    }
    if (calificacion == 0) {
      utils.Snackbar.showSnackbar(context, key, Colors.red, 'La calificacion minima es 1');
      return;
    }
    Map<String, dynamic> data = {
      'calificacionTaxista': calificacion
    };

    await _historialViajeProvider.actualizar(data, idHistorialViaje);
    Navigator.pushNamedAndRemoveUntil(context, 'cliente/mapa', (route) => false);
  }

}