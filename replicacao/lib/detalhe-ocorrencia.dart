import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'baseUrl.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

//Conectividade
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

String _selectedValue = 'Urgente';
String _selectedUser = '';
String userI = '', ocorrenciaId = '';
final Map<dynamic, dynamic> ocorrencia1 = Map<dynamic, dynamic>();
bool _connectado = false;
/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialize o Hive com um caminho de armazenamento
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Abra a caixa (Box)
  await Hive.openBox('partilha');

  runApp(DetalhesOcorrencia(
    userI: userI,
    ocorrencia: ocorrencia1,
  ));
}*/

class DetalhesOcorrencia extends StatefulWidget {
  String userI;
  final Map<dynamic, dynamic> ocorrencia;

  DetalhesOcorrencia(
      {super.key, required this.userI, required this.ocorrencia});

  @override
  State<DetalhesOcorrencia> createState() => _DetalhesOcorrenciaState();
}

class _DetalhesOcorrenciaState extends State<DetalhesOcorrencia> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  late Map<dynamic, dynamic> ocorrencia;
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  String? usuarioSelecionado;
  List<Map<dynamic, dynamic>> listaUsuarios = [];
  List<dynamic> dadosParaSincronizar = [];
  var data = [];

  late Box partilhaBox;

  //Dados ocorrencias
  //final Box _occurrenceBox = Hive.box('partilha');

  //final Box _occurrenceBox = Hive.box('partilha');
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // inicializarReplicacao();

  @override
  void initState() {
    super.initState();

    _initializeHive();
    fetchData();
    //iniailiazarDados();
    // Atribui o valor de userId à variável global _userIdLogado
    userI = widget.userI;
    ocorrencia = widget.ocorrencia;
    ocorrenciaId = widget.ocorrencia["id"];
    //inicializarReplicacao();

    //_checkConnectivityAndSync();

    /* _checkConnectivityAndSave();
    // Monitora mudanças na conectividade
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        _connectado = true;
        _syncData(); // Sincroniza quando a conexão é restabelecida
      }
    });*/
  }

  Future<void> _initializeHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Abre a caixa (Box)
    partilhaBox = await Hive.openBox('partilha');

    // Agora você pode usar a caixa `partilhaBox` para armazenar ou recuperar dados
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel(); // Cancela o listener ao sair
    super.dispose();
  }

  Future<void> _checkConnectivityAndSync() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.isNotEmpty &&
        connectivityResult.first != ConnectivityResult.none) {
      _syncData();
    } else {
      print("Não conectado...");

      /*  Map<String, dynamic> body = {
        "id": encryptarDado("00000000-0000-0000-0000-000000000000"),
        "utilizadorId": encryptarDado(_selectedUser),
        "ocorrenciaId": encryptarDado(ocorrenciaId)
      };*/

      //_occurrenceBox.add(jsonEncode(body));
    }
  }

  Future<void> _checkConnectivityAndSave() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.isNotEmpty &&
        connectivityResult.first != ConnectivityResult.none) {
      //_cadastrar(true);
    } else {
      _cadastrar(false);
      print("Não conectado...");

      /*  Map<String, dynamic> body = {
        "id": encryptarDado("00000000-0000-0000-0000-000000000000"),
        "utilizadorId": encryptarDado(_selectedUser),
        "ocorrenciaId": encryptarDado(ocorrenciaId)
      };*/

      //_occurrenceBox.add(jsonEncode(body));
    }
  }

  iniailiazarDados() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Abra a caixa (Box)
    await Hive.openBox('partilha');
  }

  Future<void> _syncData() async {
    // Simulação de sincronização
    await Future.delayed(Duration(seconds: 2)); // Simula um atraso de rede
    print('Dados sincronizados com sucesso!');

    Enviado();
  }

  void Enviado() async {
    for (int i = 0; i < partilhaBox.length; i++) {
      String jsonString = partilhaBox.getAt(i);

      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      var url = Uri.parse(baseUrl + "Ocorencia/partilha");

      Map<String, String> headers = {"Content-Type": "application/json"};

      try {
        final response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(jsonMap),
        );

        if (response.statusCode == 200) {
          //return true;
        } else {
          //return false;
        }
      } catch (e) {
        //return false;
      }

      partilhaBox.delete(i);
    }
  }

  Future<void> _cadastrar(bool connectado) async {
    if (connectado) {
      final descricao = nomeController.text;
      final senha = senhaController.text;

      bool resposta = await Partilhar();

      // Exibe a mensagem no SnackBar

      if (resposta == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ocorrencia Partilhada com sucesso!")),
        );

        nomeController.clear();
        senhaController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ocorrencia Não Partilhada!")),
        );
      }
    } else {
      print("Add offilne");

      Map<String, dynamic> body = {
        "id": encryptarDado("00000000-0000-0000-0000-000000000000"),
        "utilizadorId": encryptarDado(_selectedUser),
        "ocorrenciaId": encryptarDado(ocorrenciaId)
      };

      partilhaBox.add(jsonEncode(body));
    }
  }

  /* inicializarReplicacao() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Inicialize o Hive com um caminho de armazenamento
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Abra a caixa (Box)
    await Hive.openBox('occurrences');
  }*/

  Future<void> fetchData() async {
    final url = Uri.parse(baseUrl +
        'Utilizador/usersById?id=' +
        userI); // Substitua pela URL da sua API
    try {
      final response = await http.get(
        url,
        headers: {
          //'Authorization': 'Bearer $token', // Passando o token no cabeçalho
          'Content-Type':
              'application/json', // Defina o tipo de conteúdo como JSON, se necessário
        },
      );

      if (response.statusCode == 200) {
        // Sucesso! A resposta da API está no corpo da resposta.
        data = json.decode(response.body);

        // Itera sobre cada item e converte para Map<String, String>
        List<Map<dynamic, dynamic>> tempList = [];
        for (var dado in data) {
          tempList.add({'id': dado['id'], 'nome': dado['nome']});
        }

        // Atualiza a lista de produtos e a UI
        setState(() {
          listaUsuarios = tempList;
        });
      } else {
        print("Erro ao obter dados: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro na requisição: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Detalhes Ocorrencia'),
      ),
      backgroundColor: Colors.grey[100], // Cor de fundo cinza claro
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,

          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Descrição: " + ocorrencia["descricao"]),
                  const SizedBox(height: 16),
                  Text("Classificação: " + ocorrencia["classificar"]),
                  const SizedBox(height: 16),
                  Text("Data e hora ocorrida: " + ocorrencia["dataHora"]),
                  const SizedBox(height: 32),
                  Image.network(baseUrlImage + ocorrencia["fotoVideo"]),
                  const SizedBox(height: 32),
                  /*SingleChildScrollView(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentP,
                        zoom: 13,
                      ),
                    ),
                  ),*/
                  /*const GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentP,
                      zoom: 13,
                    ),
                  ),*/

                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(double.parse(ocorrencia["latitude"]),
                            double.parse(ocorrencia["longitude"])),
                        zoom: 13,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("_currentLocation"),
                          icon: BitmapDescriptor.defaultMarker,
                          position: LatLng(double.parse(ocorrencia["latitude"]),
                              double.parse(ocorrencia["longitude"])),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Partilhar Ocorrencia"),
                  DropdownButton<String>(
                    value: usuarioSelecionado,
                    hint: const Text("Selecione um usuário"),
                    items: listaUsuarios.map((usuario) {
                      return DropdownMenuItem<String>(
                        value:
                            usuario['id'].toString(), // Define o ID como valor
                        child: Text(usuario['nome']), // Exibe o nome
                      );
                    }).toList(),
                    onChanged: (String? novoValor) {
                      setState(() {
                        usuarioSelecionado = novoValor;
                        _selectedUser = novoValor.toString();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Ação do botão Aceder
                      // Navigator.pushNamed(context, "/telaPrincipal");
                      _cadastrar(true);
                    },
                    child: Text('Partilhar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: Colors.orange, // Cor de fundo do botão

                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<bool> Partilhar() async {
  var url = Uri.parse(baseUrl + "Ocorencia/partilha");

  Map<String, String> headers = {"Content-Type": "application/json"};

  Map<String, dynamic> body = {
    "id": encryptarDado("00000000-0000-0000-0000-000000000000"),
    "utilizadorId": encryptarDado(_selectedUser),
    "ocorrenciaId": encryptarDado(ocorrenciaId)
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

String encryptarDado(plainText) {
  final key =
      encrypt.Key.fromUtf8('1234567890123456'); // Chave de 16 bytes (AES-128)

  final iv = encrypt.IV.fromUtf8('abcdefghijklmnop'); // IV de 16 bytes

  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return base64.encode(encrypted.bytes);
}

Future<bool> PartilharSyncronizacao() async {
  var url = Uri.parse(baseUrl + "Ocorencia/partilha");

  Map<String, String> headers = {"Content-Type": "application/json"};

  Map<String, dynamic> body = {
    "id": encryptarDado("00000000-0000-0000-0000-000000000000"),
    "utilizadorId": encryptarDado(_selectedUser),
    "ocorrenciaId": encryptarDado(ocorrenciaId)
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
