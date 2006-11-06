// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/CurationTestLogger.java,v 1.9 2006-11-06 03:57:19 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.test;

import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 * @author lhebel
 *
 */
public class CurationTestLogger
{
    public CurationTestLogger()
    {
        _name = "unknown";
    }

    public CurationTestLogger(Class class_)
    {
        _name = class_.getName();
    }
    
    public CurationTestLogger(String xml_)
    {
        DOMConfigurator.configure(xml_);
    }
    
    public void initLogger(String xml_)
    {
        DOMConfigurator.configure(xml_);
    }
    
    public void info(String msg_)
    {
        _logger.info(msg_);
    }
    
    public void section(String msg_)
    {
        _logger.info(" ");
        _logger.info(msg_);
    }
    
    public void warn(String msg_)
    {
        ++_warn;
        _logger.warn(msg_);
    }
    
    public void fatal(String msg_)
    {
        ++_error;
        _logger.fatal(msg_);
    }
    
    public void fatal(String msg_, Exception ex_)
    {
        ++_error;
        _logger.fatal(msg_, ex_);
    }
    
    public void start()
    {
        _start = System.currentTimeMillis();
        _logger.info("Starting Tests " + _name + " ------------------------------------------------------------------------------------------------");
        _logger.info(" ");
    }
    
    public void end()
    {
        long end = System.currentTimeMillis();
        end -= _start;
        long days = end / (24 * 60 * 60 * 1000);
        end -= days * (24 * 60 * 60 * 1000);
        long hours = end / (60 * 60 * 1000);
        end -= hours * (60 * 60 * 1000);
        long mins = end / (60 * 1000);
        end -= mins * (60 * 1000);
        long secs = end / 1000;
        end -= secs * 1000;
        String mills = String.valueOf(end);
        
        String elapsed = String.valueOf(days) + ":" + String.valueOf(hours) + ":" + String.valueOf(mins) + ":" + String.valueOf(secs) + "." + "000".substring(mills.length()) + mills;

        _logger.info(" ");
        _logger.info(" ");
        if (_warn > 0)
            _logger.warn("Warnings: " + _warn);
        if (_error > 0)
            _logger.fatal("Errors: " + _error);
        _logger.info("Ending Tests " + _name + " (elapsed time " + elapsed + ") ------------------------------------------------------------------------------------------------");
        _warn = 0;
        _error = 0;
    }

    protected int _warn;
    
    protected int _error;
    
    protected String _name;
    
    protected long _start;
    
    private static final Logger _logger = Logger.getLogger("gov.nih.nci.cadsr.cdecurate");
}
