class StringHelper{
  static String twoDigitStringFormatDouble(double val) {
    int intVal = val.toInt();
    if (intVal < 10) {
      return "0$intVal";
    } else {
      return "$intVal";
    }
  }
  @override
  static String twoDigitStringFormatInt(int val){
    if (val < 10) {
      return "0$val";
    } else {
      return "$val";
    }
  }
}