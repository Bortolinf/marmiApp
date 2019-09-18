import 'package:flutter/material.dart';

const Color _kFlutterBlue = Color(0xFF003D75);

class MenuButton extends StatelessWidget {
// parametros de entrada do meu objeto
  final String text;
  final Icon icon;
  final Function onPressed;
  final Color color;

  // construtor:  1. texto do botão, em seguida recebe
  // a função do onpressed (obrigatoria)
  // e por ultimo a cor do botão que é opcional (blue é a cor default)
  //MenuButton(this.text, this.icon, {@required this.onPressed});
  MenuButton(this.text, this.icon, {@required this.onPressed, this.color});
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: RawMaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          fillColor: Theme.of(context).accentColor, // Colors.deepOrange[100],
          padding: EdgeInsets.zero,
          hoverColor: Colors.blue,
          splashColor: Colors.blue.withOpacity(0.32),
          highlightColor: Colors.transparent,
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: icon,
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22.0, color: _kFlutterBlue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
       
        child: Container(
          width: 250.0,
          height: 250.0,
                  child: Card(
            color: Colors.red,
       //   width: 250.0,
       //   height: 250.0,
            child: Column(
              
              children: <Widget>[
                Text(text, style: TextStyle(color: Colors.white, fontSize: 20.0)),
                icon,
              ],
            ),
          ),
        ),
        onPressed: onPressed);
  }
}
*/
