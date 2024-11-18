class JobItem {
  final String companyLogo;
  final String jobTitle;
  final String companyName;
  final String salary;
  final String location;
  final bool isFavorite;
  final String jobDescription; 
  final List<String> requirements; 

  JobItem({
    required this.companyLogo,
    required this.jobTitle,
    required this.salary,
    this.companyName = '',
    this.location = '',
    this.isFavorite = false,
    this.jobDescription = '',
    List<String>? requirements,
  }) : requirements = requirements ?? [];
}