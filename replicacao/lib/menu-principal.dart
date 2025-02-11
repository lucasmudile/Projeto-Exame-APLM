import 'package:app_gas/criar-ocorrencia-camera.dart';
import 'package:app_gas/criar-conta.dart';
import 'package:app_gas/criar-ocorrencia.dart';
import 'package:app_gas/login.dart';
import 'package:app_gas/ver-ocorrencia.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Para converter objetos Dart em JSON
import 'package:http/http.dart' as http;
import 'baseUrl.dart';

import 'package:camera/camera.dart';

List<Map<String, dynamic>> cartItems = [];
double total = 0;
String userI = "";

class TelaPrincipal extends StatelessWidget {
  final String nome, userId;
  const TelaPrincipal({Key? key, required this.nome, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GasAppScreen(nome: nome, userId: userId),
    );
  }
}

class GasAppScreen extends StatefulWidget {
  final String nome, userId;
  GasAppScreen({Key? key, required this.nome, required this.userId})
      : super(key: key);

  @override
  _GasAppScreenState createState() => _GasAppScreenState();
}

class _GasAppScreenState extends State<GasAppScreen> {
  List<Map<dynamic, dynamic>> listaProdutos = [];
  var data = [];
  var firstCamera = null;

  @override
  void initState() {
    super.initState();
    Initciliazar();

    userI = widget.userId;
  }

  Future<void> Initciliazar() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  accountName: const Text("Usuário",
                      style: TextStyle(color: Colors.black)),
                  accountEmail:
                      Text(widget.nome, style: TextStyle(color: Colors.black))),

              ListTile(
                leading: const Icon(Icons.supervised_user_circle_sharp,
                    color: Colors.orange),
                title: const Text("Criar Ocorrencia"),
                //subtitle: Text("Selecione a opção no menu"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CameraScreen(camera: firstCamera, userId: userI)),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.supervised_user_circle_sharp,
                    color: Colors.orange),
                title: const Text("Lista de  Ocorrências"),
                //subtitle: Text("Selecione a opção no menu"),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisualizarDetalhes(userId: userI),
                    ),
                  )
                },
              ),

              const Divider(
                color: Colors.black54,
              ),
              ListTile(
                  leading: const Icon(Icons.supervised_user_circle_sharp,
                      color: Colors.orange),
                  title: const Text("Sair da conta"),
                  //subtitle: Text("Selecione a opção no menu"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  }),

              // Adicione as outras opções do drawer aqui...
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text('Sistema Cidadão Activo',
              style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Text("Bem vindo ao Sistema de Cidadão Activo"),
        ));
  }
}
