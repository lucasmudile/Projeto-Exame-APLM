/*import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MaterialApp(
    home: CameraScreen(camera: firstCamera),
  ));
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isRecording = false;
  String? mediaPath;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture; // Aguarda a inicialização
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final directory = await getApplicationDocumentsDirectory();
      final path =
          join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.png');

      final XFile imageFile = await _controller.takePicture();
      await imageFile.saveTo(path);

      setState(() {
        mediaPath = path;
        _videoController?.dispose();
        _videoController = null;
      });

      print("Foto salva em: $path");
    } catch (e) {
      print("Erro ao tirar foto: $e");
    }
  }

  Future<void> _startRecording() async {
    try {
      await _initializeControllerFuture;
      final directory = await getApplicationDocumentsDirectory();
      final path =
          join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.mp4');

      await _controller.startVideoRecording();
      setState(() {
        isRecording = true;
        mediaPath = null;
      });

      print("Gravando vídeo...");
    } catch (e) {
      print("Erro ao iniciar gravação: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      final XFile videoFile = await _controller.stopVideoRecording();
      await _controller.dispose(); // Libera a câmera antes de iniciar o vídeo

      setState(() {
        isRecording = false;
        mediaPath = videoFile.path;
        _initializeVideoPlayer();
      });

      print("Vídeo salvo em: $mediaPath");
    } catch (e) {
      print("Erro ao parar gravação: $e");
    }
  }

  Future<void> _initializeVideoPlayer() async {
    if (mediaPath != null) {
      _videoController = VideoPlayerController.file(File(mediaPath!));

      await _videoController!.initialize();
      setState(() {});
      _videoController!.play();
    }
  }

  void _resetCamera() {
    setState(() {
      mediaPath = null;
      _videoController?.dispose();
      _videoController = null;
    });

    _initializeCamera(); // Reabre a câmera
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capturar Foto ou Vídeo')),
      body: Center(
        child: mediaPath != null
            ? mediaPath!.endsWith('.mp4')
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Vídeo gravado:", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      _videoController != null &&
                              _videoController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            )
                          : CircularProgressIndicator(),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _resetCamera,
                        child: Text("Capturar novamente"),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Foto capturada:", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Image.file(File(mediaPath!),
                          width: 300, height: 400, fit: BoxFit.cover),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _resetCamera,
                        child: Text("Capturar novamente"),
                      ),
                    ],
                  )
            : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Transform.rotate(
                      angle:
                          90 * 3.1415926535897932 / 180, // Rotação de 90 graus
                      child: CameraPreview(_controller),
                    );
                    //return CameraPreview(_controller);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
      ),
      floatingActionButton: mediaPath == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: isRecording ? null : _takePicture,
                  child: Icon(Icons.camera),
                  tooltip: 'Tirar Foto',
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    if (isRecording) {
                      _stopRecording();
                    } else {
                      _startRecording();
                    }
                  },
                  child: Icon(isRecording ? Icons.stop : Icons.videocam),
                  tooltip: isRecording ? 'Parar Gravação' : 'Gravar Vídeo',
                ),
              ],
            )
          : null,
    );
  }
}*/

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'baseUrl.dart';
import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MaterialApp(
    home: CameraScreen(camera: firstCamera, userId: ""),
  ));
}*/

String _selectedValue = 'Urgente';
String? mediaPath;
String _userIdLogado = "";
LatLng? _currentP = LatLng(-8.9238339, 13.1803793);

class CameraScreen extends StatefulWidget {
  final String userId;
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera, required this.userId})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  Location _locationController = new Location();

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  final TextEditingController nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    //getLocation();
    _userIdLogado = widget.userId;
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture; // Aguarda a inicialização
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final directory = await getApplicationDocumentsDirectory();
      final path =
          join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.png');

      final XFile imageFile = await _controller.takePicture();
      await imageFile.saveTo(path);

      setState(() {
        mediaPath = path;
      });

      print("Foto salva em: $path");
    } catch (e) {
      print("Erro ao tirar foto: $e");
    }
  }

  void _resetCamera() {
    setState(() {
      mediaPath = null;
    });

    _initializeCamera(); // Reabre a câmera
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _cadastrar() async {
      final descricao = nomeController.text;

      bool resposta = await cadastrarOcorrencia(descricao);

      // Exibe a mensagem no SnackBar

      if (resposta == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ocorrencia Cadastrada com sucesso!")),
        );

        nomeController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ocorrencia Não Cadastrado!")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Capturar Foto')),
      body: Center(
        child: mediaPath != null
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Text("Foto capturada:", style: TextStyle(fontSize: 18)),
                    //SizedBox(height: 10),
                    Image.file(File(mediaPath!),
                        width: 300, height: 400, fit: BoxFit.cover),
                    SizedBox(height: 10),
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
                    DropdownButton<String>(
                      value: _selectedValue,
                      items: const [
                        DropdownMenuItem(
                            value: 'Urgente', child: Text('Urgente')),
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
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _resetCamera,
                      child: Text("Capturar novamente"),
                    ),
                  ],
                ),
              )
            : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Transform.rotate(
                      angle:
                          90 * 3.1415926535897932 / 180, // Rotação de 90 graus
                      child: CameraPreview(_controller),
                    );
                    //return CameraPreview(_controller);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
      ),
      floatingActionButton: mediaPath == null
          ? FloatingActionButton(
              onPressed: _takePicture,
              child: Icon(Icons.camera),
              tooltip: 'Tirar Foto',
            )
          : null,
    );
  }

  Future<void> getLocation() async {
    try {
      bool _serviceEnable;
      PermissionStatus _permissionGranted;

      _serviceEnable = await _locationController.serviceEnabled();

      _serviceEnable = true;
      if (_serviceEnable) {
        _serviceEnable = await _locationController.requestService();
      }

      _permissionGranted = await _locationController.hasPermission();

      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _locationController.requestPermission();

        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationController.onLocationChanged
          .listen((LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _currentP =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
          });
        }
      });
    } catch (ex) {
      _currentP = LatLng(-8.9238339, 13.1803793);
    }
  }
}

Future<bool> cadastrarOcorrencia(String descricao) async {
  var url = Uri.parse(baseUrl + "Ocorencia");

  var request = http.MultipartRequest("POST", url);

  // Adiciona campos normais
  request.fields["id"] = "00000000-0000-0000-0000-000000000000";
  request.fields["latitude"] = _currentP!.latitude.toString();
  request.fields["longitude"] = _currentP!.longitude.toString();
  request.fields["descricao"] = descricao;
  request.fields["classificar"] = _selectedValue;
  request.fields["utilizadorId"] = _userIdLogado;

  File file = File(mediaPath.toString());

  // Adiciona o arquivo à requisição
  request.files.add(
    await http.MultipartFile.fromPath("file", file.path, filename: "image.png"),
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
