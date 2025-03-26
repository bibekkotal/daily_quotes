import '../utils/api_request.dart';

abstract class QuotesRepository {
  Future<ApiResult> fetchRandomQuotes();
}
