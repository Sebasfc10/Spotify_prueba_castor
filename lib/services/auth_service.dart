import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:spotify_app_prueba/models/auth_model.dart';

import 'package:spotify_app_prueba/utils/repository.dart';

class AuthorizationService {
  final RepositoryAuthorization _repository = RepositoryAuthorization();

  // StreamController para emitir el código de autorización
  final _authorizationCodeController = StreamController<String>();

  final StreamController<AuthorizationModel> _authorizationController =
      StreamController<AuthorizationModel>.broadcast();

  Stream<AuthorizationModel> get authorizationTokenStream =>
      _authorizationController.stream;

  // BehaviorSubject para emitir el token de autorización
  final _authorizationTokenSubject = BehaviorSubject<AuthorizationModel>();

  // Flujo para acceder al código de autorización
  Stream<String> get authorizationCodeStream =>
      _authorizationCodeController.stream;

  // Método para iniciar el flujo de autorización
  void fetchAuthorizationCode() async {
    try {
      final code = await _repository.fetchAuthorizationCode();
      if (code == null || code == "access_denied") {
        // Aquí puedes manejar el caso en que el usuario canceló el inicio de sesión
        // Puedes mostrar un mensaje al usuario o realizar otras acciones necesarias
        print("El usuario canceló el inicio de sesión.");
      } else {
        _authorizationCodeController.add(code);
      }
    } catch (e, stackTrace) {
      print("Error al obtener el código de autorización: $e");
      print("StackTrace: $stackTrace");
      _authorizationCodeController.addError(e.toString());
    }
  }

  // Método para obtener el token de autorización
  void fetchAuthorizationToken(String code) async {
    try {
      final token = await _repository.fetchAuthorizationToken(code);
      if (!_authorizationTokenSubject.isClosed) {
        _authorizationTokenSubject.add(
            token); // Emite el token al BehaviorSubject si el StreamController no está cerrado
        _authorizationController.add(token);
      }
      /* _authorizationController.add(token);
      _authorizationTokenSubject.add(token); */
    } catch (e) {
      if (!_authorizationTokenSubject.isClosed) {
        _authorizationController.addError(e);
        _authorizationTokenSubject.addError(
            e); // Emite el error al BehaviorSubject si el StreamController no está cerrado
      }
      /*  
      _authorizationTokenSubject.addError(e.toString()); */
    }
  }

  // Cerrar los flujos cuando ya no sean necesarios
  void dispose() {
    _authorizationCodeController.close();
    _authorizationTokenSubject.close();
  }
}

/* final AuthorizationService authorizationService = AuthorizationService(); */
