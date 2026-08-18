import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
final _formKey = GlobalKey<FormState>();

final _emailController =
TextEditingController();

final _passwordController =
TextEditingController();

bool _loading = false;
bool _obscurePassword = true;

@override
void dispose() {
_emailController.dispose();
_passwordController.dispose();
super.dispose();
}

Future<void> _login() async {
if (!_formKey.currentState!.validate()) {
return;
}

setState(() {
_loading = true;
});

try {
await AuthService.instance.signIn(
email: _emailController.text.trim(),
password: _passwordController.text.trim(),
);
} on Exception catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
e.toString(),
),
),
);
}

if (mounted) {
setState(() {
_loading = false;
});
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding:
const EdgeInsets.all(24),
child: Form(
key: _formKey,
child: Column(
children: [
Container(
width: 90,
height: 90,
decoration: BoxDecoration(
color: Theme.of(context)
.colorScheme
.primary,
borderRadius:
BorderRadius.circular(24),
),
child: const Icon(
Icons.account_balance_wallet,
color: Colors.white,
size: 46,
),
),

const SizedBox(height: 24),

const Text(
"Welcome Back",
style: TextStyle(
fontSize: 30,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

Text(
"Sign in to continue using Splitly",
style: TextStyle(
color: Colors.grey.shade600,
),
),

const SizedBox(height: 40),

TextFormField(
controller: _emailController,
keyboardType:
TextInputType.emailAddress,
decoration: const InputDecoration(
labelText: "Email",
prefixIcon:
Icon(Icons.email_outlined),
border: OutlineInputBorder(),
),
validator: (value) {
if (value == null ||
value.trim().isEmpty) {
return "Please enter your email";
}

if (!value.contains("@")) {
return "Enter a valid email";
}

return null;
},
),

const SizedBox(height: 18),

TextFormField(
controller:
_passwordController,
obscureText:
_obscurePassword,
decoration: InputDecoration(
labelText: "Password",
prefixIcon:
const Icon(Icons.lock_outline),
border:
const OutlineInputBorder(),
suffixIcon: IconButton(
icon: Icon(
_obscurePassword
? Icons.visibility
: Icons.visibility_off,
),
onPressed: () {
setState(() {
_obscurePassword =
!_obscurePassword;
});
},
),
),
validator: (value) {
if (value == null ||
value.length < 6) {
return "Minimum 6 characters";
}

return null;
},
),

const SizedBox(height: 28),

SizedBox(
width: double.infinity,
height: 54,
child: FilledButton(
onPressed:
_loading ? null : _login,
child: _loading
? const SizedBox(
width: 22,
height: 22,
child:
CircularProgressIndicator(
strokeWidth: 2.5,
color: Colors.white,
),
)
: const Text(
"Sign In",
),
),
),

const SizedBox(height: 18),
  TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const ForgotPasswordScreen(),
        ),
      );
    },
    child: const Text(
      "Forgot Password?",
    ),
  ),

  const SizedBox(height: 12),

  const SizedBox(height: 12),

  SizedBox(
    width: double.infinity,
    height: 54,
    child: OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Google Sign-In coming soon",
            ),
          ),
        );
      },
      icon: const Icon(Icons.login),
      label: const Text(
        "Continue with Google",
      ),
    ),
  ),

  const SizedBox(height: 24),

  const SizedBox(height: 24),

  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Don't have an account?",
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const RegisterScreen(),
            ),
          );
        },
        child: const Text(
          "Create Account",
        ),
      ),
    ],
  ),
],
),
),
),
),
),
);
}
}