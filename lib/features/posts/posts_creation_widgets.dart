import 'package:permission_handler/permission_handler.dart';

import '../../data/posts_data.dart';
import '../../repository/quotes_repository.dart';
import '../../services/quotes_service.dart';
import '../../utils/app_exports.dart';
import 'bloc/post_bloc.dart';
import 'dart:math';

class CreatePostWidget extends StatefulWidget {
  final User user;

  const CreatePostWidget({
    super.key,
    required this.user,
  });

  @override
  _CreatePostWidgetState createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  late final QuotesRepository quotesRepository;
  final TextEditingController _quoteController = TextEditingController();
  Color _selectedColor = Colors.blue;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.amber,
    Colors.pink,
    Colors.indigo,
    Colors.cyan,
    Colors.lime,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    quotesRepository = QuotesService();
    _shuffleQuotesAndColor();
  }

  Future<void> _shuffleQuotesAndColor() async {
    try {
      final result = await quotesRepository.fetchRandomQuotes();
      if (result.success) {
        setState(() {
          _selectedColor =
              _availableColors[Random().nextInt(_availableColors.length)];
          _quoteController.text = result.response!.data!['quote'];
        });
      }
    } catch (e) {
      debugPrint('Error fetching quote: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(StaticStrings.postSuccessfullyCreated)),
            );
            _quoteController.clear();
            _shuffleQuotesAndColor();
            NavigatorService.goBack();
          } else if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _quoteController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 16,
                      ),
                      hintText: StaticStrings.whatsOnYourMind,
                      hintStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey),
                      filled: true,
                      fillColor: _selectedColor.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    maxLines: 8,
                    maxLength: 200,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: BlocBuilder<PostBloc, PostState>(
                      builder: (context, state) {
                    return InkWell(
                      onTap: _createPost,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00C6FF),
                              Color(0xFF0072FF)
                            ], // Blue gradient
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: state is PostLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 1, color: AppColors.white),
                                )
                              : Text(
                                  StaticStrings.create,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        ),
                      ),
                    );
                  })),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _shuffleQuotesAndColor,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.3),
                      backgroundColor: _selectedColor,
                    ),
                    child: const Icon(
                      Icons.shuffle,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createPost() async {
    if (_quoteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StaticStrings.pleaseEnterAQuote)),
      );
      return;
    }

    Map<String, dynamic> locationData = await _getLocationData();
    if (!locationData['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StaticStrings.failedToFetchLocation)),
      );
    }

    final newPost = PostModel(
      id: '',
      quote: _quoteController.text.trim(),
      bgColorCode: '#${_selectedColor.value.toRadixString(16).substring(2)}',
      authorId: widget.user.uid,
      authorImage: widget.user.photoURL ?? '',
      createdAt: DateTime.now(),
      location: locationData['address'] ?? '',
      authorName: widget.user.displayName ?? '',
    );
    context.read<PostBloc>().add(CreatePostEvent(newPost));
  }

  Future<Map<String, dynamic>> _getLocationData() async {
    if (await _isLocationPermissionGranted(context)) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.medium));

        List<Placemark> addresses = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        String address = addresses.isNotEmpty
            ? "${addresses[0].locality}, ${addresses[0].postalCode}, ${addresses[0].administrativeArea}"
            : "Unknown location";

        return {'address': address, 'success': true};
      } catch (e) {
        return {'success': false, 'error': e.toString()};
      }
    } else {
      return {'success': false, 'error': ''};
    }
  }

  Future<bool> _isLocationPermissionGranted(BuildContext context) async {
    if (!await NetworkCheckerUtils.hasNetwork()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StaticStrings.noInternet)),
      );
      return false;
    }

    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StaticStrings.giveAccessFromSettings)),
      );

      Future.delayed(const Duration(seconds: 2), () async {
        await openAppSettings();
      });
    }

    return false;
  }

  @override
  void dispose() {
    _quoteController.dispose();
    super.dispose();
  }
}
