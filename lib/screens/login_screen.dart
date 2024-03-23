import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spotify_app_prueba/services/auth_service.dart';
import 'package:spotify_app_prueba/models/auth_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  //late FlutterGifController controller1;
  final AuthorizationService _authorizationService = AuthorizationService();
  late StreamSubscription<String> _authorizationSubscription;
  late StreamSubscription<AuthorizationModel> _tokenSubscription;

  @override
  void initState() {
    super.initState();
/*     controller1 = FlutterGifController(vsync: this);

    // Iniciar la animación
    controller1.repeat(
      min: 0,
      max: 1,
      period: const Duration(milliseconds: 200),
    ); */

    _authorizationSubscription = _authorizationService.authorizationCodeStream
        .listen((authorizationCode) {
      if (authorizationCode != "access_denied") {
        print("Authorization Code: $authorizationCode");
        _authorizationService.fetchAuthorizationToken(authorizationCode);
      }
    });

    _tokenSubscription =
        _authorizationService.authorizationTokenStream.listen((token) {
      print("Authorization Token: $token");
      // Aquí podrías navegar a la siguiente pantalla o realizar otras acciones
    });
  }

  @override
  void dispose() {
    _authorizationSubscription.cancel();
    _tokenSubscription.cancel();
    _authorizationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              fit: BoxFit.fitHeight,
              image: const AssetImage("assets/images/fondo.gif"),
            ),
          ),
          PositionedDirectional(
            top: MediaQuery.of(context).size.height * 0.85,
            start: MediaQuery.of(context).size.width * 0.2,
            end: MediaQuery.of(context).size.width * 0.2,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  _authorizationService.fetchAuthorizationCode();
                  await Navigator.pushNamed(context, "/wait");
                },
                child: Text(
                  'Sign In with Spotify',
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xff1ed760)), // Cambia el color aquí
                  elevation: MaterialStateProperty.all<double>(
                      0), // Elimina la sombra aquí
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Ajusta el radio aquí para cambiar la redondez de los bordes
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
