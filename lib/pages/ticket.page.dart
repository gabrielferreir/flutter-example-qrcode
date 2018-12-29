import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class TicketPage extends StatefulWidget {
  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  String resultQr;
  final code = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future _scan() async {
    try {
      String result = await BarcodeScanner.scan();
      setState(() {
        code.text = result;
      });
      final snackBar = new SnackBar(
          content: new Text('Scanneado com sucesso'),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
          duration: Duration(seconds: 2));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          final snackBar = new SnackBar(
              content: new Text('Permissão negada'),
              action: SnackBarAction(label: 'OK', onPressed: () {}),
              duration: Duration(seconds: 2));
          _scaffoldKey.currentState.showSnackBar(snackBar);
          resultQr = 'Permissão negada';
        });
      } else {
        setState(() {
          resultQr = 'Erro desconhecido';
        });
        final snackBar = new SnackBar(
            content: new Text('Erro desconhecido'),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
            duration: Duration(seconds: 2));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } on FormatException catch (e) {
      setState(() {
        resultQr = 'Você voltou sem scannear';
      });
    } catch (e) {
      setState(() {
        resultQr = 'Erro desconhecido';
      });
    }
  }

  void cadastar(valor) {
    final snackBar = new SnackBar(
        content: new Text('Cadastrado com sucesso'),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
        duration: Duration(seconds: 2));
    _scaffoldKey.currentState.showSnackBar(snackBar);
    setState(() {
      code.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Cupons'),
        ),
        bottomNavigationBar: RaisedButton(
          padding: EdgeInsets.all(16.0),
          color: Colors.blue,
          onPressed: () {
            cadastar(code.text);
          },
          child: Text(
            'CADASTRAR CUPOM',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0),
          ),
        ),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[Text('MENU')],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            title: Text('Home'),
          )
        ])),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlutterLogo(
                        size: 120.0,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Cadastre seu cupom',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 24.0,
                        backgroundColor: Colors.blueAccent,
                        child: Text('T', style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Gabriel Ferreira',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black87)),
                            Text('***.***.***-**',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    color: Colors.black54))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: code,
                          decoration: InputDecoration(
                              hintText: 'Insira o código do cupom',
                              icon: IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: _scan)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
