part of 'insta_face_bloc.dart';

abstract class BlocState extends Equatable {
  const BlocState();

  @override
  List<Object?> get props => [];
}

class ListInitial extends BlocState {}

class ListLoading extends BlocState {}

class FeedLoaded extends BlocState {
  final List<FeedItemModel> feedItemModel;
  const FeedLoaded(this.feedItemModel);
}

class StoryLoaded extends BlocState {
  final List<StoryItemModel> storyLoaded;
  const StoryLoaded(this.storyLoaded);
}

class BlocError extends BlocState {
  final String? message;
  const BlocError(this.message);
}