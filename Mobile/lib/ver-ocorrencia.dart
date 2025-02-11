import 'package:app_gas/detalhe-ocorrencia.dart';
import 'package:app_gas/login.dart';
import 'package:flutter/material.dart';
import 'baseUrl.dart';

import 'dart:convert'; // Para converter objetos Dart em JSON
import 'package:http/http.dart' as http;

String userI = "";

class VisualizarDetalhes extends StatefulWidget {
  String userId;
  VisualizarDetalhes({super.key, required this.userId});

  @override
  State<VisualizarDetalhes> createState() => _VisualizarDetalhesContaState();
}

class _VisualizarDetalhesContaState extends State<VisualizarDetalhes> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  List<Map<dynamic, dynamic>> listaOcorrencias = [];
  var data = [];

  @override
  void initState() {
    super.initState();
    userI = widget.userId;
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        baseUrl + 'Ocorencia/list/' + userI); // Substitua pela URL da sua API
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
          tempList.add({
            'id': dado['id'],
            'fotoVideo': dado['fotoVideo'],
            'dataHora': dado['dataHora'],
            'latitude': dado['latitude'],
            'longitude': dado['longitude'],
            'descricao': dado['descricao'],
            'classificar': dado['classificar'],
            'utilizadorId': dado['utilizadorId'],
          });
        }

        // Atualiza a lista de produtos e a UI
        setState(() {
          listaOcorrencias = tempList;
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
        title: const Text('Listar Ocorrencia'),
      ),
      backgroundColor: Colors.grey[100], // Cor de fundo cinza claro
      body: listaOcorrencias.isEmpty
          ? const Center(child: Text('Sem Ocorrencias'))
          : ListView.builder(
              itemCount: listaOcorrencias.length,
              itemBuilder: (context, index) {
                final item = listaOcorrencias[index];
                return ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(item['descricao']),
                  subtitle: Text("Classificação: " + item['classificar']),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetalhesOcorrencia(
                                userI: userI, //item['utilizadorId'],
                                ocorrencia: item,
                              )),
                    );
                  },
                );
              },
            ),
    );
  }
}
