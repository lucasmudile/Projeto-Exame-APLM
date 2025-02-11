import 'package:app_gas/login.dart';
import 'package:flutter/material.dart';
import 'baseUrl.dart';

import 'dart:convert'; // Para converter objetos Dart em JSON
import 'package:http/http.dart' as http;

class CriarConta extends StatefulWidget {
  const CriarConta({super.key});

  @override
  State<CriarConta> createState() => _CriarContaState();
}

class _CriarContaState extends State<CriarConta> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  Future<void> _cadastrar() async {
    final nome = nomeController.text;
    final senha = senhaController.text;

    if (nome == "" || senha == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Insira o nome e a Senha!")),
      );
      return;
    }

    String resposta = await cadastrarUsuario(nome, senha);

    // Exibe a mensagem no SnackBar

    if (resposta == "true") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuário Cadastrado com sucesso!")),
      );

      nomeController.clear();
      senhaController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuário Não Cadastrado! " + resposta)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Criar Conta'),
      ),
      backgroundColor: Colors.grey[100], // Cor de fundo cinza claro
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Logo (substitua pelo seu asset)
                    /*Image.asset('assets/logo.png',
                  height:
                      100), // Certifique-se de adicionar o asset no pubspec.yaml
              const SizedBox(height: 24),*/

                    const Text(
                      'Criar conta',
                      //textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.verified_user_outlined,
                            color: Colors.orange),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: senhaController,
                      decoration: const InputDecoration(
                        labelText: 'Palavra-passe',
                        prefixIcon: Icon(Icons.lock, color: Colors.orange),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: () {
                        // Ação do botão Aceder
                        // Navigator.pushNamed(context, "/telaPrincipal");
                        _cadastrar();
                      },
                      child: Text('Criar Conta'),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<String> cadastrarUsuario(String nome, String senha) async {
  final url =
      Uri.parse(baseUrl + 'Utilizador'); // Substitua com a URL da sua API

  // Corpo da requisição (no formato JSON)
  final Map<String, String> body = {
    'nome': nome,
    'senha': senha,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json'
      }, // Definindo o tipo de conteúdo como JSON
      body: json.encode(body), // Convertendo o corpo para JSON
    );

    if (response.statusCode == 200) {
      // Requisição bem-sucedida
      print('Usuário cadastrado com sucesso!');
      return response.body;
    } else {
      // Se algo der errado (por exemplo, status 400, 404, 500)
      print('Erro ao cadastrar usuário: ${response.body}');

      return response.body;
    }
  } catch (e) {
    print('Erro na requisição: $e');
    return "false";
  }
}
