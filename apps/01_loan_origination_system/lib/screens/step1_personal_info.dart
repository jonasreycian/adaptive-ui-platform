import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/loan_application.dart';
import '../theme/app_theme.dart';
import '../viewmodels/loan_form_viewmodel.dart';
import '../widgets/common_widgets.dart';

class PersonalInfoStep extends StatefulWidget {
  final LoanFormViewModel viewModel;

  const PersonalInfoStep({super.key, required this.viewModel});

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _dobCtrl;
  late TextEditingController _nationalIdCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _postalCtrl;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final app = widget.viewModel.application;
    _firstNameCtrl = TextEditingController(text: app.firstName);
    _lastNameCtrl = TextEditingController(text: app.lastName);
    _dobCtrl = TextEditingController(text: app.dateOfBirth);
    _nationalIdCtrl = TextEditingController(text: app.nationalId);
    _emailCtrl = TextEditingController(text: app.email);
    _phoneCtrl = TextEditingController(text: app.phone);
    _addressCtrl = TextEditingController(text: app.address);
    _cityCtrl = TextEditingController(text: app.city);
    _stateCtrl = TextEditingController(text: app.state);
    _postalCtrl = TextEditingController(text: app.postalCode);
    _selectedGender = app.gender.isEmpty ? null : app.gender;
  }

  @override
  void dispose() {
    for (final c in [
      _firstNameCtrl,
      _lastNameCtrl,
      _dobCtrl,
      _nationalIdCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _cityCtrl,
      _stateCtrl,
      _postalCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      final app = widget.viewModel.application;
      app.firstName = _firstNameCtrl.text.trim();
      app.lastName = _lastNameCtrl.text.trim();
      app.dateOfBirth = _dobCtrl.text.trim();
      app.gender = _selectedGender ?? '';
      app.nationalId = _nationalIdCtrl.text.trim();
      app.email = _emailCtrl.text.trim();
      app.phone = _phoneCtrl.text.trim();
      app.address = _addressCtrl.text.trim();
      app.city = _cityCtrl.text.trim();
      app.state = _stateCtrl.text.trim();
      app.postalCode = _postalCtrl.text.trim();
      widget.viewModel.nextStep();
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final minDate = DateTime(now.year - 80);
    final maxDate = DateTime(now.year - 18);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 30),
      firstDate: minDate,
      lastDate: maxDate,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.textOnPrimary,
            secondary: AppColors.accent,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dobCtrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Personal Information',
            subtitle: 'Tell us about yourself',
            icon: Icons.person_outline,
          ),

          // Name row
          Row(
            children: [
              Expanded(
                child: AppFormField(
                  label: 'First Name',
                  isRequired: true,
                  child: TextFormField(
                    controller: _firstNameCtrl,
                    decoration: const InputDecoration(hintText: 'John'),
                    textCapitalization: TextCapitalization.words,
                    validator: _requiredValidator('First name'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppFormField(
                  label: 'Last Name',
                  isRequired: true,
                  child: TextFormField(
                    controller: _lastNameCtrl,
                    decoration: const InputDecoration(hintText: 'Doe'),
                    textCapitalization: TextCapitalization.words,
                    validator: _requiredValidator('Last name'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),

          // DOB & Gender row
          Row(
            children: [
              Expanded(
                child: AppFormField(
                  label: 'Date of Birth',
                  isRequired: true,
                  child: TextFormField(
                    controller: _dobCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'YYYY-MM-DD',
                      suffixIcon: Icon(Icons.calendar_today,
                          size: 18, color: AppColors.primary),
                    ),
                    onTap: _pickDate,
                    validator: _requiredValidator('Date of birth'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppFormField(
                  label: 'Gender',
                  isRequired: true,
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    hint: const Text('Select'),
                    items: genderOptions
                        .map((g) => DropdownMenuItem(
                              value: g,
                              child: Text(g),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedGender = v),
                    validator: (v) => v == null ? 'Gender is required' : null,
                    decoration: const InputDecoration(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),

          // National ID
          AppFormField(
            label: 'National ID / Passport Number',
            isRequired: true,
            child: TextFormField(
              controller: _nationalIdCtrl,
              decoration: InputDecoration(
                hintText: 'e.g. 123-45-6789',
                prefixIcon:
                    Icon(Icons.badge_outlined, color: AppColors.primary),
              ),
              validator: _requiredValidator('National ID'),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Email & Phone
          Row(
            children: [
              Expanded(
                child: AppFormField(
                  label: 'Email Address',
                  isRequired: true,
                  child: TextFormField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(
                      hintText: 'john@example.com',
                      prefixIcon:
                          Icon(Icons.email_outlined, color: AppColors.primary),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppFormField(
                  label: 'Phone Number',
                  isRequired: true,
                  child: TextFormField(
                    controller: _phoneCtrl,
                    decoration: InputDecoration(
                      hintText: '+1 555 0100',
                      prefixIcon:
                          Icon(Icons.phone_outlined, color: AppColors.primary),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[\d\s\+\-\(\)]')),
                    ],
                    validator: _requiredValidator('Phone'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          const SectionHeader(
            title: 'Residential Address',
            subtitle: 'Your current home address',
            icon: Icons.home_outlined,
          ),

          AppFormField(
            label: 'Street Address',
            isRequired: true,
            child: TextFormField(
              controller: _addressCtrl,
              decoration: InputDecoration(
                hintText: '123 Main Street, Apt 4B',
                prefixIcon:
                    Icon(Icons.location_on_outlined, color: AppColors.primary),
              ),
              textCapitalization: TextCapitalization.words,
              validator: _requiredValidator('Address'),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppFormField(
                  label: 'City',
                  isRequired: true,
                  child: TextFormField(
                    controller: _cityCtrl,
                    decoration: const InputDecoration(hintText: 'New York'),
                    textCapitalization: TextCapitalization.words,
                    validator: _requiredValidator('City'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppFormField(
                  label: 'State',
                  isRequired: true,
                  child: TextFormField(
                    controller: _stateCtrl,
                    decoration: const InputDecoration(hintText: 'NY'),
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    validator: _requiredValidator('State'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppFormField(
                  label: 'Postal Code',
                  isRequired: true,
                  child: TextFormField(
                    controller: _postalCtrl,
                    decoration: const InputDecoration(hintText: '10001'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: _requiredValidator('Postal code'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          NavigationButtons(
            isFirstStep: true,
            isLastStep: false,
            onBack: () {},
            onNext: _saveAndContinue,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Validators
  // ---------------------------------------------------------------------------
  FormFieldValidator<String> _requiredValidator(String field) => (value) =>
      (value == null || value.trim().isEmpty) ? '$field is required' : null;

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final re = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!re.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }
}
