import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/inicio.dart';    // class InicioScreen
import 'screens/registro.dart'; // class RegisterScreen

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
      home: const SignInScreen(), // Login como pantalla inicial
      routes: {
        '/inicio'  : (_) => const InicioScreen(),   // Navegar aquí al iniciar sesión
        '/register': (_) => const RegisterScreen(), // Navegar aquí al registrarse
      },
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
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPass  = prefs.getString('password');

    if (savedEmail == null || savedPass == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay usuario registrado. Regístrate primero.')),
      );
      return;
    }

    if (savedEmail == _email.text.trim() && savedPass == _pass.text) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/inicio'); // -> inicio.dart
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales inválidas')),
      );
    }
  }

  void _goToRegister() => Navigator.pushNamed(context, '/register'); // -> registro.dart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(), // icono de menú como en el mockup
      appBar: AppBar(centerTitle: true, title: const Text('Full Autos S.A')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Image.asset('assets/images/logo.png', height: 120, fit: BoxFit.contain),
              const SizedBox(height: 16),
              const Text('Bienvenido a la Serviteca',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('Todo para tu auto', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text('correo', style: Theme.of(context).textTheme.bodySmall),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                (v == null || v.isEmpty || !v.contains('@')) ? 'Ingresa un correo válido' : null,
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft,
                child: Text('Contraseña', style: Theme.of(context).textTheme.bodySmall),
              ),
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

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(onPressed: _login, child: const Text('Iniciar sesión')),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity, height: 48,
                child: OutlinedButton(onPressed: _goToRegister, child: const Text('Registrarse')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

