package note.main;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.*;

import org.apache.catalina.Context;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

public class Main
{
  private static final String SERVER_PORT_PROP = "server.port";
  private static final int DEFAULT_PORT = 8080;
  private static final String DEFAULT_WEBAPP_DIR = "src/main/webapp/";
  private static final String DEFAULT_TARGET_CLASSES = "target/classes";
  private static final String WEB_INF_CLASSES = "/WEB-INF/classes";
  private static final String LOGFILE = "logfile.txt";
  private static final String CONTEXT_PATH = "/notesaver";

  public static Thread addShutdown(final Tomcat tomcat, final Logger logger) {
    Thread shutdownHook = new Thread(() -> {
      try {
        logger.info("Shutting down application...");
        if (tomcat != null) {
          tomcat.stop();
          tomcat.destroy();
          Thread.sleep(1000);
        }
      } catch (Exception e) {
        logger.log(Level.SEVERE, "Error shutting down Tomcat", e);
        System.exit(1);
      }
    });
    Runtime.getRuntime().addShutdownHook(shutdownHook);
    return shutdownHook;
  }

  private static Logger initialiseLogger()
  {
    Logger logger = Logger.getLogger(Main.class.getName());

    ConsoleHandler consoleHandler = new ConsoleHandler();
    consoleHandler.setLevel(Level.INFO);
    logger.addHandler(consoleHandler);

    try {
      FileHandler fileHandler = new FileHandler(LOGFILE);
      fileHandler.setFormatter(new SimpleFormatter());
      fileHandler.setLevel(Level.INFO);
      logger.addHandler(fileHandler);
    } catch (IOException e) {
      logger.log(Level.SEVERE, "Failed to create log file", e);
    }

    logger.setLevel(Level.INFO);
    return logger;
  }

  private static Context getContext(Path webappDirectory, Tomcat tomcat)
  {
    if (!Files.exists(webappDirectory) || !Files.isDirectory(webappDirectory))
    {
      throw new IllegalArgumentException("Webapp directory does not exist: " + webappDirectory);
    }
    return tomcat.addWebapp(CONTEXT_PATH, webappDirectory.toAbsolutePath().toString());
  }

  private static void setResources(Context context, Path targetClassesDirectory)
  {
    WebResourceRoot resources = new StandardRoot(context);
    resources.addPreResources(new DirResourceSet(resources, WEB_INF_CLASSES,
            targetClassesDirectory.toAbsolutePath().toString(), "/"));
    context.setResources(resources);
  }

  public static void main(String[] args) {
    final Logger logger = initialiseLogger();
    final Path webappDirectory = Paths.get(DEFAULT_WEBAPP_DIR);
    final Path targetClassesDirectory = Paths.get(DEFAULT_TARGET_CLASSES);
    final Tomcat tomcat = new Tomcat();

    try {
      int port = DEFAULT_PORT;
      String portProperty = System.getProperty(SERVER_PORT_PROP);
      if (portProperty != null && !portProperty.isEmpty()) {
        try {
          port = Integer.parseInt(portProperty);
          logger.info("Using port from system property: " + port);
        } catch (NumberFormatException e) {
          logger.warning("Invalid port specified in system property, using default: " + DEFAULT_PORT);
        }
      }

      try {
        tomcat.setPort(port);
        tomcat.setHostname("localhost");
        tomcat.getConnector();
        addShutdown(tomcat, logger);

        Context context = getContext(webappDirectory, tomcat);
        setResources(context, targetClassesDirectory);


        tomcat.start();
        logger.info("Server started successfully on port " + port);
        logger.info("Application is available at http://localhost:" + port + CONTEXT_PATH);
        tomcat.getServer().await();
      } catch (Exception e) {
        logger.log(Level.SEVERE, "Error occurred while starting the server", e);
      }
    }catch (Exception e) {
      System.exit(1);
    }
  }
}