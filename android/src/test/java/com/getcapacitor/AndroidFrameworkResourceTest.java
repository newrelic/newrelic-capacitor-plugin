package com.getcapacitor;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.junit.Test;

/**
 * The native Android agent reads these string resources to learn the framework and its version when the app
 * starts the agent natively before Capacitor code runs. They are plain XML, so nothing derives them from
 * package.json; this test is what stops them going stale. Gradle runs unit tests from the android/ directory.
 */
public class AndroidFrameworkResourceTest {

    private static String resource(String file, String name) throws IOException {
        String xml = new String(Files.readAllBytes(Paths.get("src/main/res/values", file)), StandardCharsets.UTF_8);
        Matcher matcher = Pattern.compile("<string name=\"" + name + "\"[^>]*>([^<]*)</string>").matcher(xml);
        assertTrue(name + " is missing from " + file, matcher.find());
        return matcher.group(1).trim();
    }

    @Test
    public void theFrameworkResourceNamesThisPluginAsCapacitor() throws IOException {
        assertEquals("Capacitor", resource("com_newrelic_application_framework.xml", "com_newrelic_application_framework"));
    }

    @Test
    public void theFrameworkVersionResourceEqualsThePackageVersion() throws IOException {
        String packageJson = new String(Files.readAllBytes(Paths.get("..", "package.json")), StandardCharsets.UTF_8);
        Matcher matcher = Pattern.compile("\"version\"\\s*:\\s*\"([^\"]+)\"").matcher(packageJson);
        assertTrue("package.json has no version", matcher.find());

        assertEquals(
            "update_native_agent.yml should bump the resource with package.json",
            matcher.group(1),
            resource("com_newrelic_application_framework_version.xml", "com_newrelic_application_framework_version")
        );
    }
}
