import 'package:equatable/equatable.dart';
import 'package:mytrivia/models/question_model.dart';

enum QuizStatus { initial, correct, incorrect, complete }

class QuizState extends Equatable {
  final QuizStatus status;
  final String selectedAnswer;
  final List<Question> incorrect;
  final List<Question> correct;

  @override
  List<Object?> get props => [
        selectedAnswer,
        correct,
        incorrect,
        status,
      ];

  bool get answered =>
      status == QuizStatus.incorrect || status == QuizStatus.correct;

  const QuizState({
    required this.selectedAnswer,
    required this.correct,
    required this.incorrect,
    required this.status,
  });

  factory QuizState.initial() {
    return const QuizState(
      selectedAnswer: '',
      correct: [],
      incorrect: [],
      status: QuizStatus.initial,
    );
  }

  QuizState copyWith({
    QuizStatus? status,
    String? selectedAnswer,
    List<Question>? incorrect,
    List<Question>? correct,
  }) {
    return QuizState(
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
      status: status ?? this.status,
    );
  }
}
