import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialize o Hive com um caminho de armazenamento
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Abra a caixa (Box)
  await Hive.openBox('occurrences');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Replicação de Ocorrências',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OccurrenceList(),
    );
  }
}

class OccurrenceList extends StatefulWidget {
  @override
  _OccurrenceListState createState() => _OccurrenceListState();
}

class Ocorrencia {
  // @HiveField(0)
  final String ocorrencia;

  //@HiveField(1)
  bool partilhado;

  Ocorrencia({
    required this.ocorrencia,
    this.partilhado = false, // Por padrão, não está sincronizado
  });
}

class _OccurrenceListState extends State<OccurrenceList> {
  final Box _occurrenceBox = Hive.box('occurrences');
  //final Box _occurrenceBox2 = Hive.box('occurrences');
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivityAndSync();

    // Monitora mudanças na conectividade
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        _syncData(); // Sincroniza quando a conexão é restabelecida
      }
    });
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
    }
  }

  Future<void> _syncData() async {
    // Mostra o diálogo de loading
    showDialog(
      context: context,
      barrierDismissible: false, // Impede que o usuário feche o diálogo
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // Indicador de carregamento
              SizedBox(height: 16),
              Text("Sincronizando..."), // Mensagem de sincronização
            ],
          ),
        );
      },
    );

    // Chama o método Enviado
    Enviado();

    // Simulação de sincronização
    await Future.delayed(Duration(seconds: 2)); // Simula um atraso de rede
    print('Dados sincronizados com sucesso!');

    // Fecha o diálogo de loading
    Navigator.of(context).pop();
  }

  void Enviado() {
    for (int i = 0; i < _occurrenceBox.length; i++) {
      String str = _occurrenceBox.getAt(i);

      var respon = str.split(";")[0];

      // _occurrenceBox2.add(respon + ";true");
    }

    /* _occurrenceBox.clear();

    // Itera sobre os valores da caixa de origem (_occurrenceBox2)
    for (var key in _occurrenceBox2.keys) {
      // Adiciona cada valor à caixa de destino (_occurrenceBox)
      _occurrenceBox.put(key, _occurrenceBox2.get(key));
    }*/

    print("Enviado...");
  }

  void _addOccurrence(String occurrence) {
    setState(() {
      _occurrenceBox
          .add(occurrence + ";false"); // Adiciona a ocorrência ao Hive
    });
    _checkConnectivityAndSync();
  }

  void _clearOccurrences() {
    setState(() {
      _occurrenceBox.clear(); // Limpa todos os dados da caixa
    });
    print('Dados da caixa limpos com sucesso!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ocorrências'),
        actions: [
          // Botão para limpar os dados
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearOccurrences,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _occurrenceBox.length,
        itemBuilder: (context, index) {
          var occurrence = _occurrenceBox.getAt(index);
          return ListTile(
            title: Text(occurrence),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOccurrenceDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddOccurrenceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newOccurrence = '';
        return AlertDialog(
          title: Text('Adicionar Ocorrência'),
          content: TextField(
            onChanged: (value) {
              newOccurrence = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                _addOccurrence(newOccurrence);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

/*
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

part 'ocorrencia.g.dart'; // Importe o arquivo gerado pelo Hive

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialize o Hive com um caminho de armazenamento
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Registre o adaptador da classe Ocorrencia
  Hive.registerAdapter(OcorrenciaAdapter());

  // Abra a caixa (Box)
  await Hive.openBox<Ocorrencia>('occurrences');

  runApp(MyApp());
}

@HiveType(typeId: 0)
class Ocorrencia {
  @HiveField(0)
  final String ocorrencia;

  @HiveField(1)
  bool partilhado;

  Ocorrencia({
    required this.ocorrencia,
    this.partilhado = false, // Por padrão, não está sincronizado
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Replicação de Ocorrências',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OccurrenceList(),
    );
  }
}

class OccurrenceList extends StatefulWidget {
  @override
  _OccurrenceListState createState() => _OccurrenceListState();
}

class _OccurrenceListState extends State<OccurrenceList> {
  final Box<Ocorrencia> _occurrenceBox = Hive.box<Ocorrencia>('occurrences');
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivityAndSync();

    // Monitora mudanças na conectividade
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        _syncData(); // Sincroniza quando a conexão é restabelecida
      }
    });
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
    }
  }

  Future<void> _syncData() async {
    // Mostra o diálogo de loading
    showDialog(
      context: context,
      barrierDismissible: false, // Impede que o usuário feche o diálogo
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // Indicador de carregamento
              SizedBox(height: 16),
              Text("Sincronizando..."), // Mensagem de sincronização
            ],
          ),
        );
      },
    );

    try {
      // Filtra ocorrências não sincronizadas (partilhado = false)
      List<Ocorrencia> ocorrenciasNaoSincronizadas = _occurrenceBox.values
          .where((ocorrencia) => !ocorrencia.partilhado)
          .toList();

      // Simula o envio das ocorrências
      for (var ocorrencia in ocorrenciasNaoSincronizadas) {
        await Future.delayed(Duration(seconds: 1)); // Simula o envio
        print('Enviando: ${ocorrencia.ocorrencia}');

        // Atualiza o campo partilhado para true
        ocorrencia.partilhado = true;
        _occurrenceBox.put(
          _occurrenceBox
              .keyAt(_occurrenceBox.values.toList().indexOf(ocorrencia)),
          ocorrencia,
        );
      }

      print('Dados sincronizados com sucesso!');
    } catch (e) {
      print('Erro durante a sincronização: $e');
    } finally {
      // Fecha o diálogo de loading
      Navigator.of(context).pop();
    }
  }

  void _addOccurrence(String occurrence) {
    setState(() {
      _occurrenceBox.add(Ocorrencia(
        ocorrencia: occurrence,
        partilhado: false, // Por padrão, não está sincronizado
      ));
    });
    _checkConnectivityAndSync();
  }

  void _clearOccurrences() {
    setState(() {
      _occurrenceBox.clear(); // Limpa todos os dados da caixa
    });
    print('Dados da caixa limpos com sucesso!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ocorrências'),
        actions: [
          // Botão para limpar os dados
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearOccurrences,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _occurrenceBox.length,
        itemBuilder: (context, index) {
          var occurrence = _occurrenceBox.getAt(index);
          return ListTile(
            title: Text(occurrence!.ocorrencia),
            subtitle: Text(
                occurrence.partilhado ? 'Sincronizado' : 'Não sincronizado'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOccurrenceDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddOccurrenceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newOccurrence = '';
        return AlertDialog(
          title: Text('Adicionar Ocorrência'),
          content: TextField(
            onChanged: (value) {
              newOccurrence = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                _addOccurrence(newOccurrence);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}*/
