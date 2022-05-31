import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socmed/bloc/insta_face_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socmed/data/data_provider/model/FeedItemModel.dart';
import 'package:socmed/presentation/widgets/FeedListViewWidget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomeScreen> {
  final InstaFaceBloc instaFaceBloc = InstaFaceBloc();
  TextEditingController titleController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  @override
  void initState() {
    instaFaceBloc.add(GetFeedList());
    instaFaceBloc.add(GetStoryList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _postSomething();
                },
                child: const Icon(
                  Icons.add_sharp,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      body: _buildWidget(),
    );
  }

  Widget _buildWidget(){
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: BlocProvider(
        create: (_) => instaFaceBloc,
        child: BlocListener<InstaFaceBloc, BlocState>(
          listener: (context, state) {
            if (state is BlocError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            }
          },
          child: BlocBuilder<InstaFaceBloc, BlocState>(
            builder: (context, state) {
              if (state is ListInitial) {
                return _buildLoading();
              } else if (state is ListLoading) {
                return _buildLoading();
              } else if (state is FeedLoaded) {
                return const FeedListViewWidget();
              } else if (state is BlocError) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  _postSomething(){
    showDialog(context: context, builder: (BuildContext context) {
      Color? selectedColor;
      return AlertDialog(
        title: const Text("What's on your mind?"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: captionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Caption',
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Post it'),
            onPressed: () {
              instaFaceBloc.add(AddFeedEvent(FeedItemModel(id: 1, title: titleController.text, description: captionController.text)));
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  _getAspectRatios() {
    return Platform.isAndroid
        ? [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ]
        : [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio5x3,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9
    ];
  }

  _getAndroidUISettings() {
    return AndroidUiSettings(
      toolbarTitle: 'Cropper',
      toolbarColor: Color(0xFF1D76BB),
      toolbarWidgetColor: Colors.white,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: false,
    );
  }


  _imgFromGallery(context) async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(context, pickedFile!.path);
  }

  Future<Null> _cropImage(context, String path) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: _getAspectRatios(),
      uiSettings: [
        _getAndroidUISettings(),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
  }
}

