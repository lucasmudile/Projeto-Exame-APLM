import 'package:app_gas/criar-conta.dart';
import 'package:app_gas/menu-principal.dart';
import 'package:flutter/material.dart';
import 'baseUrl.dart';

import 'dart:convert'; // Para converter objetos Dart em JSON
import 'package:http/http.dart' as http;

String token = "";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  Future<void> _logar() async {
    final email = emailController.text;
    final senha = senhaController.text;
    String resposta = "";
    if (senha == "" || email == "")
      resposta = "";
    else
      resposta = await Login(email, senha);

    // Exibe a mensagem no SnackBar

    if (resposta == "00000000-0000-0000-0000-000000000000") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Credenciais inválidas.")),
      );
      return;
    }

    if (resposta.length == 36) {
      print("--------------------------------------------------");
      print(resposta);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuário Logado com sucesso!")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TelaPrincipal(nome: email, userId: resposta)),
      );
      //resposta = "";
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ocorreu um erro.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Faça o seu Login',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.verified_user_outlined,
                            color: Colors.orange),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu nome';
                        }
                        return null;
                      },
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a senha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: () {
                        _logar();
                      },
                      child: Text('Entrar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: Colors.orange, // Cor de fundo do botão
                        //color: Colors.white, // Cor do texto no botão
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        // Ação para criar uma conta
                        // Navigator.pushNamed(context, "/criar-conta");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CriarConta()),
                        );
                      },
                      child: const Text('Criar uma conta'),
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

Future<String> Login(String email, String senha) async {
  final url =
      Uri.parse(baseUrl + 'Utilizador/login'); // Substitua com a URL da sua API

  // Corpo da requisição (no formato JSON)
  final Map<String, String> body = {
    'nome': email,
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

    print(response.body);
    if (response.statusCode == 200) {
      // Requisição bem-sucedida
      print('Usuário logado com sucesso!');
      print(response.body);
      return response.body;
    } else {
      // Se algo der errado (por exemplo, status 400, 404, 500)
      print('Erro ao logar usuário: ${response.body}');
      return response.body;
    }
  } catch (e) {
    print('Erro na requisição: $e');
    return "";
  }
}
