package gov.nih.nci.cadsr.common;

import java.util.concurrent.TimeUnit;

public class TimeWatch {

	public static final boolean ENABLED = true;		//dev only
//	public static final boolean ENABLED = false;
	
	long starts;

	public static TimeWatch start() {
		return new TimeWatch();
	}

	private TimeWatch() {
		reset();
	}

	public TimeWatch reset() {
		starts = System.currentTimeMillis();
		return this;
	}

	public long time() {
		long ends = System.currentTimeMillis();
		return ends - starts;
	}

	public long time(TimeUnit unit) {
		return unit.convert(time(), TimeUnit.MILLISECONDS);
	}

}