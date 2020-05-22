class FirestorePath {
  static String userData(String uid) => 'users/$uid';
  static String addPopToBusiness(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId';
  static String pops() => 'pops';
  static String addPopClick(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId/clicks';

}