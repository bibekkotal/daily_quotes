import '../../data/posts_data.dart';
import '../../utils/app_exports.dart';
import 'bloc/post_bloc.dart';
import 'dart:math';

class CreatePostWidget extends StatefulWidget {
  final User user;
  const CreatePostWidget({super.key, required this.user});

  @override
  _CreatePostWidgetState createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
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
  ];

  @override
  void initState() {
    super.initState();
    _shuffleColor();
  }

  void _shuffleColor() async {
    setState(() {
      _selectedColor =
          _availableColors[Random().nextInt(_availableColors.length)];
      // _quoteController.text = dailyQuote.quote;
    });
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
          } else if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _quoteController,
                        decoration: InputDecoration(
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 15,
                        maxLength: 250,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        StaticStrings.create,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _shuffleColor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                    ),
                    child: const Icon(Icons.shuffle, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createPost() {
    if (_quoteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StaticStrings.pleaseEnterAQuote)),
      );
      return;
    }

    final newPost = PostModel(
      id: '',
      quote: _quoteController.text.trim(),
      bgColorCode: '#${_selectedColor.value.toRadixString(16).substring(2)}',
      authorId: widget.user.uid,
      authorImage: widget.user.photoURL ?? '',
      createdAt: DateTime.now(),
      location: '',
    );

    context.read<PostBloc>().add(CreatePostEvent(newPost));
  }

  @override
  void dispose() {
    _quoteController.dispose();
    super.dispose();
  }
}
