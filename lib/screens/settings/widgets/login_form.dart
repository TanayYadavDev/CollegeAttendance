import 'package:flutter/material.dart';
import 'dart:ui';

class LoginForm extends StatefulWidget {
	const LoginForm({
		super.key,
		required this.onLogin,
		this.isLoading = false,
	});

	final Future<bool> Function(String registrationNo, String password) onLogin;
	final bool isLoading;

	@override
	State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
	final _formKey = GlobalKey<FormState>();
	final _usernameController = TextEditingController();
	final _passwordController = TextEditingController();

	@override
	void dispose() {
		_usernameController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	Future<void> _submit() async {
		if (_formKey.currentState?.validate() ?? false) {
			final isSuccess = await widget.onLogin(
				_usernameController.text,
				_passwordController.text,
			);

			if (!mounted) {
				return;
			}

			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(
					content: Text(
						isSuccess ? 'Login successful' : 'Invalid registration no or password',
					),
				),
			);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Form(
			key: _formKey,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					TextFormField(
						controller: _usernameController,
						style: const TextStyle(
							color: Colors.white,
						),
						decoration: InputDecoration(
							labelText: 'Registration No',
							labelStyle: const TextStyle(
								color: Colors.white,
							),
							prefixIcon: const Icon(
								Icons.person_outline,
								color: Colors.white70,
							),
							enabledBorder: const UnderlineInputBorder(
								borderSide: BorderSide(
									color: Colors.white54,
								),
							),
							focusedBorder: const UnderlineInputBorder(
								borderSide: BorderSide(
									color: Colors.white,
									width: 2,
								),
							),
						),
						validator: (value) {
							if (value == null || value.trim().isEmpty) {
								return 'Please enter your registration no';
							}
							return null;
						},
					),
					const SizedBox(height: 12),
					TextFormField(
						controller: _passwordController,
						style: const TextStyle(
							color: Colors.white,
						),
						decoration: InputDecoration(
							labelText: 'Password',
							labelStyle: const TextStyle(
								color: Colors.white,
							),
							prefixIcon: const Icon(
								Icons.lock_outline,
								color: Colors.white70,
							),
							enabledBorder: const UnderlineInputBorder(
								borderSide: BorderSide(
									color: Colors.white54,
								),
							),
							focusedBorder: const UnderlineInputBorder(
								borderSide: BorderSide(
									color: Colors.white,
									width: 2,
								),
							),
						),
						obscureText: true,
						validator: (value) {
							if (value == null || value.isEmpty) {
								return 'Please enter your password';
							}
							if (value.length < 4) {
								return 'Password must be at least 4 characters';
							}
							return null;
						},
					),
					const SizedBox(height: 20),
					ClipRRect(
						borderRadius: BorderRadius.circular(32),
						child: BackdropFilter(
							filter: ImageFilter.blur(
								sigmaX: 18,
								sigmaY: 18,
							),
							child: Container(
								height: 58,
								decoration: BoxDecoration(
									borderRadius: BorderRadius.circular(32),

									// Deep frosted white
									color: const Color(0xFFF8FCFF).withValues(alpha: 0.40),

									border: Border.all(
										color: Colors.white.withValues(alpha: 0.30),
										width: 1.2,
									),

									boxShadow: [
										// Floating shadow
										BoxShadow(
											color: Colors.black.withValues(alpha: 0.12),
											blurRadius: 20,
											offset: const Offset(0, 8),
										),

										// Soft blue ambient glow
										BoxShadow(
											color: const Color(0xFFBDE3FF).withValues(alpha: 0.25),
											blurRadius: 18,
											spreadRadius: -2,
										),
									],
								),

								child: Stack(
									children: [
										// Top glass reflection
										Positioned(
											left: 10,
											right: 10,
											top: 2,
											height: 20,
											child: IgnorePointer(
												child: DecoratedBox(
													decoration: BoxDecoration(
														borderRadius: BorderRadius.circular(30),
														gradient: LinearGradient(
															begin: Alignment.topCenter,
															end: Alignment.bottomCenter,
															colors: [
																Colors.white.withValues(alpha: 0.42),
																Colors.white.withValues(alpha: 0.0),
															],
														),
													),
												),
											),
										),

										// Inner edge / refraction
										Positioned.fill(
											child: IgnorePointer(
												child: Container(
													decoration: BoxDecoration(
														borderRadius: BorderRadius.circular(32),
														border: Border.all(
															color: const Color(0xFFFFFFFF)
																	.withValues(alpha: 0.55),
															width: 1,
														),
													),
												),
											),
										),

										Material(
											color: Colors.transparent,
											child: InkWell(
												borderRadius: BorderRadius.circular(32),
												onTap: widget.isLoading ? null : _submit,
												splashColor: const Color(0xFF5BAEFF)
														.withValues(alpha: 0.16),
												highlightColor: Colors.white.withValues(alpha: 0.18),
												child: Center(
													child: widget.isLoading
															? const SizedBox(
														height: 20,
														width: 20,
														child: CircularProgressIndicator(
															strokeWidth: 2,
															color: Color(0xFF023E8A),
														),
													)
															: const Text(
														'Login',
														style: TextStyle(
															color: Color(0xFF023E8A),
															fontSize: 16,
															fontWeight: FontWeight.bold,
														),
													),
												),
											),
										),
									],
								),
							),
						),
					)
				],
			),
		);
	}
}
