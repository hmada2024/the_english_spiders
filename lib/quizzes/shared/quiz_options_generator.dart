// quizzes_section/shared_quizzes/helpers/quiz_options_generator.dart
import 'dart:math';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_event.dart';

class QuizOptionsGenerator {
  static List<dynamic> generateOptions<T>({
    required T correctAnswer,
    required List<T> allItems,
    required QuizType quizType,
    required dynamic Function(T) valueGetter,
    int numberOfOptions = 4,
  }) {
    final List<dynamic> options = [];

    options.add(quizType == QuizType.imageBased ? correctAnswer : valueGetter(correctAnswer));

    final otherItems = allItems.where((item) => item != correctAnswer).toList()..shuffle();
    int count = 0;

    for (var item in otherItems) {
      if (count < numberOfOptions - 1) {
        options.add(quizType == QuizType.imageBased ? item : valueGetter(item));
        count++;
      } else {
        break;
      }
    }
    while (options.length < numberOfOptions && allItems.isNotEmpty)
      {
          try{
               final randomItem = allItems[Random().nextInt(allItems.length)];
                if (!options.contains(quizType == QuizType.imageBased
                    ? randomItem
                    : valueGetter(randomItem)))
                {
                    options
                        .add(quizType == QuizType.imageBased ? randomItem : valueGetter(randomItem));
                }

          }catch(e){
            break;
          }
      }

    return options..shuffle();
  }
}