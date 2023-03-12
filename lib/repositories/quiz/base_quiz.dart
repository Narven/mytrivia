import 'package:mytrivia/enums/difficulty.dart';
import 'package:mytrivia/models/question_model.dart';

abstract class BaseQuizRepository {
  Future<List<Question>> getQuestions({
    required int numQuestions,
    required int categoryId,
    required Difficulty difficulty,
  });
}
