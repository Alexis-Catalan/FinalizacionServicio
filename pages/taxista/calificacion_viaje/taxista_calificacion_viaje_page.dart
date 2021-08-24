import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:radio_taxi_alfa_app/src/pages/taxista/calificacion_viaje/taxista_calificacion_viaje_controlador.dart';
import 'package:radio_taxi_alfa_app/src/widgets/button_app.dart';
import 'package:radio_taxi_alfa_app/src/utils/colors.dart' as utils;

class TaxistaCalificacionViajePage extends StatefulWidget {

  @override
  _TaxistaCalificacionViajePageState createState() => _TaxistaCalificacionViajePageState();
}

class _TaxistaCalificacionViajePageState extends State<TaxistaCalificacionViajePage> {

  TaxistaCalificacionViajeControlador _con = new TaxistaCalificacionViajeControlador();

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
      bottomNavigationBar: _btnCalificacion(),
      body: Column(
        children: [
          _bannerInfo(),
          SizedBox(height: 10),
          _txtInfoViaje('Desde', _con.historialViaje?.origen ?? 'Dirección de Origen', Icons.my_location, utils.Colors.origen),
          SizedBox(height: 10),
          _txtInfoViaje('Hasta', _con.historialViaje?.destino ?? 'Dirección de Destino',  Icons.location_on, utils.Colors.destino),
          SizedBox(height: 40),
          _txtCalificacionCliente(),
          SizedBox(height: 10),
          _ratingBar()
        ],
      ),
    );
  }

  Widget _bannerInfo() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: 240,
        width: double.infinity,
        color: Colors.amber,
        child: SafeArea(
          child: Column(
            children: [
              Icon(Icons.check_circle, color: utils.Colors.temaColor, size: 100),
              SizedBox(height: 20),
              Text(
                'TU VIAJE HA FINALIZADO',
                style: TextStyle(
                  color: utils.Colors.temaColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _txtInfoViaje(String titulo, String value, IconData icono, Color color) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 0, top: 5 , right: 0, bottom: 0),
      child: ListTile(
        title: Text(
          titulo,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14
          ),
          maxLines: 1,
        ),
        subtitle: Text(
          value,
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14
          ),
          maxLines: 2,
        ),
        leading: Icon(icono, color: color),
      ),
    );
  }

  Widget _txtCalificacionCliente() {
    return Text(
      'CALIFICA A TU CLIENTE',
      style: TextStyle(
          color: utils.Colors.Azul,
          fontWeight: FontWeight.bold,
          fontSize: 18
      ),
    );
  }

  Widget _ratingBar() {
    return Center(
      child: RatingBar.builder(
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          initialRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemPadding: EdgeInsets.symmetric(horizontal: 4),
          unratedColor: Colors.grey[300],
          onRatingUpdate: (rating) {
            _con.calificacion = rating;
            print('RATING: $rating');
          }
      ),
    );
  }

  Widget _btnCalificacion() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(30),
      child: ButtonApp(
        onPressed: _con.Calificacion,
        text: 'CALIFICAR',
        color: Colors.amber,
        icon: Icons.thumb_up,
        iconColor: utils.Colors.temaColor,
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
