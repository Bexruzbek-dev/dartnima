import 'dart:io';

void main() {
  print("Enter your expression:");
  String userInput = stdin.readLineSync()!;

  double result = calculate(userInput);
  print("The result is: $result");
}

double calculate(String expression) {

  expression = expression.replaceAll('x', '*').replaceAll(':', '/');

  // Function to perform operation
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


  double evaluate(List<String> tokens) {
    List<double> numbers = [];
    List<String> operators = [];

    for (int i = 0; i < tokens.length; i++) {
      String token = tokens[i];

      if (double.tryParse(token) != null) {
        numbers.add(double.parse(token));
      } else if (token == '+' || token == '-' || token == '*' || token == '/') {
        operators.add(token);
      } else if (token == '(') {

        int j = i + 1;
        int openParentheses = 1;
        List<String> subExpression = [];

        while (openParentheses > 0) {
          if (tokens[j] == '(') openParentheses++;
          if (tokens[j] == ')') openParentheses--;
          if (openParentheses > 0) subExpression.add(tokens[j]);
          j++;
        }

        numbers.add(evaluate(subExpression));
        i = j - 1; 
      }
    }

    // First process multiplication and division
    for (int i = 0; i < operators.length; i++) {
      if (operators[i] == '*' || operators[i] == '/') {
        double result = performOperation(numbers[i], numbers[i + 1], operators[i]);
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


  List<String> tokens = expression.split(RegExp(r'(?<=[-+*/()])|(?=[-+*/()])'));
  return evaluate(tokens);
}
