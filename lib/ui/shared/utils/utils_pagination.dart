// PAGINATION
class PaginationUtils {
  static int defaultRowPage = 0;
  static int currentPage = 1;
  static int rowsPerPage = 15;

  static bool isPrevButtonEnabled() {
    return currentPage > 1;
  }

  static bool isNextButtonEnabled(List<dynamic> data) {
    return (currentPage * rowsPerPage) < data.length;
  }

  static void decrementPage(Function setStateCallback, Function decrementDataCallback) {
    setStateCallback(() {
      currentPage--;
      decrementDataCallback();
    });
  }

  static void incrementPage(Function setStateCallback, Function incrementDataCallback) {
    setStateCallback(() {
      currentPage++;
      incrementDataCallback();
    });
  }

  static void rowPaginate(String row, Function setStateCallback, Function rowDataCallback) {
    setStateCallback(() {
      rowsPerPage = row.isNotEmpty ? int.tryParse(row) ?? defaultRowPage : defaultRowPage;
      currentPage = 1;
      rowDataCallback(); // Call the provided function
    });
  }

  static String numberDisplayMobile(List<dynamic> data) {
    return '${(currentPage - 1) * rowsPerPage + 1} - ${(currentPage * rowsPerPage) > data.length ? data.length : (currentPage * rowsPerPage)}';
  }

  static String numberDisplayWeb(List<dynamic> data) {
    return '${(currentPage - 1) * rowsPerPage + 1} - ${(currentPage * rowsPerPage) > data.length ? data.length : (currentPage * rowsPerPage)} of ${data.length}';
  }
}
