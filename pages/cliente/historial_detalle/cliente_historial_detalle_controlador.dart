import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:radio_taxi_alfa_app/src/models/historial_viaje.dart';
import 'package:radio_taxi_alfa_app/src/models/taxista.dart';
import 'package:radio_taxi_alfa_app/src/providers/historial_viaje_provider.dart';
import 'package:radio_taxi_alfa_app/src/providers/taxista_provider.dart';
import 'package:radio_taxi_alfa_app/src/utils/my_progress_dialog.dart';


class ClienteHistorialDetalleControlador {
  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TaxistaProvider _taxistaProvider;
  HistorialViajeProvider _historialViajeProvider;
  ProgressDialog _progressDialog;

  HistorialViaje historialViaje;
  Taxista taxista;

  String idHistorialViaje;
  String fecha;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _taxistaProvider = new TaxistaProvider();
    _historialViajeProvider = new HistorialViajeProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Cargando datos...');

    idHistorialViaje = ModalRoute.of(context).settings.arguments as String;

    getHistorialViajeInfo();
  }

  void getHistorialViajeInfo() async {
    _progressDialog.show();
    historialViaje = await  _historialViajeProvider.obtenerId(idHistorialViaje);
    getTaxistaInfo(historialViaje.idTaxista);
    fecha = getFecha(historialViaje.timestamp);
  }

  void getTaxistaInfo(String idTaxista) async {
    taxista = await _taxistaProvider.obtenerId(idTaxista);
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

