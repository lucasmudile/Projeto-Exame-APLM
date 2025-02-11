import 'package:app_gas/criar-ocorrencia-camera.dart';
import 'package:app_gas/detalhe-ocorrencia.dart';
import 'package:app_gas/ver-ocorrencia.dart';
import 'package:flutter/material.dart';
import 'menu-principal.dart';
import 'login.dart';
import 'criar-conta.dart';
import 'package:camera/camera.dart';

late final firstCamera;
void main() async {
  runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  firstCamera = cameras.first;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> ocorrencia = {};
    return MaterialApp(
      initialRoute: "/login",
      routes: {
        //  "/": (context) => const TelaSplash(),
        "/login": (context) => const LoginPage(),
        /*"/telaPrincipal": (context) =>
            const TelaPrincipal(nome: "Lucas", userId: ""),*/
        "/criar-conta": (context) => const CriarConta(),
        "/camera": (context) => CameraScreen(camera: firstCamera, userId: ""),
        "/ocorrencia": (context) => VisualizarDetalhes(
              userId: "",
            ),
        "/detalhes": (context) => DetalhesOcorrencia(
              userI: "",
              ocorrencia: ocorrencia,
            ),
      },
    );
  }
}

class TelaSplash extends StatelessWidget {
  const TelaSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Tela Splash"),
          ),
          body: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text("Ir para Tela Login")),
          ),
        ),
      ),
    );
  }
}
