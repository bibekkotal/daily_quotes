import '../repository/quotes_repository.dart';
import '../utils/api_request.dart';
import 'base.dart';

class QuotesService extends QuotesRepository {
  @override
  Future<ApiResult> fetchRandomQuotes() async {
    return await ApiRequest().request(
      headers: {
        "Content-Type": "application/json",
      },
      method: ApiMethods.get,
      endpoint: API.getRandomQuote,
    );
  }
}
