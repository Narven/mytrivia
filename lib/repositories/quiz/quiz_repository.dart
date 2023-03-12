import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mytrivia/enums/difficulty.dart';
import 'package:mytrivia/models/failure_model.dart';
import 'package:mytrivia/models/question_model.dart';
import 'package:mytrivia/repositories/quiz/base_quiz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider<Dio>(
  (ref) => Dio(),
);

final quizRepositoryProvider =
    Provider<QuizRepository>((ref) => QuizRepository(Dio()));

class QuizRepository extends BaseQuizRepository {
  final Dio _dio;

  QuizRepository(this._dio);

  @override
  Future<List<Question>> getQuestions({
    required int numQuestions,
    required int categoryId,
    required Difficulty difficulty,
  }) async {
    try {
      print('QUESTIONS');
      final queryParameters = {
        'type': 'multiple',
        'amount': numQuestions,
        'category': categoryId,
      };

      if (difficulty != Difficulty.any) {
        queryParameters.addAll(
          {'difficulty': EnumToString.convertToString(difficulty)},
        );
      }

      final response = await _dio.get(
        'https://opentdb.com/api.php',
        queryParameters: queryParameters,
      );

      final data = Map<String, dynamic>.from(response.data);
      final results = List<Map<String, dynamic>>.from(data['results'] ?? []);

      if (results.isEmpty) return [];

      return results.map((e) => Question.fromMap(e)).toList();
    } on DioError catch (err) {
      print(err);
      throw Failure(message: err.response?.statusMessage ?? '');
    } on SocketException catch (err) {
      print(err);
      throw Failure(message: 'Please check your connection: $err');
    } catch (err) {
      print(err);
      throw Failure(message: 'Something went wrong: $err');
    }
  }
}
