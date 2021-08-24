import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:radio_taxi_alfa_app/src/pages/informacion_viaje/informacion_viaje_controlador.dart';
import 'package:radio_taxi_alfa_app/src/utils/colors.dart' as utils;

class InformacionViajePage extends StatefulWidget {
  @override
  _InformacionViajePageState createState() => _InformacionViajePageState();
}

class _InformacionViajePageState extends State<InformacionViajePage> {
  InformacionViajeControlador _con = InformacionViajeControlador();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      body: Stack(
        children: [
          Align(
            child: _googleMapsWidget(),
            alignment: Alignment.topCenter,
          ),
          Align(
            child: _cardInformacionViaje(),
            alignment: Alignment.bottomCenter,
          ),
          Align(
            child: _btnRegregar(),
            alignment: Alignment.topLeft,
          ),
        ],
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.marcadores.values),
      polylines: _con.polylines,
    );
  }

  Widget _btnRegregar() {
    return SafeArea(
      child: GestureDetector(
        onTap: _con.Regresar,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: utils.Colors.degradadoColor,
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardInformacionViaje() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 0, top: 5 , right: 0, bottom: 0),
        child: Column(
          children: [
            ListTile(
              title: Text(
        '${_con.historialViaje?.distancia?.toStringAsFixed(2) ?? 0} km' ?? '',
                style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                 'Distancia',
                maxLines: 1,
                style: TextStyle(fontSize: 13),
              ),
              leading: Icon(Icons.directions_outlined, color: utils.Colors.temaColor),
            ),
            ListTile(
              title: Text(
                _con.historialViaje?.duracion ?? '0 min',
                style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Duración',
                style: TextStyle(fontSize: 13),
                maxLines: 1,
              ),
              leading: Icon(Icons.timer, color: utils.Colors.temaColor),
            ),
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
