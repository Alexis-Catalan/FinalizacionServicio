import 'package:flutter/material.dart';
import 'package:radio_taxi_alfa_app/src/models/historial_viaje.dart';
import 'package:radio_taxi_alfa_app/src/providers/auth_provider.dart';
import 'package:radio_taxi_alfa_app/src/providers/historial_viaje_provider.dart';

class ClienteHistorialControlador {

  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  AuthProvider _authProvider;
  HistorialViajeProvider _historialViajeProvider;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _authProvider = new AuthProvider();
    _historialViajeProvider = new HistorialViajeProvider();

    refresh();
  }

  Future<List<HistorialViaje>> obtenerHistorial() async {
    return await _historialViajeProvider.obtenerIdCliente(_authProvider.obtenerUsuario().uid);
  }

  void abrirHistorialDetalle(String id) {
    Navigator.pushNamed(context, 'cliente/historial/detalle', arguments: id);
  }

}