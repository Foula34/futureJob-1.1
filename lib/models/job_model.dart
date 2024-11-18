class Job {
  final String companyLogo;
  final String jobTitle;
  final String companyName; 
  final String salary;
  final String location; 
  final bool isFavorite; 
  final String employmentType; 

  Job({
    required this.companyLogo,
    required this.jobTitle,
    required this.salary,
    this.companyName = '',
    this.location = '',
    this.isFavorite = false,
    this.employmentType = 'Temps Plein',
  });
}