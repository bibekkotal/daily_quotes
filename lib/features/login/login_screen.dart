import './bloc/auth_bloc.dart';

import '../../utils/app_exports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: AppColors.white,
    ));

    Size mediaSize = MediaQuery.sizeOf(context);

    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              if (state.user.email != null && state.user.email != '') {
                NavigatorService.pushNamedAndRemoveUntil(RouteNames.home);
              }
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.splashImage,
                          height: mediaSize.height / 5,
                        ),
                        SizedBox(height: mediaSize.height / 15),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return CustomOutlinedButton(
                              onPressed: () {
                                _loginWithGoogle(context);
                              },
                              text: StaticStrings.loginWithGoogle,
                              iconUrl: AppImages.googleLogo,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Or'),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _emailController,
                          hintText: StaticStrings.email,
                          prefixIcon: Icons.email,
                          validator: validateEmail,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: StaticStrings.password,
                          prefixIcon: Icons.lock,
                          isObscure: true,
                          validator: validatePassword,
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return AppButton(
                              onPressed: () {
                                _loginWithEmail(context);
                              },
                              text: StaticStrings.login,
                              isLoading: state is AuthLoading,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginWithEmail(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(LoginWithEmailEvent(
          _emailController.text.trim(), _passwordController.text.trim()));
    }
  }

  void _loginWithGoogle(BuildContext context) {
    context.read<AuthBloc>().add(LoginWithGoogleEvent());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
