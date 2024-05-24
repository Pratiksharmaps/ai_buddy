import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatAi extends StatefulWidget {
  const ChatAi({super.key});

  @override
  State<ChatAi> createState() => _ChatAiState();
}

class _ChatAiState extends State<ChatAi> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentuser = ChatUser(
    id: '0',
    firstName: 'User',
    lastName: 'user',
  );
  ChatUser geminiUser = ChatUser(
      id: '1',
      firstName: "Ai_Buddy",
      profileImage:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxA1Kxym72kpoTswuAAKOfZIAxFY8N5WsagXLcEO-Gqw&s');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Ai_Buddy"),
        ),
        body: _buildUi());
  }

  Widget _buildUi() {
    return DashChat(
        inputOptions: InputOptions(trailing: [
          IconButton(
            onPressed: _sendMediamessage,
            icon: const Icon(Icons.image),
          ),
          IconButton(
            onPressed: _sendMediamessagecamera,
            icon: const Icon(Icons.camera),
          )
        ]),
        currentUser: currentuser,
        onSend: _sendMessage,
        messages: messages);
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      String question = chatMessage.text;
      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastmessage = messages.firstOrNull;
        if (lastmessage != null && lastmessage.user == geminiUser) {
          lastmessage = messages.removeAt(0);
          String response = event.content!.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              " ";
          lastmessage.text += response;
          setState(() {
            messages = [lastmessage!, ...messages];
          });
        } else {
          String response = event.content!.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              " ";
          ChatMessage meassage = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [meassage, ...messages];
          });
        }
      });
    } catch (e) {
      SnackBar(content: Text(e.toString()));
    }
  }

 void _sendMediamessage() async {
    
      ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        ChatMessage message = ChatMessage(
            user: currentuser,
            createdAt: DateTime.now(),
            text: "Describe this picture",
            medias: [
              ChatMedia(url: image.path, fileName: " ", type: MediaType.image)
            ]);

        _sendMessage(message);
     
      }
    }
  
  void _sendMediamessagecamera() async{
    ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        ChatMessage message = ChatMessage(
            user: currentuser,
            createdAt: DateTime.now(),
            text: "Describe this picture",
            medias: [
              ChatMedia(url: image.path, fileName: " ", type: MediaType.image)
            ]);

        _sendMessage(message);
     
      }
  }
  }