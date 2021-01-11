import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
final List<String> subTitles = ['Mi cuenta', 'Cerrar Sesión'];

class InfoPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/topexpress_logo_title.png",
              ),
              ConstrainedBox(
                constraints: new BoxConstraints(
                  maxHeight: 300.0,
                ),
                child: Image.asset(
                  "assets/images/topexpress_logo.png",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, left:20),
                child: Column(
                  children: [
                    Text('El servicio que ofrecemos consiste en entregar en México, compras que realizan nuestros clientes por línea en USA. \n'),
                    Text('Se realiza la orden con la dirección: \n1811 Lime Court, Unit 6, Chula Vista CA 91913\n', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Se envía: nombre del cliente, comprobante de compra o factura y número de rastreo a este correo electrónico y una vez que lo recibimos en nuestro domicilio, lo entregamos en un periodo de 3-5 días!! \n'),
                    Text('El costo de servicio es del 20% en base al valor total de compra; el pago se realiza contra entrega.\n'),
                    Text('Las entregas se realizan en Torre Icon Oficinas: \nAv Empresarios 255, Puerta De Hierro,  45116, Zapopan, Jal. \nO se puede solicitar servicio a domicilio dependiendo de la zona.'),
                  ],
                ),
              )
            ],
          )
        ),
      )
    );
  }

  Widget renderBackground(){
    return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 150.0),
                child: Image.asset(
                  "assets/images/topexpress_logo.png",
                ),
              ),
            ],
          );
  }

}
