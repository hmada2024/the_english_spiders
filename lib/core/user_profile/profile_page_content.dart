//lib/core/user_profile/profile_page_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/core/user_profile/user_cubit.dart';
import 'package:the_english_spiders/data/models/user_model.dart';
import 'package:the_english_spiders/core/user_profile/edit_profile_form.dart';
import 'package:the_english_spiders/core/user_profile/login_registration_section.dart';
import 'package:the_english_spiders/core/user_profile/profile_header.dart';
import 'package:the_english_spiders/core/user_profile/profile_options.dart';
import 'package:the_english_spiders/core/user_profile/quiz_result_card.dart';
import 'package:the_english_spiders/data/models/quiz_result_model.dart'; // NEW

class ProfilePageContent extends StatefulWidget {
  final UserModel? currentUser;

  const ProfilePageContent({super.key, this.currentUser});

  @override
  State<ProfilePageContent> createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureCurrentPassword = true;
  bool _isEditing = false;
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

    // Placeholder data - REPLACE with data from your database
    List<QuizResultModel> _quizResults = [];

  _ProfilePageContentState() {
    debugPrint("ProfilePageContentState: Constructor called"); // أضف هنا
  }

  @override
  void initState() {
    super.initState();
    debugPrint("ProfilePageContentState: initState called"); // أضف هنا
    _animationController = AnimationController(
      duration: AppConstants.animationDurationMedium,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();

    // Fetch data (replace with your actual database logic)
    _fetchQuizResults();

    _nameController.text = widget.currentUser?.name ?? '';
    _passwordController.text = widget.currentUser?.password ?? '';
  }

    // Placeholder data loading
  Future<void> _fetchQuizResults() async {
    debugPrint("ProfilePageContentState: _fetchQuizResults called"); // أضف هنا
        if (widget.currentUser == null) {
          debugPrint("ProfilePageContentState: currentUser is null, skipping fetch.");
          return;
        }
    try {

        _quizResults = [
            QuizResultModel(
                quizType: "Nouns",
                userId: widget.currentUser?.id, // <-- Add userId
                subQuizzes: [
                    SubQuizResult(quizSubType: "Choose Image", score: 12, totalQuestions: 20, correctAnswers: 12),
                    SubQuizResult(quizSubType: "Choose Word", score: 8, totalQuestions: 15, correctAnswers: 8),
                ],
            ),
            QuizResultModel(
                quizType: "Adjectives",
                userId: widget.currentUser?.id, // <-- Add userId
                subQuizzes: [
                    SubQuizResult(quizSubType: "Adjective Quiz", score: 18, totalQuestions: 25, correctAnswers: 18),
                ],
            ),
            // Add more placeholder data as needed...
        ];
        debugPrint("ProfilePageContentState: Quiz results fetched: $_quizResults"); // أضف هنا

    } catch (e) {
      debugPrint("ProfilePageContentState: Error fetching quiz results: $e"); // أضف هنا
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(UserModel currentUser) async {
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;

      if (_currentPasswordController.text.trim() != currentUser.password) {
        _showSnackBar('Current Password doesn\'t match.',
            Theme.of(context).colorScheme.error);
        return;
      }

      final updatedUser = _getUpdatedUser(currentUser);

      try {
        await BlocProvider.of<UserCubit>(context).updateUser(updatedUser);
        if (!mounted) return;
        _showSnackBar('Profile updated successfully.',
            Theme.of(context).colorScheme.secondary);
      } catch (e) {
        // Check mounted before accessing context
        if (!mounted) return;
        _showSnackBar('Failed to update profile: $e',
            Theme.of(context).colorScheme.error);
      } finally {
        if (mounted) {
          setState(() {
            _isEditing = false;
          });
        }
      }
    }
  }

  UserModel _getUpdatedUser(UserModel currentUser) {
    return currentUser.copyWith(
      name: _nameController.text.trim().isEmpty
          ? currentUser.name
          : _nameController.text.trim(),
      password: _passwordController.text.trim().isEmpty
          ? currentUser.password
          : _passwordController.text.trim(),
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
      debugPrint("ProfilePageContentState: build method called"); // أضف هنا
    final screenWidth = ScreenSize.getWidth(context);
    final screenHeight = ScreenSize.getHeight(context);
    Theme.of(context);

    debugPrint("Current User Data: ${widget.currentUser}"); // أضف هنا

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildProfileHeader(),
                  _buildProfileOptionsOrEditForm(),
                  const SizedBox(height: AppConstants.marginLarge),
                    _buildQuizResultsSection(screenWidth),
                  //_buildQuizResultsCard(screenWidth), // REMOVED
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.currentUser == null
            ? LoginRegistrationSection(onLoginSuccess: (_) {})
            : ProfileHeader(currentUser: widget.currentUser!),
      ),
    );
  }

  Widget _buildProfileOptionsOrEditForm() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: AnimatedSwitcher(
          duration: AppConstants.animationDurationMedium,
          transitionBuilder: (child, animation) {
            return SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1.0,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: widget.currentUser == null
              ? const SizedBox.shrink()
              : !_isEditing
                  ? ProfileOptions(onEditProfileTap: _handleEditProfileTap)
                  : EditProfileForm(
                      nameController: _nameController,
                      passwordController: _passwordController,
                      currentPasswordController: _currentPasswordController,
                      onSubmit: () => _submitForm(widget.currentUser!),
                      onCancel: () => setState(() {
                        _isEditing = false;
                      }),
                      obscureCurrentPassword: _obscureCurrentPassword,
                      obscurePassword: _obscurePassword,
                      onCurrentPasswordToggle: _handleCurrentPasswordToggle,
                      onPasswordToggle: _handlePasswordToggle,
                    ),
        ),
      ),
    );
  }

   Widget _buildQuizResultsSection(double screenWidth) {
        return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
                position: _slideAnimation,
                child: Card(
                  elevation: AppConstants.defaultElevation,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge)),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Column(
                        children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child:   Text("Quiz Results", style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface))
                            ),
                            ..._quizResults.map((result) => QuizResultCard(quizResult: result)),
                        ]
                      ),

                  ),
                ),
            ),
        );
    }


  void _handleEditProfileTap() {
    setState(() {
      _isEditing = true;
    });
    _nameController.text = widget.currentUser!.name;
    _passwordController.text = widget.currentUser!.password ?? '';
  }

  void _handleCurrentPasswordToggle(bool isVisible) {
    setState(() {
      _obscureCurrentPassword = isVisible;
    });
  }

  void _handlePasswordToggle(bool isVisible) {
    setState(() {
      _obscurePassword = isVisible;
    });
  }
}