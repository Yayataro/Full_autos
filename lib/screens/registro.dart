import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const FullAutosApp());

class FullAutosApp extends StatelessWidget {
  const FullAutosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Full Autos SAS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFE6E6E6),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.black),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        outlinedButtonTheme: const OutlinedButtonThemeData(
          style: ButtonStyle(
            side: WidgetStatePropertyAll(BorderSide(color: Colors.black, width: 2)),
            backgroundColor: WidgetStatePropertyAll(Colors.black),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      home: const SignInScreen(),
    );
  }
}

// ----------------- LOGIN -----------------
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() { _email.dispose(); _pass.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPass  = prefs.getString('password');

    if (savedEmail == _email.text.trim() && savedPass == _pass.text) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales inválidas o usuario no registrado')),
      );
    }
  }

  void _goToRegister() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(centerTitle: true, title: const Text('Full Autos S.A')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', height: 140, fit: BoxFit.contain),
              const SizedBox(height: 12),
              const Text('Bienvenido a la Serviteca',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('Todo para tu auto', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),

              Align(alignment: Alignment.centerLeft,
                  child: Text('correo', style: Theme.of(context).textTheme.bodySmall)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                (v == null || v.isEmpty || !v.contains('@')) ? 'Ingresa un correo válido' : null,
              ),
              const SizedBox(height: 16),

              Align(alignment: Alignment.centerLeft,
                  child: Text('Contraseña', style: Theme.of(context).textTheme.bodySmall)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _pass,
                obscureText: _obscure,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
              ),

              const SizedBox(height: 28),

              // Iniciar sesión
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('Iniciar sesión'),
                ),
              ),
              const SizedBox(height: 12),

              // Ir a registro
              SizedBox(
                width: double.infinity, height: 48,
                child: OutlinedButton(
                  onPressed: _goToRegister,
                  child: const Text('Registrarse'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------- REGISTRO -----------------
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  final _pass2 = TextEditingController();
  bool _hide1 = true, _hide2 = true;

  @override
  void dispose() { _email.dispose(); _pass.dispose(); _pass2.dispose(); super.dispose(); }

  InputDecoration _filled(String label) => const InputDecoration(
    filled: true,
    fillColor: Color(0xFFE6E6E6),
    border: OutlineInputBorder(borderSide: BorderSide.none),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  ).copyWith(labelText: label);

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _email.text.trim());
    await prefs.setString('password', _pass.text);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cuenta creada (local)')));
    Navigator.pop(context); // volver al login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Registro')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _filled('Correo'),
                        validator: (v) => (v == null || v.isEmpty || !v.contains('@'))
                            ? 'Correo inválido' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _pass,
                        obscureText: _hide1,
                        decoration: _filled('Contraseña (mín. 6)').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_hide1 ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _hide1 = !_hide1),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6) ? 'Muy corta' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _pass2,
                        obscureText: _hide2,
                        decoration: _filled('Repetir contraseña').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_hide2 ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _hide2 = !_hide2),
                          ),
                        ),
                        validator: (v) => (v != _pass.text) ? 'No coincide' : null,
                      ),

                      const Spacer(),
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _register,
                          child: const Text('Crear cuenta'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ----------------- HOME (placeholder) -----------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Autos SAS')),
      body: const Center(child: Text('Home (placeholder)')),
    );
  }
}
