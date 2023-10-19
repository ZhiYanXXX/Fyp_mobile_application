String convertTime(String minutes) {
  if (minutes.length == 1) {
    // If the input string has only one character (i.e., a single digit),
    // add a leading "0" to make it two characters.
    return "0$minutes";
  } else {
    // If the input string already has two or more characters,
    // leave it unchanged.
    return minutes;
  }
}
