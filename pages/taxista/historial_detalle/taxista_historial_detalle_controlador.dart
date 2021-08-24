import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:radio_taxi_alfa_app/src/models/cliente.dart';
import 'package:radio_taxi_alfa_app/src/models/historial_viaje.dart';
import 'package:radio_taxi_alfa_app/src/providers/cliente_provider.dart';
import 'package:radio_taxi_alfa_app/src/providers/historial_viaje_provider.dart';
import 'package:radio_taxi_alfa_app/src/utils/my_progress_dialog.dart';


class TaxistaHistorialDetalleControlador {
  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  ClienteProvider _clienteProvider;
  HistorialViajeProvider _historialViajeProvider;
  ProgressDialog _progressDialog;

  HistorialViaje historialViaje;
  Cliente cliente;

  String idHistorialViaje;
  String fecha;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _clienteProvider = new ClienteProvider();
    _historialViajeProvider = new HistorialViajeProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Cargando datos...');

    idHistorialViaje = ModalRoute.of(context).settings.arguments as String;

    getHistorialViajeInfo();
  }

  void getHistorialViajeInfo() async {
    _progressDialog.show();
    historialViaje = await  _historialViajeProvider.obtenerId(idHistorialViaje);
    getClienteInfo(historialViaje.idCliente);
    fecha = getFecha(historialViaje.timestamp);
  }

  void getClienteInfo(String idCliente) async {
    cliente = await _clienteProvider.obtenerId(idCliente);
    _progressDialog.hide();
    refresh();
  }

  String getFecha(int timestamp) {
    var time = '';
    var format = new DateFormat('dd/MM/yyyy, hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    time = format.format(date);
    return time ?? '';
  }

  void Informacion() {
    Navigator.pushNamed(context, 'informacion/viaje', arguments: historialViaje);
  }

}

