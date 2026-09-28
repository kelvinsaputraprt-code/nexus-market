class AccountStore {
  static String username = 'admin';
  static String email = 'admin@nexus.com';
  static String password = '12345';

  static bool hasAccount = true;

  static void createAccount({
    required String newUsername,
    required String newEmail,
    required String newPassword,
  }) {
    username = newUsername;
    email = newEmail;
    password = newPassword;
    hasAccount = true;
  }

  static bool login({
    required String input,
    required String inputPassword,
  }) {
    return hasAccount &&
        (input == username || input == email) &&
        inputPassword == password;
  }

  static bool checkAccount(String input) {
    return hasAccount &&
        (input == username || input == email);
  }

  static void changePassword(String newPassword) {
    password = newPassword;
  }
}