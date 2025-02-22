import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shatter_vcs/model/question_model.dart';
import 'package:shatter_vcs/services/search_service.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>((event, emit) async {
      emit(SearchLoading());
      try {
        final query = event.query; 
        final results = await SearchService().searchQuestions(query); 
        emit(SearchSuccess(results));
      }catch(err){
        print(err);
        emit(SearchFailure("Error searching questions"));
      }
    });

    on<SearchSubmitted>((event, emit) async {
      emit(SearchLoading());
      try {
        final query = event.query; 
        final results = await SearchService().searchQuestions(query); 
        emit(SearchSuccess(results));
      }catch(err){
        print(err);
        emit(SearchFailure("Error searching questions"));
      }
    });
  }
}
