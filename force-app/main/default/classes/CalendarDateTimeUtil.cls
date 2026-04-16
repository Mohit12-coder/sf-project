public class CalendarDateTimeUtil {

    public static String toRfc3339(Datetime dt) {
        if (dt == null) {
            return null;
        }

        TimeZone tz = UserInfo.getTimeZone();
        Integer offsetMs = tz.getOffset(dt);

        Integer offsetSeconds = offsetMs / 1000;

        // Adjust datetime to local timezone
        Datetime localDt = dt.addSeconds(offsetSeconds);

        String base = localDt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss');

        Integer totalMinutes = Math.abs(offsetMs / 60000);
        Integer hours = totalMinutes / 60;
        Integer mins = Math.mod(totalMinutes, 60);

        String sign = offsetMs >= 0 ? '+' : '-';
        String offset = sign + pad2(hours) + ':' + pad2(mins);

        return base + offset;
    }

    private static String pad2(Integer n) {
        return (n < 10 ? '0' : '') + String.valueOf(n);
    }
}