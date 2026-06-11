import 'package:dio/dio.dart';
import 'api_service.dart';

class TraderService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getHome() async {
    try {
      final response = await _api.get('/api/trader/home');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getCurrentShipment() async {
    try {
      final response = await _api.get('/api/trader/mobile/home-current-shipment');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getShipments() async {
    try {
      final response = await _api.get('/api/trader/shipments');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getShipmentDetails({required String shipmentId}) async {
    try {
      final response = await _api.get('/api/trader/mobile/shipments/$shipmentId/details');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getShipmentOffers({
    required String shipmentId, String tab = 'pending',
    int page = 1, int pageSize = 10,
  }) async {
    try {
      final response = await _api.get(
        '/api/trader/mobile/shipments/$shipmentId/offers',
        queryParams: {'tab': tab, 'page': page, 'pageSize': pageSize},
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> confirmShipment({required String shipmentId}) async {
    try {
      final response = await _api.put('/api/shipment/$shipmentId/confirm');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> cancelShipment({required String shipmentId}) async {
    try {
      final response = await _api.post('/api/trader/shipments/$shipmentId/cancel');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> markDelivered({required String shipmentId}) async {
    try {
      final response = await _api.post('/api/trader/shipments/$shipmentId/mark-delivered');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> trackShipment({required String shipmentId}) async {
    try {
      final response = await _api.get('/api/trader/shipments/$shipmentId/tracking');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getDeliverySummary({required String shipmentId}) async {
    try {
      final response = await _api.get('/api/trader/shipments/$shipmentId/delivery-summary');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> estimateShipment(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/api/shipment/estimate', data: data);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> acceptOffer({required String offerId}) async {
    try {
      final response = await _api.post('/api/trader/mobile/offers/$offerId/accept');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> rejectOffer({required String offerId}) async {
    try {
      final response = await _api.post('/api/trader/mobile/offers/$offerId/reject');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getSuggestedDrivers({required String shipmentId}) async {
    try {
      final response = await _api.get('/api/trader/shipments/$shipmentId/suggested-drivers');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getDriverDetails({required String driverId}) async {
    try {
      final response = await _api.get('/api/trader/drivers/$driverId/details');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> selectDriver({
    required String shipmentId, required String driverId,
  }) async {
    try {
      final response = await _api.post(
        '/api/trader/shipments/$shipmentId/select-driver',
        data: {'driverId': driverId},
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> rateDriver({
    required String shipmentId, required int rating, String? comment,
  }) async {
    try {
      final response = await _api.post(
        '/api/trader/shipments/$shipmentId/rate-driver',
        data: {'rating': rating, if (comment != null) 'comment': comment},
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getWallet() async {
    try {
      final response = await _api.get('/api/trader/wallet');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> addCard(Map<String, dynamic> cardData) async {
    try {
      final response = await _api.post('/api/trader/wallet/cards', data: cardData);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> deleteCard({required String cardId}) async {
    try {
      final response = await _api.delete('/api/trader/wallet/cards/$cardId');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> setDefaultCard({required String cardId}) async {
    try {
      final response = await _api.patch('/api/trader/wallet/cards/$cardId/set-default');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getInvoice({required String invoiceId}) async {
    try {
      final response = await _api.get('/api/trader/invoices/$invoiceId');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> payInvoice({required String invoiceId}) async {
    try {
      final response = await _api.post('/api/trader/invoices/$invoiceId/pay');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _api.get('/api/trader/settings/profile');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword, required String newPassword,
  }) async {
    try {
      final response = await _api.patch('/api/trader/settings/change-password',
          data: {'oldPassword': oldPassword, 'newPassword': newPassword});
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      final response = await _api.get('/api/trader/settings/notifications');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> updateNotificationSettings(Map<String, dynamic> settings) async {
    try {
      final response = await _api.patch('/api/trader/settings/notifications', data: settings);
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final response = await _api.delete('/api/trader/settings/account');
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _handleError(e)};
    }
  }

  // ✅ بيعرض رسالة الباك الحقيقية بالظبط
  String _handleError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        if (data['message'] != null) return data['message'].toString();
        if (data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map) return errors.values.first.toString();
          if (errors is List) return errors.first.toString();
        }
        if (data['title'] != null) return data['title'].toString();
      }
      if (data is String && data.isNotEmpty) return data;
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet.';
    }
    if (e.type == DioExceptionType.unknown) return 'No internet connection.';
    return 'Something went wrong. Please try again.';
  }
}