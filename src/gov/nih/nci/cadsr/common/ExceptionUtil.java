package gov.nih.nci.cadsr.common;

public class ExceptionUtil {

	private static final String HINT_ORA_01403 = "Have 'grant execute' been executed? For example: GRANT EXECUTE ON \"SBREXT\".\"VALID_VALUE_LIST_T\" TO CDECURATE;";

	public static final String createFriendlyErrorMessage(Throwable e) {
		String msg = null;
		if(e != null && e.getMessage().indexOf("") > -1) {
			//c.f. https://github.com/NCIP/cadsr-cdecurate/blob/master/db-sql/customDownload.sql
			msg = HINT_ORA_01403;
			//System.out.println(msg);
		}
		
		return msg;
	}
}
