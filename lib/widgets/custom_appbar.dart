import '../utils/app_exports.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? imageUrl;
  final String displayName;
  final VoidCallback onLogout;

  const CustomAppBar({
    super.key,
    required this.imageUrl,
    required this.displayName,
    required this.onLogout,
  });

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return StaticStrings.goodMorning;
    } else if (hour < 17) {
      return StaticStrings.goodAfternoon;
    } else {
      return StaticStrings.goodEvening;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: imageUrl != null && imageUrl != ''
                ? NetworkImage(imageUrl!)
                : const AssetImage(AppImages.userPlaceHolder) as ImageProvider,
          ),
          const SizedBox(width: 10),
          Text(
            '${getGreeting()},\n$displayName',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: AppColors.red),
          onPressed: onLogout,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
