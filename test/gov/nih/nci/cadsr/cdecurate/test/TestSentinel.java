package gov.nih.nci.cadsr.cdecurate.test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;

public class TestSentinel {

	//=== the following will cause cert error
	//private String _url = "https://cadsrsentinel-dev.nci.nih.gov/cadsrsentinel/do/crf?version=1&user=SHIDED&idseq=C417FF39-E7FE-9A60-E040-BB89AD4325FF";
	//=== the following will cause error "ava.sql.SQLException: ORA-06502: PL/SQL: numeric or value error: character string buffer too small ORA-06512: at "SBR.CG$ERRORS", line 53" + the cert error
	private String _url = "https://cadsrsentinel-dev.nci.nih.gov/cadsrsentinel/do/crf?version=1&user=CAMPBELB&idseq=1F147208-BDAD-49CA-E044-0003BA3F9857";
	private String _alertName;
	private int _rc;

	public void testGF7680(String connXML,
			CurationTestLogger logger1) throws Exception {
		TestConnections varCon = new TestConnections(connXML, logger1);
		Connection conn = null;
		conn = varCon.openConnection();
        System.out.println("connected");

        createAlert("GUEST", "152EA5B8-98B3-4A40-E044-0003BA3F9857");
		
	}
	
		//called doMonitor(String user, String idseqToMonitor ) with "GUEST" and idseqToMonitor "B49FDEC1-ABEB-801B-E040-BB89AD43170D"
		//"GUEST" and "B49FDEC1-ABEB-801B-E040-BB89AD43170D"	//36 characters
		//called createAlert with "GUEST" and csi_idseq "152EA5B8-98B3-4A40-E044-0003BA3F9857" based on the above idseqToMonitor
		//                    ndx = sentinel.createAlert(user, csi_idseq);
		/**
		 * THIS IS NOT A REAL METHOD! It is taken directly from Sentinel's (https://github.com/NCIP/cadsr-sentinal) gov.nih.nci.cadsr.sentinel.util.DSRAlertV1
		 *
		 * @param user_
		 * @param idseq_
		 * @return
		 */
		public int createAlert(String user_, String idseq_) {
			String url = this._url + "crf?version=" + "1" + "&user=" + user_
					+ "&idseq=" + idseq_;

			int rc = -1;
			this._alertName = "";
			if ((user_ != null) && (user_.length() > 0) && (idseq_ != null)
					&& (idseq_.length() > 0)) {
				HttpURLConnection http = null;
				try {
					boolean writeToLog = false;
					URL rps = new URL(url);
					http = (HttpURLConnection) rps.openConnection();
					http.setUseCaches(false);
					InputStream iStream = http.getInputStream();
					int response = http.getResponseCode();

					switch (response) {
					case 302:
					case 303:
						System.out.println("Original URL " + url + " ["
								+ http.getResponseCode() + " : "
								+ http.getResponseMessage() + "]");
						url = http.getHeaderField("Location");
						System.out.println("Redirect URL " + url + " ["
								+ http.getResponseCode() + " : "
								+ http.getResponseMessage() + "]");

						http.disconnect();

						rps = new URL(url);
						http = (HttpURLConnection) rps.openConnection();
						http.setUseCaches(false);
						iStream = http.getInputStream();
						response = http.getResponseCode();
					}

					switch (response) {
					case 501:
						rc = -2;
						break;
					case 201:
						rc = 1;
						break;
					case 200:
						rc = 0;
						break;
					case 403:
						rc = -3;
						break;
					default:
						rc = -1;
						System.err.println(url + " [" + http.getResponseCode() + " : "
								+ http.getResponseMessage() + "]");
					}

					if (rc >= 0) {
						BufferedReader in = new BufferedReader(
								new InputStreamReader(iStream));
						while (true) {
							String line = in.readLine();
							if (line == null)
								break;
							line = line.trim();
							this._alertName = line;
							if (writeToLog)
								System.out.println(line);
						}
					}
				} catch (MalformedURLException ex) {
					System.out.println("[" + url + "] " + ex.toString());
				} catch (IOException ex) {
					System.out.println("[" + url + "] " + ex.toString());
				} finally {
					if (http != null) {
						http.disconnect();
					}
				}
			}
			this._rc = rc;
			return rc;
		}
}
