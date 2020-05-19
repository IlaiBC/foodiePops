class FirestorePath {
  static String userData(String uid) => 'users/$uid';
  static String addPop(String businessUserId) => 'businesses/$businessUserId/pops';
  static String addPopClick(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId/clicks';

}