// Copyright (c) 2007 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/util/ClockTime.java,v 1.2 2007-05-23 23:16:05 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.util;

/**
 * Provide a way to record and calculate elapsed time.
 * 
 * @author lhebel
 *
 */
public class ClockTime
{
    private long _createTime;
    private long _checkPoint;

    /**
     * Constructor
     */
    public ClockTime()
    {
        _createTime = System.currentTimeMillis();
        _checkPoint = _createTime;
    }
    
    /**
     * Get the time this object has been alive, ie in existance.
     * 
     * @return the life time of the object.
     */
    public long lifeTime()
    {
        return System.currentTimeMillis() - _createTime;
    }

    /**
     * Return the time since the last check point. On the first call this
     * is the same value as would be returned from lifeTime(), afterward this method will
     * always return a value less than lifeTime().
     * 
     * @return the time elapsed since the last checkPoint() call
     */
    public long checkPoint()
    {
        long time = System.currentTimeMillis();
        long rt = time - _checkPoint;
        _checkPoint = time;
        return rt;
    }
    
    /**
     * Reset the life time clock and return the time since creation or the last reset. This
     * will also reset the last check point time.
     * 
     * @return the life time of the object.
     */
    public long reset()
    {
        long time = System.currentTimeMillis();
        long rt = time - _createTime;
        _createTime = time;
        _checkPoint = _createTime;
        return rt;
    }
    
    /**
     * Return the life time value as a String.
     * 
     * @return the object life time
     */
    public String toStringLifeTime()
    {
        return toString(lifeTime());
    }
    
    /**
     * Return the check point value as a String
     * 
     * @return the check point time
     */
    public String toStringCheckPoint()
    {
        return toString(checkPoint());
    }
    
    /**
     * Conver the time to a string in the form HH:MM:SS.TT (hours : minutes : seconds . thousands)
     * 
     * @param time_ the time
     * @return the time as a string
     */
    public static String toString(long time_)
    {
        int cHours = 3600000;
        int cMins = 60000;
        int cSec = 1000;
        long hours = time_ / cHours;
        time_ = time_ % cHours;
        long mins = time_ / cMins;
        time_ = time_ % cMins;
        long secs = time_ / cSec;
        time_ = time_ % cSec;
        return hours + ":" + mins + ":" + secs + "." + time_ + " (h:m:s)";
    }
}
