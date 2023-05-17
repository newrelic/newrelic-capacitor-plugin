package com.newrelic.capacitor.plugin;

public class NewRelicCapacitorException extends Exception {
    public NewRelicCapacitorException(String message, StackTraceElement[] stackTraceElements) {
        super(message);
        setStackTrace(stackTraceElements);
    }
}
