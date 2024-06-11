import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthState extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void signUp() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logIn() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logOut() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthState _state;
  late final GoRouter _router;

  List<String> routes = ["/auth/signup", "/auth/login"];

  @override
  void initState() {
    super.initState();

    _state = AuthState();

    _router = GoRouter(
      refreshListenable: _state,
      redirect: (context, state) {
        final status = _state.isAuthenticated;

        final loggedIn = status;

        final logging = routes.contains(state.matchedLocation);

        if (!loggedIn && !logging) return "/auth/login";

        if (loggedIn && logging) return "/";

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => MyHomePage(
            state: _state,
          ),
        ),
        GoRoute(
          path: '/auth/signup',
          builder: (context, state) => MySignupPage(
            state: _state,
          ),
        ),
        GoRoute(
          path: '/auth/login',
          builder: (context, state) => MyLoginPage(
            state: _state,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _router.dispose();
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Go Router Location Empty Exception Reproduction',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatelessWidget {
  final AuthState state;

  const MyHomePage({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            state.logOut();
          },
          child: const Text('Log out'),
        ),
      ),
    );
  }
}

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({
    super.key,
    required this.state,
  });

  final AuthState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                state.logIn();
              },
              child: const Text('Log In'),
            ),
            ElevatedButton(
              onPressed: () {
                context.replace('/auth/signup');
              },
              child: const Text('Go to Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class MySignupPage extends StatelessWidget {
  const MySignupPage({
    super.key,
    required this.state,
  });

  final AuthState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                state.signUp();
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                context.replace('/auth/login');
              },
              child: const Text('Go to Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
