import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';


void main() {
  runApp(MyApp());
}

// La App es un StatefulWidget. Nos permite actualizar el estado del Widget
// cada vez que se elimine un elemento.
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }


}


class MyAppState extends State<MyApp> {
  final items = List<String>.generate(3, (i) => "Item ${i + 1}");
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying= false;

  void _reproducir() async{
    final AudioCache pl = AudioCache();

    int result = 0;
    if (isPlaying==false) {
      result = await _audioPlayer.play(await pl.getAbsoluteUrl('piano-loop.mp3'), isLocal: true);
      //Verifico el resultado de play y cambio el estado
      if(result==1){
        setState(() => isPlaying = true);
      }
    }
    else {
      _audioPlayer.pause();
      setState(() => isPlaying = false);
    }



  }
  @override
  Widget build(BuildContext context) {
    final title = 'Eliminar elementos';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Dismissible(
              // Cada Dismissible debe contener una llave. Las llaves permiten a Flutter
              // identificar de manera única los Widgets.
              key: Key(item),
              // También debemos proporcionar una función que diga a nuestra aplicación
              // qué hacer después de que un elemento ha sido eliminado.
              onDismissed: (direction) {

                // Remueve el elemento de nuestro data source.
                setState(() {
                  items.removeAt(index);
                });

                // Luego muestra un snackbar!
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$item eliminado")));
              },
              // Muestra un background rojo a medida que el elemento se elimina
              background: Container(color: Colors.red),
              child: ListTile(title: Text('$item'), onTap: _reproducir),
            );
          },
        ),
      ),
    );
  }
}