import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socmed/data/data_provider/model/FeedItemModel.dart';
import 'package:socmed/data/data_provider/model/StoryItemModel.dart';
import 'package:socmed/data/repository/sql_helper.dart';

part 'bloc_event.dart';
part 'bloc_state.dart';

class InstaFaceBloc extends Bloc<BlocEvent, BlocState> {
  InstaFaceBloc() : super(ListInitial()) {
    final SQLHelper repository = SQLHelper();

    on<GetFeedList>((event, emit) async {
      final data = await repository.getFeedItems();
      emit(FeedLoaded(data));
      if (data.isEmpty) {
        emit(const BlocError('Empty List'));
      }
    });

    on<GetStoryList>((event, emit) async {
      final data = await repository.getStoryItems();
      emit(StoryLoaded(data));
      if (data.isEmpty) {
        emit(const BlocError('Empty List'));
      }
    });

    on<AddFeedEvent>((event, emit) async {
      print('_printEventHere ${event.feedItemModel?.description}');


    });

  }
}