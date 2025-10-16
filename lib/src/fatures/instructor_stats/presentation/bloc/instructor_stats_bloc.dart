import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'instructor_stats_event.dart';
part 'instructor_stats_state.dart';

class InstructorStatsBloc extends Bloc<InstructorStatsEvent, InstructorStatsState> {
  InstructorStatsBloc() : super(InstructorStatsInitial()) {
    on<InstructorStatsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
