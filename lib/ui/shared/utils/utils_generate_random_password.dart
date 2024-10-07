import 'dart:math';

String generateRandomPassword() {
  String numbers = '0123456789';
  String capital = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String symbols = '_:{}|?!@#%^&*(),./<>';

  // Password length
  int passLength = 12;

  // Ensure the password contains at least one character from each category
  String password = '';
  Random random = Random();

  // Add one character from each category
  password += numbers[random.nextInt(numbers.length)];
  password += capital[random.nextInt(capital.length)];
  password += lower[random.nextInt(lower.length)];
  password += symbols[random.nextInt(symbols.length)];

  // Combine all characters into one list
  String seed = numbers + capital + lower + symbols;
  List<String> list = seed.split('').toList();

  // Fill the remaining length with random characters from the combined list
  for (int i = password.length; i < passLength; i++) {
    int index = random.nextInt(list.length);
    password += list[index];
  }

  // Shuffle the password to ensure randomness
  List<String> passwordChars = password.split('')..shuffle(random);
  password = passwordChars.join('');

  return password;
}
