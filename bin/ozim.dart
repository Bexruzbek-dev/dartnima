import 'dart:io';

void main() {
  print("Enter your expression:");
  String userInput = stdin.readLineSync()!;

  double result = calculate(userInput);
  print("The result is: $result");
}

// maindan chaqiriladigan hisoblash
double calculate(String expression) {
  expression = expression.replaceAll('x', '*').replaceAll(':', '/');

  List<String> qiymatlar = bittalabajrat(expression);

  return ajratish(qiymatlar);
}



// arifmetik amalikka tekshiradi
bool isOperator(String char) {
  return char == '+' || char == '-' || char == '*' || char == '/';
}



// listga son va belgilarni haqiqiydek
List<String> bittalabajrat(String expression) {
  List<String> tokens = [];
  String holder = ''; // raqam ushlab tur

  for (int i = 0; i < expression.length; i++) {
    String char = expression[i];

    if (isOperator(char) || char == '(' || char == ')') {
      if (holder.isNotEmpty) {
        tokens.add(holder);
        holder = '';
      }
      tokens.add(char);
    } else {
      holder += char;
    }
  }

  if (holder.isNotEmpty) {
    tokens.add(holder);
  }

  return tokens;
}

// raqamlarga va belgilarga
double ajratish(List<String> qiymatlar) {
  print(qiymatlar);
  List<double> numbers = [];
  List<String> operators = [];


  for (int i = 0; i < qiymatlar.length; i++) {
    String belgi = qiymatlar[i];

    if (double.tryParse(belgi) != null) {
      numbers.add(double.parse(belgi));
    } else if (belgi == '+' || belgi == '-' || belgi == '*' || belgi == '/') {
      operators.add(belgi);
    } else if (belgi == '(') {
      int j = i + 1;
      int ochiqQavs = 1;
      List<String> subExpression = [];

      while (ochiqQavs > 0) {
        if (qiymatlar[j] == '(') ochiqQavs++;
        if (qiymatlar[j] == ')') ochiqQavs--;
        if (ochiqQavs > 0) subExpression.add(qiymatlar[j]);
        j++;
      }
      print(subExpression);
      numbers.add(ajratish(subExpression));
      i = j - 1;
    }
  }

  for (int i = 0; i < operators.length; i++) {
    if (operators[i] == '*' || operators[i] == '/') {
      double result =
          performOperation(numbers[i], numbers[i + 1], operators[i]);
      numbers[i] = result;
      numbers.removeAt(i + 1);
      operators.removeAt(i);
      i--;
    }
  }

  for (int i = 0; i < operators.length; i++) {
    double result = performOperation(numbers[i], numbers[i + 1], operators[i]);
    numbers[i] = result;
    numbers.removeAt(i + 1);
    operators.removeAt(i);
    i--;
  }

  return numbers[0];
}

// 4 ta amal uchun
double performOperation(double a, double b, String op) {
  switch (op) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '*':
      return a * b;
    case '/':
      return a / b;
    default:
      throw Exception("Invalid operator");
  }
}
