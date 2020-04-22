class UploadCertainty{

  UploadCertainty({this.desiredString, this.levenshteinThreshold});

  final String desiredString;

  // The levenshtein threshold calculated for this string against the current string
  // If the value calculated is less than this, then we do not want to go and try 
  // and find the value.
  final int levenshteinThreshold;

  String resultText;
}