class FirestorePath {
  static String userData(String uid) => 'users/$uid';
  static String addPopToBusiness(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId';
  static String popClicks(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId/clicks';
  static String businessPops(String businessUserId) => 'businesses/$businessUserId/pops';
  static String pops() => 'pops';
  static String addPopClick(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId/clicks';

}