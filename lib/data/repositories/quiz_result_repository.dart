class QuizResultModel {
  final String quizType;
  final List<SubQuizResult> subQuizzes;
  final int? userId;

  QuizResultModel({
    required this.quizType,
    required this.subQuizzes,
    this.userId,
  });

   Map<String, dynamic> toMap() {
    return {
      'quizType': quizType,
      'userId': userId
    };
  }
    factory QuizResultModel.fromMap(Map<String, dynamic> map) {
    return QuizResultModel(
      quizType: map['quizType'],
      userId: map['userId'],
      subQuizzes: []
    );
  }

  // Add copyWith method here:
  QuizResultModel copyWith({
    String? quizType,
    List<SubQuizResult>? subQuizzes,
    int? userId,
  }) {
    return QuizResultModel(
      quizType: quizType ?? this.quizType,
      subQuizzes: subQuizzes ?? this.subQuizzes,
      userId: userId ?? this.userId,
    );
  }
}

class SubQuizResult {
  final String quizSubType;
  final int score;
  final int totalQuestions;
  final int correctAnswers;

  SubQuizResult({
    required this.quizSubType,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
  });
  Map<String, dynamic> toMap() {
    return {
      'quizSubType': quizSubType,
      'score':score,
      'totalQuestions':totalQuestions,
      'correctAnswers': correctAnswers
    };
  }

    factory SubQuizResult.fromMap(Map<String, dynamic> map) {
    return SubQuizResult(
      quizSubType: map['quizSubType'],
      score:  map['score'],
      totalQuestions: map['totalQuestions'],
      correctAnswers:  map['correctAnswers']
    );
  }
}