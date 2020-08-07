class FirestorePath {
  static String userData(String uid) => 'users/$uid';
  static String addPopToBusiness(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId';
  static String popClicks(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId/clicks';
  static String businessPops(String businessUserId) => 'businesses/$businessUserId/pops';
  static String specificBusinessPop(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId';
  static String specificPop(String popId) => 'pops/$popId';
  static String pops() => 'pops';
  static String addPopClick(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId/clicks';
  static String addPopLike(String popId) => 'pops/$popId/likes';
  static String addPopLikeToBusinessAnalytics(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId/likes';
  static String addCouponRedeemed(String popId) => 'pops/$popId/couponsRedeemed';
  static String addCouponRedeemedToBusinessAnalytics(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId/couponsRedeemed';
  static String popLikeCount(String popId) => 'pops/$popId/likes/likeCount';
  static String popCouponsRedeemedCount(String popId) => 'pops/$popId/couponsRedeemed/couponsRedeemedCount';
  static String businessPopCouponsRedeemedCount(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId/couponsRedeemedCount/count';
  static String businessPopLikeCount(String businessUserId, String popId) => 'businesses/$businessUserId/pops/$popId/likes/likeCount';
  static String businessPopImages(String businessUserId, String imageName) => 'businesses/$businessUserId/$imageName';
}