part of 'insta_face_bloc.dart';

abstract class BlocEvent extends Equatable {
  const BlocEvent();

  @override
  List<Object> get props => [];
}

class GetFeedList extends BlocEvent {}

class GetStoryList extends BlocEvent {}