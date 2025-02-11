import 'dart:io';

import 'package:flutter/material.dart';
import 'baseUrl.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // Para carregar arquivos dos assets
import 'package:path_provider/path_provider.dart';

String _selectedValue = 'Urgente';
String _userIdLogado = '';

class CriarOcorrencia extends StatefulWidget {
  String userId;

  CriarOcorrencia({super.key, required this.userId});

  @override
  State<CriarOcorrencia> createState() => _CriarOcorrenciaState();
}

class _CriarOcorrenciaState extends State<CriarOcorrencia> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Atribui o valor de userId à variável global _userIdLogado
    _userIdLogado = widget.userId;
  }

  Future<void> _cadastrar() async {
    final descricao = nomeController.text;
    final senha = senhaController.text;

    bool resposta = await cadastrarUsuario(descricao, senha);

    // Exibe a mensagem no SnackBar

    if (resposta == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuário Cadastrado com sucesso!")),
      );

      nomeController.clear();
      senhaController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuário Não Cadastrado!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Criar Ocorrencia'),
      ),
      backgroundColor: Colors.grey[100], // Cor de fundo cinza claro
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    prefixIcon: Icon(Icons.verified_user_outlined,
                        color: Colors.orange),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                /*const Text('Classificar',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),*/
                DropdownButton<String>(
                  value: _selectedValue,
                  items: const [
                    DropdownMenuItem(value: 'Urgente', child: Text('Urgente')),
                    DropdownMenuItem(
                        value: 'Não-Urgente', child: Text('Não-Urgente')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedValue = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Ação do botão Aceder
                    // Navigator.pushNamed(context, "/telaPrincipal");
                    _cadastrar();
                  },
                  child: Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    backgroundColor: Colors.orange, // Cor de fundo do botão
                    //color: Colors.white, // Cor do texto no botão
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<bool> cadastrarUsuario(String descricao, String senha) async {
  var url = Uri.parse(baseUrl + "Ocorencia");

  var request = http.MultipartRequest("POST", url);

  // Adiciona campos normais
  request.fields["id"] = "00000000-0000-0000-0000-000000000000";
  request.fields["latitude"] = "10.5";
  request.fields["longitude"] = "10.5";
  request.fields["descricao"] = descricao;
  request.fields["classificar"] = _selectedValue;
  request.fields["utilizadorId"] = _userIdLogado;

  // Carregar o arquivo da pasta assets
  File file = await getAssetImageFile("assets/gas1.png");

  // Adiciona o arquivo à requisição
  request.files.add(
    await http.MultipartFile.fromPath("file", file.path, filename: "gas1.png"),
  );

  // Adiciona headers, se necessário
  request.headers.addAll({
    "Content-Type": "multipart/form-data",
  });

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Upload bem-sucedido!");
      var responseData = await response.stream.bytesToString();
      print("Resposta: $responseData");
    } else {
      print("Erro no upload: ${response.statusCode}");
    }
  } catch (e) {
    print("Erro: $e");
  }

  return true;
}

Future<File> getAssetImageFile(String assetPath) async {
  // Carrega a imagem dos assets
  ByteData byteData = await rootBundle.load(assetPath);
  Uint8List bytes = byteData.buffer.asUint8List();

  // Obtém o diretório temporário do dispositivo
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = "${tempDir.path}/temp_image.png";

  // Salva a imagem no diretório temporário
  File file = File(tempPath);
  await file.writeAsBytes(bytes);

  return file;
}

passarValor(String valor) {}
