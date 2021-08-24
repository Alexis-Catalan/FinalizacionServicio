import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:radio_taxi_alfa_app/src/pages/taxista/historial_detalle/taxista_historial_detalle_controlador.dart';
import 'package:radio_taxi_alfa_app/src/utils/colors.dart' as utils;
import 'package:radio_taxi_alfa_app/src/widgets/button_app.dart';

class TaxistaHistorialDetallePage extends StatefulWidget {
  @override
  _TaxistaHistorialDetallePageState createState() => _TaxistaHistorialDetallePageState();
}

class _TaxistaHistorialDetallePageState extends State<TaxistaHistorialDetallePage> {

  TaxistaHistorialDetalleControlador _con = new TaxistaHistorialDetalleControlador();

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
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        centerTitle: true,
        title: Text('Detalle del historial'),
      ),
      body: SingleChildScrollView(
        child: Column(
         children: [
           _appInfoCliente(),
           _listaInfo('Origen: ', _con.historialViaje?.origen, Icons.my_location, utils.Colors.origen),
           _listaInfo('Destino: ', _con.historialViaje?.destino, Icons.location_on, utils.Colors.destino),
           _infoViaje(),
           _listaInfoCalificacion('Mi calificación:', _con.historialViaje?.calificacionTaxista ?? 0, Icons.stars, utils.Colors.taxi),
           _listaInfoCalificacion('Calificación al cliente:', _con.historialViaje?.calificacionCliente ?? 0, Icons.stars, Colors.amber),
           _listaInfo('Fecha: ', _con.fecha ?? 'Fecha Viaje', Icons.event, utils.Colors.fecha),
         ],
        ),
      ),
    );
  }

  Widget _listaInfo(String titulo, String info, IconData icono, Color iconColor) {
    return ListTile(
      title: Text(
          titulo,
        style: TextStyle(
        fontWeight: FontWeight.bold,)
      ),
      subtitle: Text(info ?? 'Dirección'),
      leading: Icon(icono,color: iconColor,),
    );
  }

  Widget _infoViaje(){
    return Container(
        height: 40,
        margin: EdgeInsets.only(left: 70,right: 30, bottom: 15),
        child: ButtonApp(
          onPressed: _con.Informacion,
          text: 'Ver Ruta',
          icon: Icons.alt_route,
        )
    );
  }

  Widget _listaInfoCalificacion(String titulo, double info, IconData icono, Color iconColor) {
    return ListTile(
      title: Text(
        titulo,
        style: TextStyle(
          fontWeight: FontWeight.bold,),
      ),
      subtitle: Container(
        child: Row(
          children: [
            Text('$info',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,)),
            RatingBar.builder(
              initialRating: info ?? 0,
              itemCount: 5,
              allowHalfRating: true,
              itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
      leading: Icon(icono, color: iconColor),
    );
  }

  Widget _appInfoCliente() {
    return ClipPath(
      clipper: DiagonalPathClipperTwo(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.29,
        width: double.infinity,
        color: utils.Colors.temaColor,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            CircleAvatar(
              backgroundImage: _con.cliente?.imagen != null
                  ? NetworkImage(_con.cliente?.imagen)
                  : AssetImage('assets/img/profile.jpg'),
              radius: 50,
            ),
            SizedBox(height: 5),
            Text(
              _con.cliente?.nombreUsuario ?? 'Nombre Cliente',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {

    });
  }
}
