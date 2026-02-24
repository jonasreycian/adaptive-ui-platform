// ---------------------------------------------------------------------------
// Loan Application Data Model
// ---------------------------------------------------------------------------
class LoanApplicationModel {
  // Step 1 – Personal Information
  String firstName;
  String lastName;
  String dateOfBirth;
  String gender;
  String nationalId;
  String email;
  String phone;
  String address;
  String city;
  String state;
  String postalCode;

  // Step 2 – Employment Details
  String employmentType;
  String employerName;
  String jobTitle;
  String monthlyIncome;
  String yearsEmployed;

  // Step 3 – Loan Details
  String loanPurpose;
  String loanAmount;
  String loanTenure;
  String collateralType;

  LoanApplicationModel({
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.nationalId = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.employmentType = '',
    this.employerName = '',
    this.jobTitle = '',
    this.monthlyIncome = '',
    this.yearsEmployed = '',
    this.loanPurpose = '',
    this.loanAmount = '',
    this.loanTenure = '',
    this.collateralType = '',
  });

  Map<String, dynamic> toJson() => {
        'personalInfo': {
          'firstName': firstName,
          'lastName': lastName,
          'dateOfBirth': dateOfBirth,
          'gender': gender,
          'nationalId': nationalId,
          'email': email,
          'phone': phone,
          'address': address,
          'city': city,
          'state': state,
          'postalCode': postalCode,
        },
        'employmentDetails': {
          'employmentType': employmentType,
          'employerName': employerName,
          'jobTitle': jobTitle,
          'monthlyIncome': monthlyIncome,
          'yearsEmployed': yearsEmployed,
        },
        'loanDetails': {
          'loanPurpose': loanPurpose,
          'loanAmount': loanAmount,
          'loanTenure': loanTenure,
          'collateralType': collateralType,
        },
      };
}

// ---------------------------------------------------------------------------
// Loan Purpose Options
// ---------------------------------------------------------------------------
const List<String> loanPurposeOptions = [
  'Home Purchase',
  'Home Renovation',
  'Auto Loan',
  'Education',
  'Business Capital',
  'Debt Consolidation',
  'Medical Expenses',
  'Personal/Travel',
  'Other',
];

const List<String> employmentTypeOptions = [
  'Full-Time Employee',
  'Part-Time Employee',
  'Self-Employed',
  'Freelancer / Contractor',
  'Business Owner',
  'Retired',
  'Unemployed',
];

const List<String> genderOptions = [
  'Male',
  'Female',
  'Non-binary',
  'Prefer not to say',
];

const List<String> collateralOptions = [
  'None (Unsecured)',
  'Real Estate',
  'Vehicle',
  'Savings Account',
  'Investment Portfolio',
  'Other',
];

const List<String> tenureOptions = [
  '6 months',
  '12 months',
  '18 months',
  '24 months',
  '36 months',
  '48 months',
  '60 months',
  '84 months',
  '120 months',
  '180 months',
  '240 months',
  '360 months',
];
