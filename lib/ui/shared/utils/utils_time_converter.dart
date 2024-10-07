int convertTimeToSeconds(int timeValue, String timeUnit) {
  switch (timeUnit.toLowerCase()) {
    case 'seconds':
      return timeValue;
    case 'minutes':
      return timeValue * 60;
    case 'hours':
      return timeValue * 3600;
    case 'days':
      return timeValue * 86400;
    default:
      throw ArgumentError('Invalid time unit: $timeUnit');
  }
}
